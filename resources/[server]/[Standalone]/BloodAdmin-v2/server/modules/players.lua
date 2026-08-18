-- ============================================================
--  BLOODADMIN — SERVER/MODULES/PLAYERS.LUA
-- ============================================================

ActiveJails = {}
ActiveGhosts = {}

Citizen.CreateThread(function()
    Wait(2000)
    loadActiveSanctions()
end)

function loadActiveSanctions()
    MySQL.query('SELECT * FROM bl_jails', {}, function(result)
        local now = os.time()
        for _, row in ipairs(result) do
            if row.expires_at > now then
                ActiveJails[row.identifier] = { name = row.name, admin = row.admin, expires = row.expires_at }
            else
                MySQL.update('DELETE FROM bl_jails WHERE id = ?', {row.id})
            end
        end
    end)
    MySQL.query('SELECT * FROM bl_ghosts', {}, function(result)
        for _, row in ipairs(result) do
            ActiveGhosts[row.identifier] = { name = row.name, admin = row.admin, time = row.created_at }
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        Wait(10000) -- Vérification toutes les 10 secondes
        local now = os.time()
        local changed = false
        
        for identifier, jail in pairs(ActiveJails) do
            if now >= jail.expires then
                ActiveJails[identifier] = nil
                changed = true
                MySQL.update('DELETE FROM bl_jails WHERE identifier = ?', {identifier})
                
                -- Si le joueur est en ligne, on le libère
                for _, id in ipairs(GetPlayers()) do
                    local ids = getIdentifiers(id)
                    local pId = ids.steam ~= '' and ids.steam or ids.license
                    if pId == identifier then
                        local targetId = tonumber(id)
                        TriggerClientEvent('bl_admin:doTeleport', targetId, 168.1, -1016.8, 29.3)
                        TriggerClientEvent('bl_admin:notify', targetId, 'success', 'Votre peine de prison est terminée. Vous êtes libre.')
                        TriggerClientEvent('bl_admin:unjail', targetId)
                        break
                    end
                end
                print('[bl_admin] Auto-unjail: Peine terminée pour ' .. identifier)
            end
        end
        
        -- Si au moins un joueur a été libéré, on met à jour l'interface des admins
        if changed then
            for adminSrc, _ in pairs(AdminPlayers) do
                TriggerClientEvent('bl_admin:updateJails', adminSrc, ActiveJails)
            end
        end
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    local src = tonumber(source)
    if not xPlayer then return end
    local ids = getIdentifiers(src)
    local identifier = ids.steam ~= '' and ids.steam or ids.license
    if not identifier or identifier == '' then return end
    
    -- Track new player and save all their connection identifiers (license, steam, IP, fivem/CFX, discord)
    local cleanIdent = cleanMulticharIdentifier(identifier)
    MySQL.query("INSERT INTO bl_players_seen (identifier, steam, ip, fivem, discord) VALUES (?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE steam = VALUES(steam), ip = VALUES(ip), fivem = VALUES(fivem), discord = VALUES(discord)", {
        cleanIdent, ids.steam, ids.ip, ids.fivem, ids.discord
    }, function(res)
        -- In MySQL, INSERT is affectedRows = 1, UPDATE is affectedRows = 2.
        -- If affectedRows == 1, it means a brand new player connected for the first time.
        if res and res.affectedRows == 1 then
            newPlayersTodayCount = (newPlayersTodayCount or 0) + 1
            
            -- Broadcast updated server metrics with the new count to all staff
            local totalPlayers = #GetPlayers()
            local simulated = GetSimulatedServerMetrics()
            local metrics = {
                totalPlayers = totalPlayers,
                serverMem    = simulated.serverMem,
                fxMem        = simulated.fxMem,
                nodeMem      = simulated.nodeMem,
                ping         = 0, -- individual client handles their own ping display
                totalReports = totalReportsCount or 0,
                newPlayersToday = newPlayersTodayCount,
                staffInService = getStaffInServiceCount()
            }
            
            for adminSrc, _ in pairs(AdminPlayers) do
                metrics.ping = GetPlayerPing(adminSrc)
                TriggerClientEvent('bl_admin:updateServerMetrics', adminSrc, metrics)
            end
        end
    end)

    if ActiveJails[identifier] then
        local jail = ActiveJails[identifier]
        if jail.expires > os.time() then
            local jailCoords = { x = 1680.1, y = 2513.0, z = 45.5 }
            TriggerClientEvent('bl_admin:jail', src, jailCoords, jail.expires)
        else
            ActiveJails[identifier] = nil
            MySQL.update('DELETE FROM bl_jails WHERE identifier = ?', {identifier})
        end
    end
    
    if ActiveGhosts[identifier] then
        SetPlayerRoutingBucket(src, src + 1000)
        TriggerClientEvent('bl_admin:ghostMode', src, true)
    end
    
    -- Broadcast updated players list to all online admins
    BroadcastPlayers()
end)

