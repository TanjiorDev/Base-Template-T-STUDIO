-- ============================================================
--  BLOODADMIN — SERVER/MODULES/STAFF.LUA
-- ============================================================
print('^2[bl_admin] Loading Staff Module...^0')

local staffMessages = {}
AdminDuty = {} -- src -> bool
AdminActions = {} -- src -> count

-- Initialize for existing players on resource start
Citizen.CreateThread(function()
    Wait(1000)
    
    -- Create staff and staff chat tables
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `bl_staff` (
            `identifier` VARCHAR(100) PRIMARY KEY,
            `grade` VARCHAR(50) NOT NULL
        )
    ]])

    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `bl_staff_chat` (
            `id` INT AUTO_INCREMENT PRIMARY KEY,
            `sender_name` VARCHAR(100) NOT NULL,
            `grade` VARCHAR(50) NOT NULL,
            `message` TEXT NOT NULL,
            `timestamp` INT NOT NULL,
            `reply_to` TEXT DEFAULT NULL
        )
    ]])

    -- Load staff from DB for all online players
    local players = GetPlayers()
    for _, src in ipairs(players) do
        local pid = tonumber(src)
        local ids = getIdentifiers(pid)
        MySQL.query("SELECT grade FROM bl_staff WHERE identifier = ?", {ids.license}, function(res)
            if res and res[1] then
                AdminPlayers[pid] = res[1].grade
                TriggerClientEvent('bl_admin:setGrade', pid, res[1].grade, Config.Permissions[res[1].grade])
            end
        end)
    end

    -- Load last 50 messages
    MySQL.query("SELECT * FROM `bl_staff_chat` ORDER BY `id` DESC LIMIT 50", {}, function(results)
        if results then
            for i = #results, 1, -1 do
                table.insert(staffMessages, {
                    sender_id   = 0,
                    sender_name = results[i].sender_name,
                    grade       = results[i].grade,
                    message     = results[i].message,
                    timestamp   = results[i].timestamp,
                    reply_to    = results[i].reply_to and json.decode(results[i].reply_to) or nil
                })
            end
        end
    end)
end)
function buildStaffList()
    local staff = {}
    for src, grade in pairs(AdminPlayers) do
        staff[#staff + 1] = {
            id        = src,
            name      = GetPlayerName(src),
            grade     = grade,
            inService = AdminDuty[src] == true,
        }
    end
    return staff
end

-- Redundant loading hook merged below to prevent conflicts

RegisterNetEvent('bl_admin:updatePermissions')
AddEventHandler('bl_admin:updatePermissions', function(data)
    local src = source
    if not isPlayerStaff(src) then return end
    
    local grade = data.grade
    local perm  = data.perm
    local value = data.value

    if not Config.Permissions[grade] then return end
    Config.Permissions[grade][perm] = value

    -- Save directly to the single source of truth (bl_grades)
    local permsStr = json.encode(Config.Permissions[grade])
    local level = Config.Permissions[grade].level or 0
    local color = Config.Permissions[grade]._color or '#3b82f6'
    local icon = Config.Permissions[grade]._icon or '🛡️'

    MySQL.query('INSERT INTO bl_grades (name, level, color, icon, permissions) VALUES (?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE level = ?, color = ?, icon = ?, permissions = ?', {
        grade, level, color, icon, permsStr, level, color, icon, permsStr
    }, function()
        -- Broadcast new config to all staff
        for targetSrc, _ in pairs(AdminPlayers) do
            TriggerClientEvent('bl_admin:updateConfig', targetSrc, Config)
        end
        addLog('staff', 'UPDATE_PERM', GetPlayerName(src), src, grade, '0', ('Modification permission [%s] pour le grade [%s] : %s'):format(perm, grade, tostring(value)))
    end)
end)

