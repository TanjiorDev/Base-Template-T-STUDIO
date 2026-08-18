-- ============================================================
--  BLOODADMIN — SERVER/MODULES/REPORTS.LUA
-- ============================================================

activeReports = {}
totalReportsCount = 0
newPlayersTodayCount = 0

-- Initialize DB tables and load active reports
local function getSourceFromLicense(license)
    if not license then return nil end
    local xPlayer = ESX.GetPlayerFromIdentifier(license)
    if not xPlayer and license:sub(1, 8) == "license:" then
        xPlayer = ESX.GetPlayerFromIdentifier(license:sub(9))
    end
    if not xPlayer and license:sub(1, 8) ~= "license:" then
        xPlayer = ESX.GetPlayerFromIdentifier("license:" .. license)
    end
    return xPlayer and xPlayer.source or nil
end

Citizen.CreateThread(function()
    Wait(2000)
    -- Initialize seen players tracking table
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `bl_players_seen` (
            `identifier` VARCHAR(100) PRIMARY KEY,
            `first_seen` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ]], {}, function()
        -- Check if columns exist in bl_players_seen
        MySQL.query("SHOW COLUMNS FROM `bl_players_seen` LIKE 'steam'", {}, function(cols1)
            local hasSteam = cols1 and #cols1 > 0
            
            local function checkIp()
                MySQL.query("SHOW COLUMNS FROM `bl_players_seen` LIKE 'ip'", {}, function(cols2)
                    local hasIp = cols2 and #cols2 > 0
                    
                    local function checkFivem()
                        MySQL.query("SHOW COLUMNS FROM `bl_players_seen` LIKE 'fivem'", {}, function(cols3)
                            local hasFivem = cols3 and #cols3 > 0
                            
                            local function checkDiscord()
                                MySQL.query("SHOW COLUMNS FROM `bl_players_seen` LIKE 'discord'", {}, function(cols4)
                                    local hasDiscord = cols4 and #cols4 > 0
                                    
                                    local function finishSeenInit()
                                        -- Load new players count today
                                        MySQL.query("SELECT COUNT(*) as count FROM bl_players_seen WHERE DATE(first_seen) = CURRENT_DATE()", {}, function(res)
                                            if res and res[1] then
                                                newPlayersTodayCount = res[1].count
                                                print(('[bl_admin] Nouveaux joueurs aujourd\'hui : %d'):format(newPlayersTodayCount))
                                            end
                                        end)
                                    end
                                    
                                    if not hasDiscord then
                                        MySQL.update("ALTER TABLE `bl_players_seen` ADD COLUMN `discord` VARCHAR(50) DEFAULT ''", {}, finishSeenInit)
                                    else
                                        finishSeenInit()
                                    end
                                end)
                            end
                            
                            if not hasFivem then
                                MySQL.update("ALTER TABLE `bl_players_seen` ADD COLUMN `fivem` VARCHAR(50) DEFAULT ''", {}, checkDiscord)
                            else
                                checkDiscord()
                            end
                        end)
                    end
                    
                    if not hasIp then
                        MySQL.update("ALTER TABLE `bl_players_seen` ADD COLUMN `ip` VARCHAR(50) DEFAULT ''", {}, checkFivem)
                    else
                        checkFivem()
                    end
                end)
            end
            
            if not hasSteam then
                MySQL.update("ALTER TABLE `bl_players_seen` ADD COLUMN `steam` VARCHAR(100) DEFAULT ''", {}, checkIp)
            else
                checkIp()
            end
        end)
    end)

    -- Migration / Initialization
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `bl_reports` (
            `id` INT AUTO_INCREMENT PRIMARY KEY,
            `reporter_license` VARCHAR(100) NOT NULL,
            `reporter_name` VARCHAR(100) NOT NULL,
            `reason` TEXT NOT NULL,
            `status` VARCHAR(20) DEFAULT 'open',
            `admin_name` VARCHAR(100) DEFAULT NULL,
            `closed_by` VARCHAR(100) DEFAULT NULL,
            `coords` TEXT DEFAULT NULL,
            `voice_data` LONGTEXT DEFAULT NULL,
            `created_at` BIGINT DEFAULT 0
        )
    ]], {}, function()
        -- Migration checks (Independent)
        MySQL.query("SHOW COLUMNS FROM `bl_reports` LIKE 'coords'", {}, function(res)
            if not res or #res == 0 then
                MySQL.query("ALTER TABLE `bl_reports` ADD COLUMN `coords` TEXT DEFAULT NULL")
            end
        end)
        MySQL.query("SHOW COLUMNS FROM `bl_reports` LIKE 'closed_by'", {}, function(res)
            if not res or #res == 0 then
                MySQL.query("ALTER TABLE `bl_reports` ADD COLUMN `closed_by` VARCHAR(100) DEFAULT NULL")
            end
        end)
        MySQL.query("SHOW COLUMNS FROM `bl_reports` LIKE 'voice_data'", {}, function(res)
            if not res or #res == 0 then
                MySQL.query("ALTER TABLE `bl_reports` ADD COLUMN `voice_data` LONGTEXT DEFAULT NULL")
            end
        end)
    end)

    -- Wait a bit for migration to finish if needed
    Wait(1000)

    -- Load reports that are not closed
    MySQL.query("SELECT * FROM bl_reports WHERE status != 'closed' ORDER BY id ASC", {}, function(results)
        if results then
            activeReports = {}
            for _, row in ipairs(results) do
                local rSrc = getSourceFromLicense(row.reporter_license)
                
                table.insert(activeReports, {
                    id = row.id,
                    license = row.reporter_license,
                    reporterSrc = rSrc,
                    playerName = row.reporter_name,
                    reason = row.reason,
                    status = row.status,
                    claimedBy = row.admin_name,
                    closedBy = row.closed_by,
                    coords = row.coords and json.decode(row.coords) or nil,
                    voice = row.voice_data,
                    timestamp = row.created_at or 0
                })
            end
            print(('[bl_admin] %d reports actifs chargés depuis la base de données.'):format(#activeReports))
        end
    end)

    -- Get total reports count (including closed)
    MySQL.query("SELECT COUNT(*) as count FROM bl_reports", {}, function(res)
        if res and res[1] then totalReportsCount = res[1].count end
    end)
end)

function AddNewPlayerToday()
    newPlayersTodayCount = newPlayersTodayCount + 1
end

function GetEnhancedReports()
    local enhanced = {}
    for _, r in ipairs(activeReports) do
        local xPlayer = nil
        
        -- Priorité 1 : Recherche par source si le joueur est toujours en ligne
        if r.reporterSrc and GetPlayerName(r.reporterSrc) then
            xPlayer = ESX.GetPlayerFromId(r.reporterSrc)
        end
        
        -- Priorité 2 : Recherche par license (fallback robuste)
        if not xPlayer then
            local pSrc = getSourceFromLicense(r.license)
            if pSrc then xPlayer = ESX.GetPlayerFromId(pSrc) end
        end

        local reportCopy = {}
        for k,v in pairs(r) do reportCopy[k] = v end
        
        if xPlayer then
            reportCopy.playerId = xPlayer.source
            reportCopy.jobLabel = (xPlayer.job and xPlayer.job.label) and (xPlayer.job.label .. " - " .. xPlayer.job.grade_label) or "Inconnu"
            reportCopy.money = (xPlayer.getAccount('money') and xPlayer.getAccount('money').money or 0) + (xPlayer.getAccount('bank') and xPlayer.getAccount('bank').money or 0)
            reportCopy.ping = GetPlayerPing(xPlayer.source)
        else
            reportCopy.playerId = nil
            reportCopy.jobLabel = "Déconnecté"
            reportCopy.ping = 0
        end
        table.insert(enhanced, reportCopy)
    end
    return enhanced
end

RegisterNetEvent('bl_admin:submitReport')
AddEventHandler('bl_admin:submitReport', function(data)
    local src = source
    local reason = data.reason
    local coords = data.coords -- Passées depuis le client NUI callback
    if not reason or reason == "" then return end

    local name = GetPlayerName(src)
    local ids = getIdentifiers(src)
    local license = ids.license
    local now = os.time() * 1000

    -- Insert into DB first to get a real persistent ID
    MySQL.insert("INSERT INTO bl_reports (reporter_license, reporter_name, reason, status, created_at, coords, voice_data) VALUES (?, ?, ?, ?, ?, ?, ?)", {
        license, name, reason, 'open', now, json.encode(coords), data.voice
    }, function(insertId)
        if insertId then
            table.insert(activeReports, {
                id = insertId,
                license = license,
                reporterSrc = src, -- Stocker la source pour un accès rapide
                playerName = name,
                reason = reason,
                status = 'open',
                claimedBy = nil,
                coords = coords,
                voice = data.voice,
                timestamp = now
            })

            totalReportsCount = totalReportsCount + 1
            BroadcastReports()
        end
    end)
end)

RegisterNetEvent('bl_admin:requestReports')
AddEventHandler('bl_admin:requestReports', function()
    local src = source
    if not AdminPlayers[src] then return end
    
    -- On recharge d'abord les reports depuis la DB pour être sûr
    MySQL.query("SELECT * FROM bl_reports WHERE status != 'closed' ORDER BY id ASC", {}, function(results)
        if results then
            activeReports = {}
            for _, row in ipairs(results) do
                local rSrc = getSourceFromLicense(row.reporter_license)

                table.insert(activeReports, {
                    id = row.id,
                    license = row.reporter_license,
                    reporterSrc = rSrc,
                    playerName = row.reporter_name,
                    reason = row.reason,
                    status = row.status,
                    claimedBy = row.admin_name,
                    closedBy = row.closed_by,
                    coords = row.coords and json.decode(row.coords) or nil,
                    voice = row.voice_data,
                    timestamp = row.created_at or 0
                })
            end
        end
        -- Puis on broadcast à celui qui a demandé (ou à tout le monde)
        BroadcastReports()
    end)
end)

RegisterNetEvent('bl_admin:reportAction')
AddEventHandler('bl_admin:reportAction', function(data)
    local src = source
    if not AdminPlayers[src] then return end

    local reportId = data.id
    local action = data.action
    local report = nil
    local reportIdx = -1

    for i, r in ipairs(activeReports) do
        if r.id == reportId then
            report = r
            reportIdx = i
            break
        end
    end

    if not report then return end

    local adminName = GetPlayerName(src)

    if action == 'goto' then
        local xPlayer = nil
        if report.reporterSrc and GetPlayerName(report.reporterSrc) then
            xPlayer = ESX.GetPlayerFromId(report.reporterSrc)
        end
        if not xPlayer then
            xPlayer = ESX.GetPlayerFromIdentifier(report.license)
        end

        if xPlayer then
            local targetPed = GetPlayerPed(xPlayer.source)
            if DoesEntityExist(targetPed) then
                local coords = GetEntityCoords(targetPed)
                TriggerClientEvent('bl_admin:doTeleport', src, coords.x, coords.y, coords.z)
                TriggerClientEvent('bl_admin:notify', src, 'success', 'Téléporté au joueur ' .. report.playerName)
            else
                TriggerClientEvent('bl_admin:notify', src, 'error', 'Le joueur n\'a pas de ped valide')
            end
        else
            TriggerClientEvent('bl_admin:notify', src, 'error', 'Le joueur n\'est plus connecté')
        end

    elseif action == 'bring' then
        local xPlayer = nil
        if report.reporterSrc and GetPlayerName(report.reporterSrc) then
            xPlayer = ESX.GetPlayerFromId(report.reporterSrc)
        end
        if not xPlayer then
            xPlayer = ESX.GetPlayerFromIdentifier(report.license)
        end

        if xPlayer then
            local adminPed = GetPlayerPed(src)
            local coords = GetEntityCoords(adminPed)
            TriggerClientEvent('bl_admin:doTeleport', xPlayer.source, coords.x, coords.y, coords.z)
            TriggerClientEvent('bl_admin:notify', src, 'success', 'Joueur ' .. report.playerName .. ' ramené')
        else
            TriggerClientEvent('bl_admin:notify', src, 'error', 'Le joueur n\'est plus connecté')
        end

    elseif action == 'claim' then
        report.claimedBy = adminName
        report.status = 'in_progress'
        MySQL.update("UPDATE bl_reports SET status = ?, admin_name = ? WHERE id = ?", { 'in_progress', adminName, report.id })
        
        -- Notification pour TOUS les admins
        local msg = string.format('[TICKET #%d] <b>%s</b> a pris en charge le report de %s', report.id, adminName, report.playerName)
        for adminSrc, _ in pairs(AdminPlayers) do
            if adminSrc ~= src then
                TriggerClientEvent('bl_admin:notify', adminSrc, 'info', msg)
            end
        end
        -- Notification personnelle UNIQUE pour l'initiateur
        TriggerClientEvent('bl_admin:notify', src, 'info', 'Vous avez pris en charge le ticket #' .. report.id)

        addLog('moderation', 'CLAIM_REPORT', adminName, src, report.playerName, '?', 'Prise en charge du ticket #' .. report.id)

    elseif action == 'unclaim' then
        report.claimedBy = nil
        report.status = 'open'
        MySQL.update("UPDATE bl_reports SET status = ?, admin_name = NULL WHERE id = ?", { 'open', report.id })
        
        local msg = string.format('[TICKET #%d] <b>%s</b> a lâché le report de %s', report.id, adminName, report.playerName)
        for adminSrc, _ in pairs(AdminPlayers) do
            if adminSrc ~= src then
                TriggerClientEvent('bl_admin:notify', adminSrc, 'warning', msg)
            end
        end
        TriggerClientEvent('bl_admin:notify', src, 'warning', 'Vous avez lâché le ticket #' .. report.id)
        
        addLog('moderation', 'UNCLAIM_REPORT', adminName, src, report.playerName, '?', 'Abandon du ticket #' .. report.id)

    elseif action == 'close' then
        report.status = 'closed'
        report.closedBy = adminName
        MySQL.update("UPDATE bl_reports SET status = ?, closed_by = ?, voice_data = NULL WHERE id = ?", { 'closed', adminName, report.id })
        
        local msg = string.format('[TICKET #%d] <b>%s</b> a clôturé le report de %s', report.id, adminName, report.playerName)
        for adminSrc, _ in pairs(AdminPlayers) do
            if adminSrc ~= src then
                TriggerClientEvent('bl_admin:notify', adminSrc, 'success', msg)
            end
        end
        TriggerClientEvent('bl_admin:notify', src, 'success', 'Ticket #' .. report.id .. ' clôturé')
        
        addLog('moderation', 'CLOSE_REPORT', adminName, src, report.playerName, '?', 'Clôture du ticket #' .. report.id)
        
        table.remove(activeReports, reportIdx)
    end

    BroadcastReports()
end)

RegisterNetEvent('bl_admin:getReportsLeaderboard')
AddEventHandler('bl_admin:getReportsLeaderboard', function()
    local src = source
    if not AdminPlayers[src] then return end
    
    MySQL.query("SELECT admin_name, COUNT(*) as count FROM bl_reports WHERE status = 'closed' GROUP BY admin_name ORDER BY count DESC LIMIT 10", {}, function(res)
        TriggerClientEvent('bl_admin:updateReportsLeaderboard', src, res or {})
    end)
end)

function SendReportsToPlayer(src)
    local enhanced = GetEnhancedReports()
    MySQL.query("SELECT COUNT(*) as count FROM bl_reports", {}, function(res)
        local count = res and res[1] and res[1].count or 0
        TriggerClientEvent('bl_admin:updateReports', src, enhanced, count)
    end)
end

function BroadcastReports()
    local enhanced = GetEnhancedReports()
    MySQL.query("SELECT COUNT(*) as count FROM bl_reports", {}, function(res)
        if res and res[1] then
            totalReportsCount = res[1].count
        end
        for adminSrc, _ in pairs(AdminPlayers) do
            TriggerClientEvent('bl_admin:updateReports', adminSrc, enhanced, totalReportsCount)
        end
    end)
end