function buildPlayerList()
    local players = {}
    for _, src in ipairs(GetPlayers()) do
        local pid = tonumber(src)
        local ids = getIdentifiers(pid)
        players[#players + 1] = {
            id    = pid,
            name  = GetPlayerName(pid),
            ping  = GetPlayerPing(pid),
            grade = AdminPlayers[pid] or '',
            identifiers = ids,
        }
    end
    return players
end

function getFilteredPlayersForAdmin(adminSrc)
    local players = buildPlayerList()
    if checkPermission(adminSrc, 'bl.viewip') then
        return players
    end
    
    local filteredPlayers = {}
    for _, p in ipairs(players) do
        local pCopy = {}
        for k, v in pairs(p) do
            if k == 'identifiers' then
                pCopy.identifiers = {}
                for ik, iv in pairs(v) do
                    if ik ~= 'ip' then
                        pCopy.identifiers[ik] = iv
                    end
                end
            else
                pCopy[k] = v
            end
        end
        table.insert(filteredPlayers, pCopy)
    end
    return filteredPlayers
end

function BroadcastPlayers()
    for adminSrc, _ in pairs(AdminPlayers) do
        TriggerClientEvent('bl_admin:updatePlayers', adminSrc, getFilteredPlayersForAdmin(adminSrc))
    end
end

RegisterNetEvent('bl_admin:logSpectate')
AddEventHandler('bl_admin:logSpectate', function(targetId, active)
    local src = source
    if not AdminPlayers[src] then return end
    local adminName = GetPlayerName(src)
    local targetName = GetPlayerName(targetId) or 'Inconnu'
    local status = active and 'SPECTATE_START' or 'SPECTATE_STOP'
    local details = active and 'A commencé à spectate' or 'A arrêté de spectate'
    addLog('moderation', status, adminName, src, targetName, targetId, details)
end)

RegisterNetEvent('bl_admin:requestPlayers')
AddEventHandler('bl_admin:requestPlayers', function()
    local src = tonumber(source)
    if not AdminPlayers[src] then return end
    TriggerClientEvent('bl_admin:updatePlayers', src, getFilteredPlayersForAdmin(src))
end)

RegisterNetEvent('bl_admin:requestTeleport')
AddEventHandler('bl_admin:requestTeleport', function(targetId)
    local src = source
    if not checkPermission(src, 'bl.teleport') then return end
    local adminName = GetPlayerName(src)
    local targetName = GetPlayerName(targetId) or 'Inconnu'
    addLog('moderation', 'TELEPORT_GOTO', adminName, src, targetName, targetId, 'Téléportation vers le joueur')
    TriggerClientEvent('bl_admin:sendCoords', targetId, src)
end)

RegisterNetEvent('bl_admin:receiveCoords')
AddEventHandler('bl_admin:receiveCoords', function(adminSrc, x, y, z)
    TriggerClientEvent('bl_admin:doTeleport', adminSrc, x, y, z)
end)

RegisterNetEvent('bl_admin:kickPlayer')
AddEventHandler('bl_admin:kickPlayer', function(targetId, reason)
    local src = source
    if not checkPermission(src, 'bl.kick') then return end

    local adminName  = GetPlayerName(src)
    local targetName = GetPlayerName(targetId) or 'Inconnu'
    reason = reason or 'Aucun motif'

    addLog('moderation', 'KICK', adminName, src, targetName, targetId, reason)
    DropPlayer(targetId, ('[KICK] %s\nAdmin : %s'):format(reason, adminName))

    TriggerClientEvent('bl_admin:notify', src, 'success', ('✔ %s a été kick.'):format(targetName))
end)

