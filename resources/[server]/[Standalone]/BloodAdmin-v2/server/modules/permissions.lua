-- ============================================================
--  BLOODADMIN — SERVER/MODULES/PERMISSIONS.LUA
-- ============================================================

function proceedWithGradesLoad(defaultPermsCopy, shouldDropOldTable)
    MySQL.query('SELECT * FROM bl_grades', {}, function(results)
        local dbGrades = {}
        if results and #results > 0 then
            for _, data in ipairs(results) do
                local perms = json.decode(data.permissions)
                if perms then
                    dbGrades[data.name] = true
                    
                    -- Preserve config defaults if DB is null/empty for color/icon
                    local defColor = defaultPermsCopy[data.name] and defaultPermsCopy[data.name]._color or '#3b82f6'
                    local defIcon  = defaultPermsCopy[data.name] and defaultPermsCopy[data.name]._icon or '🛡️'
                    
                    perms.level = data.level
                    perms._color = data.color or perms._color or defColor
                    perms._icon = data.icon or perms._icon or defIcon
                    
                    Config.Permissions[data.name] = perms
                end
            end
            print('[bl_admin] ' .. #results .. ' grades chargés depuis la base de données (bl_grades).')
        else
            print('[bl_admin] Aucun grade trouvé dans la table bl_grades.')
        end

        -- Ensure ALL grades in defaultPermsCopy are inserted or synchronized in bl_grades
        for gradeName, defaults in pairs(defaultPermsCopy) do
            local currentPerms = Config.Permissions[gradeName]
            local needSave = false

            if not dbGrades[gradeName] or not currentPerms then
                -- Missing grade in DB: initialize it with defaults
                Config.Permissions[gradeName] = {}
                for k, v in pairs(defaults) do
                    Config.Permissions[gradeName][k] = v
                end
                currentPerms = Config.Permissions[gradeName]
                needSave = true
                print(('[bl_admin] Grade [%s] manquant en base de données. Initialisation...'):format(gradeName))
            else
                -- Grade exists, check for missing permissions from defaults
                for permName, defaultValue in pairs(defaults) do
                    if permName:sub(1,1) ~= "_" and permName ~= "level" then
                        if currentPerms[permName] == nil then
                            currentPerms[permName] = defaultValue
                            needSave = true
                            print(('[bl_admin] Migration : Injecté permission manquante [%s] = %s pour le grade [%s]'):format(permName, tostring(defaultValue), gradeName))
                        end
                    end
                end
            end

            if needSave then
                local level = currentPerms.level or defaults.level or 0
                local color = currentPerms._color or defaults._color or '#3b82f6'
                local icon = currentPerms._icon or defaults._icon or '🛡️'
                local permsStr = json.encode(currentPerms)
                MySQL.query('INSERT INTO bl_grades (name, level, color, icon, permissions) VALUES (?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE level = ?, color = ?, icon = ?, permissions = ?', {
                    gradeName, level, color, icon, permsStr, level, color, icon, permsStr
                })
            end
        end

        -- Rename/Drop the old table if migration was successful to prevent repeating it
        if shouldDropOldTable then
            MySQL.query("DROP TABLE IF EXISTS bl_permissions_old", {}, function()
                MySQL.query("RENAME TABLE bl_permissions TO bl_permissions_old", {}, function(renameSuccess)
                    -- If rename fails, try to drop it directly
                    if renameSuccess == false then
                        MySQL.query("DROP TABLE IF EXISTS bl_permissions", {}, function()
                            print("^2[bl_admin] Migration terminée ! L'ancienne table bl_permissions a été nettoyée.^0")
                        end)
                    else
                        print("^2[bl_admin] Migration terminée ! L'ancienne table bl_permissions a été renommée en bl_permissions_old pour archivage.^0")
                    end
                end)
            end)
        end
    end)
end

function loadPermissions()
    -- Create a deep copy of the original Config.Permissions defaults
    local defaultPermsCopy = {}
    for gradeName, perms in pairs(Config.Permissions) do
        defaultPermsCopy[gradeName] = {}
        for k, v in pairs(perms) do
            defaultPermsCopy[gradeName][k] = v
        end
    end

    -- One-time automatic migration check from bl_permissions
    MySQL.query("SHOW TABLES LIKE 'bl_permissions'", {}, function(tblRes)
        if tblRes and #tblRes > 0 then
            MySQL.query("SELECT * FROM bl_permissions", {}, function(oldPerms)
                if oldPerms and #oldPerms > 0 then
                    print("^3[bl_admin] Migration : Détection de l'ancienne table bl_permissions. Début de la migration...^0")
                    local migratedGrades = {}
                    for _, r in ipairs(oldPerms) do
                        local grade = r.grade
                        local perm = r.perm
                        local value = (tonumber(r.value) == 1 or r.value == true)
                        
                        if not migratedGrades[grade] then
                            migratedGrades[grade] = {}
                        end
                        migratedGrades[grade][perm] = value
                    end
                    
                    -- Merge old perms into defaultPermsCopy
                    for grade, perms in pairs(migratedGrades) do
                        if defaultPermsCopy[grade] then
                            local importCount = 0
                            for perm, value in pairs(perms) do
                                defaultPermsCopy[grade][perm] = value
                                importCount = importCount + 1
                            end
                            print(("^3[bl_admin] Migration : %d permissions importées pour le grade [%s]^0"):format(importCount, grade))
                        end
                    end
                    proceedWithGradesLoad(defaultPermsCopy, true)
                else
                    -- Exists but has no entries
                    proceedWithGradesLoad(defaultPermsCopy, true)
                end
            end)
        else
            -- Table doesn't exist, proceed normally
            proceedWithGradesLoad(defaultPermsCopy, false)
        end
    end)
end
Citizen.CreateThread(function()
    Wait(1000)
    if MySQL then
        MySQL.query([[
            CREATE TABLE IF NOT EXISTS `bl_grades` (
                `name` VARCHAR(50) PRIMARY KEY,
                `level` INT DEFAULT 0,
                `color` VARCHAR(20) DEFAULT '#3b82f6',
                `icon` VARCHAR(50) DEFAULT '🛡️',
                `permissions` LONGTEXT
            )
        ]], {}, function()
            loadPermissions()
        end)
    end
end)

RegisterNetEvent('bl_admin:savePermissionsSecure')
AddEventHandler('bl_admin:savePermissionsSecure', function(newPerms)
    local src = tonumber(source)
    local senderGrade = AdminPlayers[src]
    print(('[bl_admin] savePermissionsSecure reçu de %s (grade: %s), type des données: %s, nb grades: %d'):format(
        GetPlayerName(src), tostring(senderGrade), type(newPerms), newPerms and type(newPerms) == 'table' and #newPerms or 0
    ))
    if not senderGrade then return end
    
    local senderLevel = Config.Permissions[senderGrade] and Config.Permissions[senderGrade].level or 0
    if senderLevel <= 0 then return end

    local updatedCount = 0
    for gradeName, perms in pairs(newPerms) do
        local currentTarget = Config.Permissions[gradeName]
        if currentTarget then
            local targetLevel = currentTarget.level or 0
            if (senderLevel >= 100) or (targetLevel < senderLevel) then
                Config.Permissions[gradeName] = perms
                updatedCount = updatedCount + 1
                
                -- Sauvegarde SQL par grade
                local level = perms.level or targetLevel
                local color = perms._color or '#3b82f6'
                local icon = perms._icon or '🛡️'
                local permsStr = json.encode(perms)
                MySQL.query('INSERT INTO bl_grades (name, level, color, icon, permissions) VALUES (?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE level = ?, color = ?, icon = ?, permissions = ?', {
                    gradeName, level, color, icon, permsStr, level, color, icon, permsStr
                })
            end
        end
    end

    if updatedCount > 0 then
        adminLog('CONFIG', GetPlayerName(src), 'PERMISSIONS', 'Mise à jour SQL de ' .. updatedCount .. ' grades')
        TriggerClientEvent('bl_admin:notify', src, 'success', 'Permissions sauvegardées dans la table bl_grades.')
        TriggerClientEvent('bl_admin:updateConfig', -1, Config)
    else
        TriggerClientEvent('bl_admin:notify', src, 'error', 'Aucune modification autorisée.')
    end
end)

RegisterServerEvent('bl_admin:requestConfig')
AddEventHandler('bl_admin:requestConfig', function()
    local src = tonumber(source)
    if not isPlayerStaff(src) then return end
    TriggerClientEvent('bl_admin:updateConfig', src, Config, AdminPlayers[src])
end)

RegisterNetEvent('bl_admin:addGrade')
AddEventHandler('bl_admin:addGrade', function(data)
    local src = tonumber(source)
    if not checkPermission(src, 'bl.staff') then return end

    local senderLevel = Config.Permissions[AdminPlayers[src]] and Config.Permissions[AdminPlayers[src]].level or 0
    local name  = tostring(data.name):lower():gsub('%s+', '_')
    local level = tonumber(data.level) or 30
    local color = tostring(data.color or '#3b82f6')
    local icon  = tostring(data.icon or '🛡️')

    -- Sécurité : ne peut pas créer un grade de niveau supérieur ou égal au sien (sauf boss)
    if senderLevel < 100 and level >= senderLevel then
        TriggerClientEvent('bl_admin:notify', src, 'error', 'Impossible de créer un grade de niveau ≥ au vôtre.')
        return
    end

    if Config.Permissions[name] then
        TriggerClientEvent('bl_admin:notify', src, 'error', 'Ce grade existe déjà : ' .. name)
        return
    end

    -- Créer avec toutes les permissions à false par défaut
    local defaultPerms = { level = level, _color = color, _icon = icon }
    local allKeys = { 'bl.ban','bl.kick','bl.warn','bl.spectate','bl.freeze',
        'bl.resources','bl.logs','bl.noclip','bl.teleport','bl.revive','bl.heal','bl.inventory','bl.delveh','bl.spawnveh','bl.tpzones','bl.offlinemod','bl.viewip' }
    for _, k in ipairs(allKeys) do defaultPerms[k] = false end

    Config.Permissions[name] = defaultPerms

    -- Sauvegarder en SQL
    local permsStr = json.encode(defaultPerms)
    MySQL.query('INSERT INTO bl_grades (name, level, color, icon, permissions) VALUES (?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE level = ?, color = ?, icon = ?, permissions = ?', {
        name, level, color, icon, permsStr, level, color, icon, permsStr
    }, function()
        adminLog('CONFIG', GetPlayerName(src), 'ADD_GRADE', 'Grade créé : ' .. name .. ' (niv.' .. level .. ')')
        TriggerClientEvent('bl_admin:notify', src, 'success', 'Grade "' .. name .. '" créé avec succès.')
        TriggerClientEvent('bl_admin:updateConfig', -1, Config)
    end)
end)

RegisterNetEvent('bl_admin:deleteGrade')
AddEventHandler('bl_admin:deleteGrade', function(data)
    local src = tonumber(source)
    if not checkPermission(src, 'bl.staff') then return end

    local name = tostring(data.name)
    if not Config.Permissions[name] then return end

    if name == 'boss' then
        TriggerClientEvent('bl_admin:notify', src, 'error', 'Impossible de supprimer le grade suprême.')
        return
    end

    Config.Permissions[name] = nil

    -- Reassign online players who had this grade to nil (no access)
    for pId, currentGrade in pairs(AdminPlayers) do
        if currentGrade == name then
            AdminPlayers[pId] = nil
            TriggerClientEvent('bl_admin:setGrade', pId, nil, nil)
        end
    end

    MySQL.query('DELETE FROM bl_grades WHERE name = ?', { name }, function()
        adminLog('CONFIG', GetPlayerName(src), 'DELETE_GRADE', 'Grade supprimé : ' .. name)
        TriggerClientEvent('bl_admin:notify', src, 'success', 'Grade "' .. name .. '" supprimé.')
        TriggerClientEvent('bl_admin:updateConfig', -1, Config)
    end)
end)

RegisterNetEvent('bl_admin:updateGradeSettings')
AddEventHandler('bl_admin:updateGradeSettings', function(data)
    local src = tonumber(source)
    if not checkPermission(src, 'bl.staff') then return end

    local oldName = tostring(data.oldName)
    local newName = tostring(data.newName):lower():gsub('%s+', '_')
    local level   = tonumber(data.level) or 30
    local color   = tostring(data.color or '#3b82f6')
    local icon    = tostring(data.icon or '🛡️')

    if not Config.Permissions[oldName] then return end

    -- Si on change le nom, vérifier si le nouveau existe déjà
    if oldName ~= newName and Config.Permissions[newName] then
        TriggerClientEvent('bl_admin:notify', src, 'error', 'Le nom "' .. newName .. '" est déjà utilisé.')
        return
    end

    -- Mettre à jour les données
    local perms = Config.Permissions[oldName]
    perms.level = level
    perms._color = color
    perms._icon = icon

    if oldName ~= newName then
        Config.Permissions[newName] = perms
        Config.Permissions[oldName] = nil
        -- Update all online players who had the old grade
        for pId, currentGrade in pairs(AdminPlayers) do
            if currentGrade == oldName then
                AdminPlayers[pId] = newName
                TriggerClientEvent('bl_admin:setGrade', pId, newName, perms)
            end
        end

        -- SQL : Update name AND data
        MySQL.query('UPDATE bl_grades SET name = ?, level = ?, color = ?, icon = ?, permissions = ? WHERE name = ?', {
            newName, level, color, icon, json.encode(perms), oldName
        }, function()
            TriggerClientEvent('bl_admin:notify', src, 'success', 'Grade renommé et mis à jour.')
            TriggerClientEvent('bl_admin:updateConfig', -1, Config)
        end)
    else
        -- SQL : Just update data
        MySQL.query('UPDATE bl_grades SET level = ?, color = ?, icon = ?, permissions = ? WHERE name = ?', {
            level, color, icon, json.encode(perms), oldName
        }, function()
            TriggerClientEvent('bl_admin:notify', src, 'success', 'Paramètres du grade mis à jour.')
            TriggerClientEvent('bl_admin:updateConfig', -1, Config)
        end)
    end
end)