RegisterNetEvent('bl_admin:requestGrade')
AddEventHandler('bl_admin:requestGrade', function()
    local src = tonumber(source)
    -- If already loaded in memory, just re-send
    if AdminPlayers[src] then
        local grade = AdminPlayers[src]
        TriggerClientEvent('bl_admin:setGrade', src, grade, Config.Permissions[grade])
        TriggerClientEvent('bl_admin:updateConfig', src, Config, grade)
        if type(SendReportsToPlayer) == "function" then SendReportsToPlayer(src) end
        return
    end
    -- Otherwise, bl_staff is the source of truth
    local ids = getIdentifiers(src)
    MySQL.query("SELECT grade FROM bl_staff WHERE identifier = ?", {ids.license}, function(res)
        if res and res[1] then
            local grade = res[1].grade
            AdminPlayers[src] = grade
            TriggerClientEvent('bl_admin:setGrade', src, grade, Config.Permissions[grade])
            TriggerClientEvent('bl_admin:updateConfig', src, Config, grade)
            if type(SendReportsToPlayer) == "function" then SendReportsToPlayer(src) end
        end
        -- If not in bl_staff → no grade assigned, no access (even if ESX group matches)
    end)
end)

AddEventHandler('playerDropped', function()
    local src = tonumber(source)
    AdminPlayers[src] = nil
    AdminActions[src] = nil
    Citizen.CreateThread(function()
        Citizen.Wait(50)
        if type(BroadcastPlayers) == "function" then
            BroadcastPlayers()
        end
    end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    local src = tonumber(source)
    if not xPlayer then return end
    
    local ids = getIdentifiers(src)
    local group = xPlayer.getGroup()
    
    -- Cross-check bl_staff FIRST to prevent re-entry via residual ESX group in users table
    -- A destituted player is deleted from bl_staff; if they're not there, they get no access.
    MySQL.query("SELECT grade FROM bl_staff WHERE identifier = ?", {ids.license}, function(res)
        local blStaffGrade = res and res[1] and res[1].grade or nil
        
        if blStaffGrade then
            -- They are in bl_staff → grant access with their bl_staff grade (source of truth)
            AdminPlayers[src] = blStaffGrade
            TriggerClientEvent('bl_admin:setGrade', src, blStaffGrade, Config.Permissions[blStaffGrade])
            TriggerClientEvent('bl_admin:updateConfig', src, Config, blStaffGrade)
            if type(SendReportsToPlayer) == "function" then SendReportsToPlayer(src) end
            if type(BroadcastPlayers) == "function" then BroadcastPlayers() end
        else
            -- Not in bl_staff. Check if their ESX group is a valid staff grade.
            -- This handles the case where a staff member was added via the ESX group system
            -- without going through bl_staff (e.g. console setstaff command)
            local isStaffGroup = false
            for _, grade in ipairs(Config.AdminGrades) do
                if group == grade then
                    isStaffGroup = true
                    break
                end
            end
            
            if isStaffGroup then
                -- Auto-register them in bl_staff so they are tracked consistently
                MySQL.query("INSERT INTO bl_staff (identifier, grade) VALUES (?, ?) ON DUPLICATE KEY UPDATE grade = VALUES(grade)", {ids.license, group}, function()
                    AdminPlayers[src] = group
                    TriggerClientEvent('bl_admin:setGrade', src, group, Config.Permissions[group])
                    TriggerClientEvent('bl_admin:updateConfig', src, Config, group)
                    if type(SendReportsToPlayer) == "function" then SendReportsToPlayer(src) end
                    if type(BroadcastPlayers) == "function" then BroadcastPlayers() end
                end)
            end
            -- If neither → no access granted (destituted player stays locked out)
        end
    end)
end)

RegisterNetEvent('bl_admin:requestOpenData')
AddEventHandler('bl_admin:requestOpenData', function()
    local src = tonumber(source)
    local ids = getIdentifiers(src)

    -- If already authenticated in memory, open directly
    if AdminPlayers[src] then
        OpenMenuForPlayer(src)
        return
    end

    -- bl_staff is the SINGLE source of truth — check it first and only
    MySQL.query("SELECT grade FROM bl_staff WHERE identifier = ?", {ids.license}, function(res)
        if res and res[1] then
            local grade = res[1].grade
            AdminPlayers[src] = grade
            TriggerClientEvent('bl_admin:setGrade', src, grade, Config.Permissions[grade])
            TriggerClientEvent('bl_admin:updateConfig', src, Config, grade)
            if type(SendReportsToPlayer) == "function" then SendReportsToPlayer(src) end
            OpenMenuForPlayer(src)
        else
            -- Not in bl_staff → absolutely no access
            TriggerClientEvent('bl_admin:toast', src, "Accès refusé : vous n'êtes pas listé dans le staff.", "error")
        end
    end)
end)

function OpenMenuForPlayer(src)
    print(('[bl_admin] Opening menu for %s (Grade: %s)'):format(GetPlayerName(src), tostring(AdminPlayers[src])))
    local players = getFilteredPlayersForAdmin(src)
    local staff   = buildStaffList()
    local resources = buildResourceList()
    local reports = GetEnhancedReports()
    local customVehicles = {}
    if GetCustomVehicles then customVehicles = GetCustomVehicles() end
    
    local ids = getIdentifiers(src)
    local adminName = GetPlayerName(src)
    
    local sendData = function(actionCount)
        AdminActions[src] = actionCount or 0
        TriggerClientEvent('bl_admin:openWithData', src, players, staff, BanList, resources, Config, AdminPlayers[src], src, AdminDuty[src] == true, reports, customVehicles)
        
        local simulated = GetSimulatedServerMetrics()
        TriggerClientEvent('bl_admin:updateServerMetrics', src, {
            totalPlayers = #GetPlayers(),
            serverMem    = simulated.serverMem,
            fxMem        = simulated.fxMem,
            nodeMem      = simulated.nodeMem,
            ping         = GetPlayerPing(src),
            totalReports = totalReportsCount or 0,
            newPlayersToday = newPlayersTodayCount or 0,
            staffInService = getStaffInServiceCount(),
            myActions    = AdminActions[src]
        })
    end
    
    if not AdminActions[src] then
        MySQL.query("SELECT COUNT(*) AS count FROM bl_logs WHERE admin_name = ? OR admin_id = ?", { adminName, ids.license }, function(result)
            local count = 0
            if result and result[1] then
                count = tonumber(result[1].count) or 0
            end
            sendData(count)
        end)
    else
        sendData(AdminActions[src])
    end
end

RegisterCommand('admin_debug', function(source)
    local src = source
    if src == 0 then return end
    local ids = getIdentifiers(src)
    
    print('--- DEBUG BLOODADMIN SQL ---')
    print('ID Source: ' .. src)
    print('Licence Détectée: ' .. ids.license)
    
    MySQL.query("SELECT * FROM bl_staff WHERE identifier = ?", {ids.license}, function(res)
        if res and res[1] then
            print('Statut SQL: TROUVÉ')
            print('Grade SQL: ' .. res[1].grade)
            print('Grade Cache: ' .. tostring(AdminPlayers[src]))
        else
            print('Statut SQL: NON TROUVÉ')
            print('Action requise: Ajoutez la licence ' .. ids.license .. ' dans la table bl_staff.')
        end
        print('----------------------------')
        TriggerClientEvent('chat:addMessage', src, { 
            args = { 'DEBUG', 'Regarde ta console SERVEUR pour les détails.' },
            tags = { { label = "DEBUG", color = "rgba(100, 116, 139, 0.1)", border = "rgba(100, 116, 139, 0.3)", textColor = "#64748B" } }
        })
    end)
end)

RegisterNetEvent('bl_admin:toggleService')
AddEventHandler('bl_admin:toggleService', function(data)
    local src = tonumber(source)
    local active = data.active
    local name = GetPlayerName(src)
    local ids = getIdentifiers(src)
    
    AdminDuty[src] = active

    if active then
        for adminSrc, _ in pairs(AdminPlayers) do
            TriggerClientEvent('chat:addMessage', adminSrc, { 
                args = { name, 'est désormais EN SERVICE.' },
                tags = { { label = "STAFF", color = "rgba(220, 38, 38, 0.1)", border = "rgba(220, 38, 38, 0.3)", textColor = "#DC2626" } }
            })
            TriggerClientEvent('bl_admin:notify', adminSrc, 'success', '<b>' .. name .. '</b> est désormais EN SERVICE.')
        end
        addLog('staff', 'PRISE_SERVICE', name, src, 'Système', '0', 'Le staff a pris son service.')
    else
        TriggerClientEvent('bl_admin:disableAllTools', src)
        for adminSrc, _ in pairs(AdminPlayers) do
            TriggerClientEvent('chat:addMessage', adminSrc, { 
                args = { name, 'a quitté son service.' },
                tags = { { label = "STAFF", color = "rgba(220, 38, 38, 0.1)", border = "rgba(220, 38, 38, 0.3)", textColor = "#DC2626" } }
            })
            TriggerClientEvent('bl_admin:notify', adminSrc, 'error', '<b>' .. name .. '</b> a quitté son service.')
        end
        addLog('staff', 'FIN_SERVICE', name, src, 'Système', '0', 'Le staff a quitté son service.')
    end

    -- Update stats for all admins
    local metrics = {
        totalPlayers = #GetPlayers(),
        staffInService = getStaffInServiceCount(),
        totalReports = totalReportsCount or 0,
        newPlayersToday = newPlayersTodayCount or 0
    }
    
    for adminSrc, _ in pairs(AdminPlayers) do
        TriggerClientEvent('bl_admin:updateServerMetrics', adminSrc, metrics)
    end
    RefreshAllStaffList()
end)

function getStaffInServiceCount()
    local count = 0
    for _, duty in pairs(AdminDuty) do
        if duty then count = count + 1 end
    end
    return count
end

function RefreshAllStaffList()
    if not MySQL then return end

    local query = "SELECT s.identifier, s.grade, MAX(u.firstname) as firstname, MAX(u.lastname) as lastname FROM bl_staff s LEFT JOIN users u ON u.identifier = s.identifier OR u.identifier LIKE CONCAT('%', s.identifier) GROUP BY s.identifier, s.grade"
    
    MySQL.query(query, {}, function(results)
        local staff = {}
        local processedIdentifiers = {}
        
        for _, row in ipairs(results or {}) do
            local name = row.identifier
            if row.firstname and row.lastname then
                name = row.firstname .. " " .. row.lastname
            end
            
            local isOnline = false
            local targetSrc = -1
            
            -- Multi-identifier robust online check
            for _, playerId in ipairs(ESX.GetPlayers()) do
                local player = ESX.GetPlayerFromId(playerId)
                if player then
                    local playerIdent = ""
                    if type(player.getIdentifier) == "function" then
                        playerIdent = player.getIdentifier() or ""
                    elseif player.identifier then
                        playerIdent = player.identifier or ""
                    end
                    local ids = getIdentifiers(playerId)
                    
                    local cleanPlayerIdent = playerIdent:sub(1,8) == "license:" and playerIdent:sub(9) or playerIdent
                    local cleanRowIdent = row.identifier:sub(1,8) == "license:" and row.identifier:sub(9) or row.identifier
                    local cleanIdsLicense = ids.license:sub(1,8) == "license:" and ids.license:sub(9) or ids.license

                    if cleanPlayerIdent == cleanRowIdent or ids.license == row.identifier or cleanIdsLicense == cleanRowIdent then
                        isOnline = true
                        targetSrc = playerId
                        name = GetPlayerName(playerId)
                        break
                    end
                end
            end
            
            processedIdentifiers[row.identifier] = true
            local cleanRow = row.identifier:sub(1,8) == "license:" and row.identifier:sub(9) or row.identifier
            processedIdentifiers[cleanRow] = true
            
            table.insert(staff, {
                identifier = row.identifier,
                name       = name,
                grade      = row.grade,
                online     = isOnline,
                source     = targetSrc ~= -1 and tonumber(targetSrc) or -1,
                id         = targetSrc ~= -1 and tonumber(targetSrc) or -1,
                inService  = (targetSrc ~= -1 and AdminDuty[tonumber(targetSrc)] == true)
            })
        end
        
        -- FAIL-SAFE: Inject any active online staff from AdminPlayers memory if they aren't in database results
        for onlineSrc, onlineGrade in pairs(AdminPlayers) do
            local ids = getIdentifiers(onlineSrc)
            local license = ids.license
            local cleanLicense = license:sub(1,8) == "license:" and license:sub(9) or license
            
            local alreadyAdded = false
            if processedIdentifiers[license] or processedIdentifiers[cleanLicense] then
                alreadyAdded = true
            else
                local player = ESX.GetPlayerFromId(onlineSrc)
                if player then
                    local playerIdent = ""
                    if type(player.getIdentifier) == "function" then
                        playerIdent = player.getIdentifier() or ""
                    elseif player.identifier then
                        playerIdent = player.identifier or ""
                    end
                    local cleanIdent = ""
                    if playerIdent and playerIdent ~= "" then
                        cleanIdent = playerIdent:sub(1,8) == "license:" and playerIdent:sub(9) or playerIdent
                    end
                    if processedIdentifiers[playerIdent] or processedIdentifiers[cleanIdent] then
                        alreadyAdded = true
                    end
                end
            end
            
            if not alreadyAdded then
                table.insert(staff, {
                    identifier = license,
                    name       = GetPlayerName(onlineSrc),
                    grade      = onlineGrade,
                    online     = true,
                    source     = onlineSrc,
                    id         = onlineSrc,
                    inService  = (AdminDuty[onlineSrc] == true)
                })
            end
        end
        
        -- Broadcast to all admins
        for adminSrc, _ in pairs(AdminPlayers) do
            TriggerClientEvent('bl_admin:updateAllStaff', adminSrc, staff)
        end
    end)
end

RegisterNetEvent('bl_admin:getAllStaff')
AddEventHandler('bl_admin:getAllStaff', function()
    local src = tonumber(source)
    if not AdminPlayers[src] then return end
    RefreshAllStaffList()
end)

RegisterNetEvent('bl_admin:setStaffGrade')
AddEventHandler('bl_admin:setStaffGrade', function(data)
    local src = source
    local targetIdentifier = data.identifier
    local newGrade = data.grade
    
    if not checkPermission(src, 'bl.staff') then return end
    
    local senderGrade = AdminPlayers[src]
    local senderLevel = Config.Permissions[senderGrade] and Config.Permissions[senderGrade].level or 0
    local targetLevel = Config.Permissions[newGrade] and Config.Permissions[newGrade].level or 0
    
    if newGrade == 'user' then targetLevel = 0 end

    -- Check if sender has enough permissions for the new level
    if senderLevel <= targetLevel and senderLevel < 100 then
        TriggerClientEvent('bl_admin:notify', src, 'error', "Action refusée : Hiérarchie insuffisante.")
        return
    end

    -- Extract clean identifier (without license: prefix)
    local cleanIdentifier = targetIdentifier
    if targetIdentifier:sub(1,8) == "license:" then
        cleanIdentifier = targetIdentifier:sub(9)
    end
    
    -- Prepend license: prefix if needed
    local prefixIdentifier = targetIdentifier
    if targetIdentifier:sub(1,8) ~= "license:" then
        prefixIdentifier = "license:" .. targetIdentifier
    end

    -- Robust verification of the target's CURRENT grade (online or offline) to secure the seniority levels
    MySQL.query("SELECT grade FROM bl_staff WHERE identifier = ? OR identifier = ? OR identifier = ?", {targetIdentifier, cleanIdentifier, prefixIdentifier}, function(res)
        local currentGrade = 'user'
        if res and res[1] then
            currentGrade = res[1].grade
        end
        
        local currentLevel = Config.Permissions[currentGrade] and Config.Permissions[currentGrade].level or 0
        if senderLevel <= currentLevel and senderLevel < 100 then
            TriggerClientEvent('bl_admin:notify', src, 'error', "Action refusée : Vous ne pouvez pas destituer un membre supérieur ou égal.")
            return
        end

        -- Look up online player using fallbacks and robust checks
        local targetSrc = -1
        for _, playerId in ipairs(ESX.GetPlayers()) do
            local player = ESX.GetPlayerFromId(playerId)
            if player then
                local playerIdent = ""
                if type(player.getIdentifier) == "function" then
                    playerIdent = player.getIdentifier() or ""
                elseif player.identifier then
                    playerIdent = player.identifier or ""
                end
                local ids = getIdentifiers(playerId)
                
                local cleanPlayerIdent = playerIdent:sub(1,8) == "license:" and playerIdent:sub(9) or playerIdent
                local cleanTargetIdent = targetIdentifier:sub(1,8) == "license:" and targetIdentifier:sub(9) or targetIdentifier

                if cleanPlayerIdent == cleanTargetIdent or ids.license == targetIdentifier or ids.license == prefixIdentifier or ids.license == cleanIdentifier then
                    targetSrc = playerId
                    break
                end
            end
        end

        local xPlayer = nil
        if targetSrc ~= -1 then
            xPlayer = ESX.GetPlayerFromId(targetSrc)
        end

        if not xPlayer then
            xPlayer = ESX.GetPlayerFromIdentifier(targetIdentifier)
        end
        if not xPlayer then
            xPlayer = ESX.GetPlayerFromIdentifier(cleanIdentifier)
        end
        if not xPlayer then
            xPlayer = ESX.GetPlayerFromIdentifier(prefixIdentifier)
        end
        
        local function updateStaffDatabase()
            if newGrade == 'user' then
                -- Delete from bl_staff (covers all identifier format variants)
                MySQL.query("DELETE FROM bl_staff WHERE identifier = ? OR identifier = ? OR identifier = ?", {targetIdentifier, cleanIdentifier, prefixIdentifier}, function()
                    -- ALSO force-update users table so ESX group is persisted as 'user'
                    -- This prevents re-entry via xPlayer.getGroup() returning old grade on reconnect
                    MySQL.update("UPDATE users SET `group` = 'user' WHERE identifier LIKE ?", {'%' .. cleanIdentifier}, function()
                        RefreshAllStaffList()
                    end)
                end)
            else
                MySQL.query("INSERT INTO bl_staff (identifier, grade) VALUES (?, ?) ON DUPLICATE KEY UPDATE grade = ?", {targetIdentifier, newGrade, newGrade}, function()
                    RefreshAllStaffList()
                end)
            end
        end

        if xPlayer then
            local targetSource = tonumber(xPlayer.source)
            if type(xPlayer.setGroup) == "function" then
                xPlayer.setGroup(newGrade)
            elseif type(xPlayer.set) == "function" then
                xPlayer.set('group', newGrade)
            end
            
            if newGrade == 'user' then
                if targetSource then
                    AdminPlayers[targetSource] = nil
                    AdminDuty[targetSource] = nil
                end
                -- Force close the admin menu on the destituted player's screen
                TriggerClientEvent('bl_admin:revokeAccess', xPlayer.source)
            else
                if targetSource then
                    AdminPlayers[targetSource] = newGrade
                end
                TriggerClientEvent('bl_admin:setGrade', xPlayer.source, newGrade, Config.Permissions[newGrade])
            end
            TriggerClientEvent('bl_admin:notify', src, 'success', "Grade mis à jour (Joueur en ligne)")
            updateStaffDatabase()
        else
            -- Check for offline moderation permission!
            if not checkPermission(src, 'bl.offlinemod') then
                TriggerClientEvent('bl_admin:notify', src, 'error', "Action refusée : Vous n'avez pas la permission de modérer hors-ligne.")
                return
            end
            -- Player is offline: update users table supporting both license format variants
            MySQL.update("UPDATE users SET `group` = ? WHERE identifier LIKE ?", {newGrade, '%' .. cleanIdentifier}, function(rowsChanged)
                if rowsChanged > 0 then
                    TriggerClientEvent('bl_admin:notify', src, 'success', "Grade mis à jour dans la base (Joueur hors-ligne)")
                    updateStaffDatabase()
                else
                    -- Failsafe: even if users table was not found or no rows changed, update the staff roster database
                    TriggerClientEvent('bl_admin:notify', src, 'success', "Grade mis à jour pour le staff")
                    updateStaffDatabase()
                end
            end)
        end
        
        local adminName = GetPlayerName(src)
        addLog('staff', 'SET_GRADE', adminName, src, targetIdentifier, 0, 'Nouveau grade : ' .. newGrade)
    end)
end)

RegisterNetEvent('bl_admin:addStaff')
AddEventHandler('bl_admin:addStaff', function(data)
    local src = source
    local targetId = tonumber(data.id)
    local newGrade = data.grade
    
    if not checkPermission(src, 'bl.staff') then return end
    
    local xPlayer = ESX.GetPlayerFromId(targetId)
    if xPlayer then
        xPlayer.setGroup(newGrade)
        AdminPlayers[targetId] = newGrade
        TriggerClientEvent('bl_admin:setGrade', targetId, newGrade, Config.Permissions[newGrade])
        
        local ids = getIdentifiers(targetId)
        MySQL.query("INSERT INTO bl_staff (identifier, grade) VALUES (?, ?) ON DUPLICATE KEY UPDATE grade = ?", {ids.license, newGrade, newGrade}, function()
            TriggerClientEvent('bl_admin:notify', src, 'success', GetPlayerName(targetId) .. " est maintenant " .. newGrade)
            RefreshAllStaffList()
        end)
        
        local adminName = GetPlayerName(src)
        addLog('staff', 'ADD_STAFF', adminName, src, GetPlayerName(targetId), targetId, 'Promu au grade : ' .. newGrade)
    else
        TriggerClientEvent('bl_admin:notify', src, 'error', "Joueur non trouvé ou hors-ligne")
    end
end)

RegisterNetEvent('bl_admin:getLogs')
AddEventHandler('bl_admin:getLogs', function(category)
    local src = tonumber(source)
    if not checkPermission(src, 'bl.logs') then return end

    local query = 'SELECT * FROM bl_logs ORDER BY timestamp DESC LIMIT 100'
    local params = {}

    if category and category ~= 'all' then
        query = 'SELECT * FROM bl_logs WHERE category = ? ORDER BY timestamp DESC LIMIT 100'
        params = {category}
    end

    MySQL.query(query, params, function(results)
        TriggerClientEvent('bl_admin:receiveLogs', src, results)
    end)
end)

RegisterNetEvent('bl_admin:clearLogs')
AddEventHandler('bl_admin:clearLogs', function()
    local src = tonumber(source)
    -- Seul le grade Boss (ou équivalent level >= 100) peut clear les logs
    local grade = AdminPlayers[src]
    local level = Config.Permissions[grade] and Config.Permissions[grade].level or 0
    if level < 100 then return end

    MySQL.query('TRUNCATE TABLE bl_logs', {}, function()
        addLog('staff', 'CLEAR_LOGS', GetPlayerName(src), src, 'Système', 0, 'Tous les logs ont été effacés')
        TriggerClientEvent('bl_admin:notify', src, 'success', 'Logs effacés avec succès')
        TriggerClientEvent('bl_admin:receiveLogs', src, {})
    end)
end)

-- ── Commande Console / In-game ────────────────────────────────
RegisterCommand('setstaff', function(source, args, rawCommand)
    local targetId = tonumber(args[1])
    local grade    = args[2]

    -- Si exécuté en jeu, vérifier les perms
    if source ~= 0 then
        if not checkPermission(source, 'bl.staff') then
            TriggerClientEvent('bl_admin:notify', source, 'error', "Permission insuffisante.")
            return
        end
    end

    if targetId and grade then
        local xPlayer = ESX.GetPlayerFromId(targetId)
        if xPlayer then
            if Config.Permissions[grade] or grade == 'user' then
                xPlayer.setGroup(grade)
                
                local ids = getIdentifiers(targetId)
                if grade == 'user' then
                    AdminPlayers[targetId] = nil
                    MySQL.query("DELETE FROM bl_staff WHERE identifier = ?", {ids.license}, function()
                        print(("[bl_admin] SQL Destitution réussie pour %s (Licence: %s)"):format(GetPlayerName(targetId), ids.license))
                    end)
                else
                    AdminPlayers[targetId] = grade
                    MySQL.query("INSERT INTO bl_staff (identifier, grade) VALUES (?, ?) ON DUPLICATE KEY UPDATE grade = ?", {ids.license, grade, grade}, function()
                        print(("[bl_admin] SQL Enregistrement réussi pour %s au grade %s (Licence: %s)"):format(GetPlayerName(targetId), grade, ids.license))
                    end)
                end
                
                TriggerClientEvent('bl_admin:setGrade', targetId, (grade == 'user' and nil or grade), Config.Permissions[grade])
                
                local msg = ("^2[bl_admin]^7 %s a été promu au grade : ^5%s"):format(GetPlayerName(targetId), grade)
                if source == 0 then print(msg) else TriggerClientEvent('bl_admin:notify', source, 'success', msg) end
                
                -- Sync active dashboard lists in real-time
                if type(BroadcastPlayers) == "function" then BroadcastPlayers() end
                if type(RefreshAllStaffList) == "function" then RefreshAllStaffList() end
            else
                local msg = "^1[bl_admin]^7 Ce grade n'existe pas dans le config.lua"
                if source == 0 then print(msg) else TriggerClientEvent('bl_admin:notify', source, 'error', msg) end
            end
        else
            local msg = "^1[bl_admin]^7 Joueur non trouvé."
            if source == 0 then print(msg) else TriggerClientEvent('bl_admin:notify', source, 'error', msg) end
        end
    else
        local msg = "^3[bl_admin]^7 Utilisation : /setstaff [ID] [GRADE]"
        if source == 0 then print(msg) else TriggerClientEvent('bl_admin:notify', source, 'info', msg) end
    end
end, true) -- true = restreint aux ACE perms si besoin, mais on check manuellement au dessus

-- ── Staff Chat Logic ──────────────────────────────────────────

RegisterNetEvent('bl_admin:sendStaffMessage')
AddEventHandler('bl_admin:sendStaffMessage', function(data)
    local msg = data.message
    local replyTo = data.replyTo
    local channel = data.channel or 'global'
    
    local src = tonumber(source)
    if not AdminPlayers[src] then return end
    
    local name = GetPlayerName(src)
    local grade = AdminPlayers[src]
    
    local messageData = {
        sender_id   = src,
        sender_name = name,
        grade       = grade,
        message     = msg,
        timestamp   = os.time(),
        reply_to    = replyTo,
        channel     = channel
    }
    
    table.insert(staffMessages, messageData)
    
    -- Save to DB (only global messages for now to keep DB clean, or add a column)
    if channel == 'global' then
        MySQL.insert("INSERT INTO `bl_staff_chat` (sender_name, grade, message, timestamp, reply_to) VALUES (?, ?, ?, ?, ?)", {
            name, grade, msg, os.time(), replyTo and json.encode(replyTo) or nil
        })
    end
    
    -- Keep only last 100 messages
    if #staffMessages > 100 then table.remove(staffMessages, 1) end
    
    -- Broadcast
    for adminSrc, _ in pairs(AdminPlayers) do
        TriggerClientEvent('bl_admin:updateStaffChat', adminSrc, staffMessages)
    end
end)

RegisterNetEvent('bl_admin:getStaffChat')
AddEventHandler('bl_admin:getStaffChat', function()
    local src = tonumber(source)
    if not AdminPlayers[src] then return end
    TriggerClientEvent('bl_admin:updateStaffChat', src, staffMessages)
end)