RegisterNetEvent('bl_admin:revivePlayer')
AddEventHandler('bl_admin:revivePlayer', function(targetId)
    local src = source
    if not checkPermission(src, 'bl.revive') then return end
    
    local target = targetId
    if target == 0 then target = src end
    
    local adminName = GetPlayerName(src)
    local targetName = GetPlayerName(target) or 'Inconnu'
    addLog('moderation', 'REVIVE', adminName, src, targetName, target, 'Réanimation du joueur')

    TriggerClientEvent('esx_ambulancejob:revive', target)
    TriggerClientEvent('bl_admin:notify', src, 'success', (target == src and 'Vous vous êtes réanimé' or 'Joueur réanimé'))
end)

RegisterNetEvent('bl_admin:healPlayer')
AddEventHandler('bl_admin:healPlayer', function(targetId)
    local src = source
    if not checkPermission(src, 'bl.heal') then return end
    
    local target = targetId
    if target == 0 then target = src end
    
    local adminName = GetPlayerName(src)
    local targetName = GetPlayerName(target) or 'Inconnu'
    addLog('moderation', 'HEAL', adminName, src, targetName, target, 'Soin du joueur (Vie/Faim/Soif)')

    TriggerClientEvent('esx_basicneeds:healPlayer', target)
    TriggerClientEvent('bl_admin:notify', src, 'success', (target == src and 'Vous vous êtes soigné' or 'Joueur soigné'))
end)

RegisterNetEvent('bl_admin:setArmor')
AddEventHandler('bl_admin:setArmor', function(targetId)
    local src = source
    if not checkPermission(src, 'bl.heal') then return end
    
    local target = targetId
    if target == 0 then target = src end
    
    local adminName = GetPlayerName(src)
    local targetName = GetPlayerName(target) or 'Inconnu'
    addLog('moderation', 'GIVE_ARMOR', adminName, src, targetName, target, 'Attribution d\'armure')

    TriggerClientEvent('bl_admin:receiveArmor', target)
    TriggerClientEvent('bl_admin:notify', src, 'success', (target == src and 'Armure appliquée' or 'Armure donnée'))
end)

RegisterNetEvent('bl_admin:setJob')
AddEventHandler('bl_admin:setJob', function(targetId, job, grade)
    local src = source
    if not checkPermission(src, 'bl.job') then return end
    local xPlayer = ESX.GetPlayerFromId(targetId)
    if xPlayer then 
        addLog('economy', 'SET_JOB', GetPlayerName(src), src, xPlayer.getName(), targetId, ('%s - %d'):format(job, grade))
        xPlayer.setJob(job, grade)
        TriggerClientEvent('bl_admin:notify', src, 'success', 'Job défini')
    end
end)

RegisterNetEvent('bl_admin:giveMoney')
AddEventHandler('bl_admin:giveMoney', function(targetId, account, amount)
    local src = source
    if not checkPermission(src, 'bl.money') then return end
    local xPlayer = ESX.GetPlayerFromId(targetId)
    if xPlayer then 
        addLog('economy', 'GIVE_MONEY', GetPlayerName(src), src, xPlayer.getName(), targetId, ('%s %s'):format(amount, account))
        xPlayer.addAccountMoney(account, amount)
        TriggerClientEvent('bl_admin:notify', src, 'success', 'Argent donné')
    end
end)

RegisterNetEvent('bl_admin:sendMessage')
AddEventHandler('bl_admin:sendMessage', function(targetId, msg)
    local src = source
    if not checkPermission(src, 'bl.warn') then return end
    local adminName = GetPlayerName(src)
    local targetName = GetPlayerName(targetId) or 'Inconnu'
    addLog('moderation', 'MSG_ADMIN', adminName, src, targetName, targetId, 'Message privé : ' .. msg)
    TriggerClientEvent('chat:addMessage', targetId, { 
        args = { adminName, msg },
        tags = { { label = "ADMIN", color = "rgba(255, 145, 0, 0.1)", border = "rgba(255, 145, 0, 0.3)", textColor = "#FF9100" } }
    })
    TriggerClientEvent('bl_admin:notify', targetId, 'warning', '<b>MESSAGE ADMIN :</b><br>' .. msg)
    TriggerClientEvent('bl_admin:notify', src, 'success', 'Message envoyé')
end)

RegisterNetEvent('bl_admin:teleportToMe')
AddEventHandler('bl_admin:teleportToMe', function(targetId)
    local src = source
    if not checkPermission(src, 'bl.teleport') then return end
    local adminName = GetPlayerName(src)
    local targetName = GetPlayerName(targetId) or 'Inconnu'
    addLog('moderation', 'TELEPORT_BRING', adminName, src, targetName, targetId, 'Téléportation du joueur vers admin')
    local adminPed = GetPlayerPed(src)
    local coords = GetEntityCoords(adminPed)
    TriggerClientEvent('bl_admin:doTeleport', targetId, coords.x, coords.y, coords.z)
end)

RegisterNetEvent('bl_admin:freezePlayer')
AddEventHandler('bl_admin:freezePlayer', function(targetId)
    local src = source
    if not checkPermission(src, 'bl.freeze') then return end
    local adminName = GetPlayerName(src)
    local targetName = GetPlayerName(targetId) or 'Inconnu'
    addLog('moderation', 'FREEZE', adminName, src, targetName, targetId, 'Alternance Freeze/Unfreeze')
    TriggerClientEvent('bl_admin:freeze', targetId)
end)

RegisterNetEvent('bl_admin:clearInventory')
AddEventHandler('bl_admin:clearInventory', function(targetId)
    local src = source
    if not checkPermission(src, 'bl.inventory') then return end
    local xPlayer = ESX.GetPlayerFromId(targetId)
    if xPlayer then
        local adminName = GetPlayerName(src)
        addLog('economy', 'CLEAR_INVENTORY', adminName, src, xPlayer.getName(), targetId, 'Vidage complet de l\'inventaire')
        for i=1, #xPlayer.inventory, 1 do
            if xPlayer.inventory[i].count > 0 then
                xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
            end
        end
        TriggerClientEvent('bl_admin:notify', src, 'success', 'Inventaire vidé')
    end
end)

RegisterNetEvent('bl_admin:reviveAll')
AddEventHandler('bl_admin:reviveAll', function()
    local src = source
    if not checkPermission(src, 'bl.revive') then return end
    addLog('moderation', 'REVIVE_ALL', GetPlayerName(src), src, 'TOUT LE SERVEUR', 0, 'Réanimation générale')
    TriggerClientEvent('esx_ambulancejob:revive', -1)
    TriggerClientEvent('bl_admin:notify', src, 'success', 'Tout le monde a été réanimé')
end)

RegisterNetEvent('bl_admin:healAll')
AddEventHandler('bl_admin:healAll', function()
    local src = source
    if not checkPermission(src, 'bl.heal') then return end
    addLog('moderation', 'HEAL_ALL', GetPlayerName(src), src, 'TOUT LE SERVEUR', 0, 'Soin général')
    TriggerClientEvent('esx_basicneeds:healPlayer', -1)
    TriggerClientEvent('bl_admin:notify', src, 'success', 'Tout le monde a été soigné')
end)

RegisterNetEvent('bl_admin:kickAll')
AddEventHandler('bl_admin:kickAll', function()
    local src = source
    if not checkPermission(src, 'bl.kick') then return end
    addLog('moderation', 'KICK_ALL', GetPlayerName(src), src, 'TOUT LE SERVEUR', 0, 'Vidage du serveur')
    for _, pid in ipairs(GetPlayers()) do
        if tonumber(pid) ~= src then
            DropPlayer(pid, 'Le serveur a été vidé par un administrateur.')
        end
    end
    TriggerClientEvent('bl_admin:notify', src, 'success', 'Serveur vidé')
end)

RegisterNetEvent('bl_admin:warn')
AddEventHandler('bl_admin:warn', function(data)
    local src = source
    if not checkPermission(src, 'bl.warn') then return end
    local targetId = data.id
    local reason = data.reason or 'Aucun motif'
    local targetName = GetPlayerName(targetId)
    
    TriggerClientEvent('chat:addMessage', targetId, {
        args = { 'Avertissement', reason },
        tags = { { label = "SANCTION", color = "rgba(213, 0, 249, 0.1)", border = "rgba(213, 0, 249, 0.3)", textColor = "#D500F9" } }
    })

    -- Persist warn to DB
    local targetIdentifier = getIdentifiers(targetId).steam
    local adminName = GetPlayerName(src)
    MySQL.insert('INSERT INTO bl_warns (identifier, player_name, reason, admin) VALUES (?, ?, ?, ?)', {
        targetIdentifier, targetName, reason, adminName
    }, function()
        if loadWarns then 
            loadWarns() 
            Wait(100)
            for adminSrc, _ in pairs(AdminPlayers) do
                TriggerClientEvent('bl_admin:updateWarns', adminSrc, WarnList)
            end
        end
    end)

    addLog('moderation', 'WARN', adminName, src, targetName, targetId, reason)
    TriggerClientEvent('bl_admin:notify', src, 'success', 'Avertissement envoyé à ' .. targetName)
end)

-- ── GHOST BAN & JAIL SYSTEM ──────────────────────────────────

RegisterNetEvent('bl_admin:ghostBan')
AddEventHandler('bl_admin:ghostBan', function(targetId)
    local src = source
    if not checkPermission(src, 'bl.ghost') then return end
    
    local targetName = GetPlayerName(targetId)
    local adminName = GetPlayerName(src)
    local ids = getIdentifiers(targetId)
    local identifier = ids.steam ~= '' and ids.steam or ids.license
    if not identifier or identifier == '' then return end
    
    local now = os.time()
    MySQL.insert('INSERT INTO bl_ghosts (identifier, name, admin, created_at) VALUES (?, ?, ?, ?)', {
        identifier, targetName, adminName, now
    }, function()
        ActiveGhosts[identifier] = { name = targetName, admin = adminName, time = now }
        
        SetPlayerRoutingBucket(targetId, targetId + 1000)
        TriggerClientEvent('bl_admin:ghostMode', targetId, true)
        
        addLog('moderation', 'GHOST_BAN', adminName, src, targetName, targetId, 'Joueur placé en dimension fantôme')
        TriggerClientEvent('bl_admin:notify', src, 'success', targetName .. ' a été GHOST BAN.')
        
        for adminSrc, _ in pairs(AdminPlayers) do
            TriggerClientEvent('bl_admin:updateGhosts', adminSrc, ActiveGhosts)
        end
    end)
end)

RegisterNetEvent('bl_admin:jailPlayer')
AddEventHandler('bl_admin:jailPlayer', function(data)
    local src = source
    if not checkPermission(src, 'bl.jail') then return end
    
    local targetId = data.id
    local duration = data.duration or 10
    local jailCoords = { x = 1680.1, y = 2513.0, z = 45.5 }
    
    local targetName = GetPlayerName(targetId)
    local adminName = GetPlayerName(src)
    local ids = getIdentifiers(targetId)
    local identifier = ids.steam ~= '' and ids.steam or ids.license
    if not identifier or identifier == '' then return end
    
    local expires = os.time() + (duration * 60)
    MySQL.insert('INSERT INTO bl_jails (identifier, name, admin, expires_at) VALUES (?, ?, ?, ?)', {
        identifier, targetName, adminName, expires
    }, function()
        ActiveJails[identifier] = { name = targetName, admin = adminName, expires = expires }
        TriggerClientEvent('bl_admin:jail', targetId, jailCoords, expires)
        
        addLog('moderation', 'JAIL', adminName, src, targetName, targetId, ('Emprisonné pour %d minutes'):format(duration))
        TriggerClientEvent('bl_admin:notify', src, 'success', targetName .. ' a été envoyé en prison.')

        for adminSrc, _ in pairs(AdminPlayers) do
            TriggerClientEvent('bl_admin:updateJails', adminSrc, ActiveJails)
        end
    end)
end)

RegisterNetEvent('bl_admin:unjailPlayer')
AddEventHandler('bl_admin:unjailPlayer', function(identifier)
    local src = source
    if not checkPermission(src, 'bl.jail') then return end
    
    MySQL.update('DELETE FROM bl_jails WHERE identifier = ?', {identifier}, function()
        ActiveJails[identifier] = nil
        
        local targetId = nil
        for _, id in ipairs(GetPlayers()) do
            local ids = getIdentifiers(id)
            local pId = ids.steam ~= '' and ids.steam or ids.license
            if pId == identifier then targetId = tonumber(id) break end
        end
        
        if targetId then
            TriggerClientEvent('bl_admin:doTeleport', targetId, 168.1, -1016.8, 29.3)
            TriggerClientEvent('bl_admin:notify', targetId, 'info', 'Vous avez été libéré de prison.')
            TriggerClientEvent('bl_admin:unjail', targetId)
        end
        
        TriggerClientEvent('bl_admin:notify', src, 'success', 'Joueur libéré de prison.')
        for adminSrc, _ in pairs(AdminPlayers) do
            TriggerClientEvent('bl_admin:updateJails', adminSrc, ActiveJails)
        end
    end)
end)

RegisterNetEvent('bl_admin:unghostPlayer')
AddEventHandler('bl_admin:unghostPlayer', function(identifier)
    local src = source
    if not checkPermission(src, 'bl.ghost') then return end
    
    MySQL.update('DELETE FROM bl_ghosts WHERE identifier = ?', {identifier}, function()
        ActiveGhosts[identifier] = nil
        
        local targetId = nil
        for _, id in ipairs(GetPlayers()) do
            local ids = getIdentifiers(id)
            local pId = ids.steam ~= '' and ids.steam or ids.license
            if pId == identifier then targetId = tonumber(id) break end
        end
        
        if targetId then
            SetPlayerRoutingBucket(targetId, 0)
            TriggerClientEvent('bl_admin:ghostMode', targetId, false)
            TriggerClientEvent('bl_admin:notify', targetId, 'info', 'Vous avez été rétabli dans la dimension principale.')
        end
        
        TriggerClientEvent('bl_admin:notify', src, 'success', 'Joueur rétabli (Fin Ghost Mode).')
        for adminSrc, _ in pairs(AdminPlayers) do
            TriggerClientEvent('bl_admin:updateGhosts', adminSrc, ActiveGhosts)
        end
    end)
end)

RegisterNetEvent('bl_admin:tpPlayerToZone')
AddEventHandler('bl_admin:tpPlayerToZone', function(data)
    local src = source
    if not checkPermission(src, 'bl.tpzones') then return end
    
    local targetId = tonumber(data.targetId)
    local x, y, z = data.x, data.y, data.z
    
    if targetId and x and y and z then
        local adminName = GetPlayerName(src)
        local targetName = GetPlayerName(targetId)
        TriggerClientEvent('bl_admin:doTeleport', targetId, x, y, z)
        addLog('moderation', 'TP_ZONE', adminName, src, targetName, targetId, 'Téléportation vers une zone prédéfinie')
        TriggerClientEvent('bl_admin:notify', src, 'success', 'Joueur téléporté avec succès.')
        TriggerClientEvent('bl_admin:notify', targetId, 'info', 'Vous avez été déplacé par un administrateur.')
    end
end)

RegisterNetEvent('bl_admin:requestOfflinePlayers')
AddEventHandler('bl_admin:requestOfflinePlayers', function()
    local src = source
    if not checkPermission(src, 'bl.offlinemod') then return end

    -- Query the ESX users table (limit to 150 to keep it very fast)
    MySQL.query("SELECT identifier, firstname, lastname, `group`, job, job_grade FROM users LIMIT 150", {}, function(results)
        if not results then
            TriggerClientEvent('bl_admin:updateOfflinePlayers', src, {})
            return
        end

        -- Filter out players who are currently online!
        local onlineIdentifiers = {}
        for _, pid in ipairs(GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(pid)
            if xPlayer then
                local ident = xPlayer.getIdentifier()
                if ident then
                    onlineIdentifiers[ident] = true
                    local cleanIdent = cleanMulticharIdentifier(ident)
                    if cleanIdent then onlineIdentifiers[cleanIdent] = true end
                end
            end
            
            -- Fallbacks just in case
            local ids = getIdentifiers(pid)
            if ids.license and ids.license ~= '' then
                onlineIdentifiers[ids.license] = true
                local cleanIdent = cleanMulticharIdentifier(ids.license)
                if cleanIdent then onlineIdentifiers[cleanIdent] = true end
            end
            if ids.steam and ids.steam ~= '' then
                onlineIdentifiers[ids.steam] = true
                local cleanIdent = cleanMulticharIdentifier(ids.steam)
                if cleanIdent then onlineIdentifiers[cleanIdent] = true end
            end
        end

        -- Filter out banned players!
        local bannedIdentifiers = {}
        if BanList then
            for _, ban in ipairs(BanList) do
                if ban.expires == 0 or ban.expires > os.time() then
                    if ban.identifiers then
                        if ban.identifiers.license and ban.identifiers.license ~= '' then
                            bannedIdentifiers[ban.identifiers.license] = true
                            local cleanIdent = cleanMulticharIdentifier(ban.identifiers.license)
                            if cleanIdent then bannedIdentifiers[cleanIdent] = true end
                        end
                        if ban.identifiers.steam and ban.identifiers.steam ~= '' then
                            bannedIdentifiers[ban.identifiers.steam] = true
                            local cleanIdent = cleanMulticharIdentifier(ban.identifiers.steam)
                            if cleanIdent then bannedIdentifiers[cleanIdent] = true end
                        end
                    end
                end
            end
        end

        local offlineList = {}
        for _, row in ipairs(results) do
            local rawIdent = row.identifier
            local cleanIdent = cleanMulticharIdentifier(rawIdent)

            local isOnline = (onlineIdentifiers[rawIdent] == true) or (cleanIdent and onlineIdentifiers[cleanIdent] == true)
            local isBanned = (bannedIdentifiers[rawIdent] == true) or (cleanIdent and bannedIdentifiers[cleanIdent] == true)

            if not isOnline and not isBanned then
                local fullName = 'Inconnu'
                if row.firstname and row.lastname then
                    fullName = row.firstname .. ' ' .. row.lastname
                elseif row.firstname then
                    fullName = row.firstname
                end
                
                table.insert(offlineList, {
                    name = fullName,
                    identifier = rawIdent,
                    grade = row.group or 'user',
                    job = row.job or 'unemployed',
                    jobGrade = row.job_grade or 0
                })
            end
        end

        TriggerClientEvent('bl_admin:updateOfflinePlayers', src, offlineList)
    end)
end)

RegisterNetEvent('bl_admin:warnOfflinePlayer')
AddEventHandler('bl_admin:warnOfflinePlayer', function(data)
    local src = source
    if not checkPermission(src, 'bl.warn') or not checkPermission(src, 'bl.offlinemod') then return end
    
    local targetIdentifier = cleanMulticharIdentifier(data.identifier)
    local targetName = data.playerName or 'Joueur Hors-ligne'
    local reason = data.reason or 'Aucun motif'
    local adminName = GetPlayerName(src)

    MySQL.insert('INSERT INTO bl_warns (identifier, player_name, reason, admin) VALUES (?, ?, ?, ?)', {
        targetIdentifier, targetName, reason, adminName
    }, function()
        if loadWarns then 
            loadWarns() 
            Wait(100)
            for adminSrc, _ in pairs(AdminPlayers) do
                TriggerClientEvent('bl_admin:updateWarns', adminSrc, WarnList)
            end
        end
    end)

    addLog('moderation', 'OFFLINE_WARN', adminName, src, targetName, 'OFFLINE', reason)
    TriggerClientEvent('bl_admin:notify', src, 'success', 'Avertissement enregistré pour le joueur hors-ligne.')
end)
