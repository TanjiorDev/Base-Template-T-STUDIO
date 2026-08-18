-- ============================================================
--  BLOODADMIN — SERVER/MODULES/VEHICLES.LUA
-- ============================================================

local CustomVehicles = {}

Citizen.CreateThread(function()
    Wait(2000)
    if MySQL then
        MySQL.query([[
            CREATE TABLE IF NOT EXISTS `bl_catalog` (
                `id` INT AUTO_INCREMENT PRIMARY KEY,
                `name` VARCHAR(100),
                `model` VARCHAR(50),
                `type` VARCHAR(50),
                `props` LONGTEXT DEFAULT NULL
            )
        ]], {}, function()
            MySQL.query("SHOW COLUMNS FROM `bl_catalog` LIKE 'props'", {}, function(cols)
                local function checkImageColumn()
                    MySQL.query("SHOW COLUMNS FROM `bl_catalog` LIKE 'image'", {}, function(imageCols)
                        if not imageCols or #imageCols == 0 then
                            MySQL.query("ALTER TABLE `bl_catalog` ADD COLUMN `image` LONGTEXT DEFAULT NULL", {}, function()
                                print('[bl_admin] Catalogue SQL : Colonne image ajoutée.')
                                loadCustomVehicles()
                            end)
                        else
                            loadCustomVehicles()
                        end
                    end)
                end

                if not cols or #cols == 0 then
                    MySQL.query("ALTER TABLE `bl_catalog` ADD COLUMN `props` LONGTEXT DEFAULT NULL", {}, function()
                        print('[bl_admin] Catalogue SQL : Colonne props ajoutée.')
                        checkImageColumn()
                    end)
                else
                    checkImageColumn()
                end
            end)
        end)
    end
end)

function loadCustomVehicles()
    MySQL.query('SELECT * FROM bl_catalog', {}, function(res)
        CustomVehicles = res or {}
        print(('[bl_admin] %d véhicules chargés depuis le catalogue.'):format(#CustomVehicles))
    end)
end

function GetCustomVehicles()
    return CustomVehicles
end

-- Refresh UI with custom vehicles
function syncCatalog(source)
    TriggerClientEvent('bl_admin:updateCatalog', source, CustomVehicles)
end

-- Give vehicle to player (Persistent)
RegisterNetEvent('bl_admin:giveVehicleToPlayer')
AddEventHandler('bl_admin:giveVehicleToPlayer', function(data)
    local src = source
    if not checkPermission(src, 'bl.giveveh') then return end

    local xTarget = ESX.GetPlayerFromId(data.targetId)
    if not xTarget then
        TriggerClientEvent('bl_admin:notify', src, 'error', 'Joueur non trouvé')
        return
    end

    local plate = (data.plate or ("BLOOD" .. math.random(10, 99))):sub(1, 8):upper()
    local vehicleData = { model = GetHashKey(data.model), plate = plate }

    MySQL.insert('INSERT INTO owned_vehicles (owner, plate, vehicle, type, job, `stored`) VALUES (?, ?, ?, ?, ?, ?)', {
        xTarget.identifier,
        plate,
        json.encode(vehicleData),
        'car',
        'civ',
        1
    }, function(id)
        if id then
            TriggerClientEvent('bl_admin:notify', src, 'success', ('Véhicule %s donné à %s (Plaque: %s)'):format(data.model, xTarget.name, plate))
            TriggerClientEvent('bl_admin:notify', data.targetId, 'success', ('Un administrateur vous a donné un véhicule (%s)'):format(data.model))
            
            -- Log the action
            addLog('vehicle', 'GIVE_VEHICLE', GetPlayerName(src), src, xTarget.name, data.targetId, ('A donné un %s (Plaque: %s)'):format(data.model, plate))
        end
    end)
end)

-- Save vehicle properties if owned
RegisterNetEvent('bl_admin:saveVehicleIfOwned')
AddEventHandler('bl_admin:saveVehicleIfOwned', function(props)
    local src = source
    if not props or not props.plate then return end

    MySQL.update('UPDATE owned_vehicles SET vehicle = ? WHERE plate = ?', {
        json.encode(props),
        props.plate
    }, function(affectedRows)
        if affectedRows > 0 then
            -- Optional: notify player that it's saved
            -- TriggerClientEvent('bl_admin:notify', src, 'info', 'Modifications enregistrées sur votre véhicule personnel.')
        end
    end)
end)

RegisterNetEvent('bl_admin:addVehicleToCatalog')
AddEventHandler('bl_admin:addVehicleToCatalog', function(data)
    local src = source
    if not isPlayerStaff(src) then return end
    if not checkPermission(src, 'bl.spawnveh') then return end

    local imageVal = (data.image and data.image ~= "") and data.image or nil

    MySQL.insert('INSERT INTO bl_catalog (name, model, type, props, image) VALUES (?, ?, ?, ?, ?)', {
        data.name, data.model, data.type, data.props and json.encode(data.props) or nil, imageVal
    }, function(insertId)
        if insertId then
            table.insert(CustomVehicles, {
                id = insertId,
                name = data.name,
                model = data.model,
                type = data.type,
                props = data.props and json.encode(data.props) or nil,
                image = imageVal
            })
            print(('[bl_admin] Catalogue : Véhicule inséré avec succès en BDD. ID=%d | Nom=%s | Modèle=%s | Image=%s'):format(insertId, data.name, data.model, tostring(imageVal)))
            -- Broadcast to all staff members
            for staffId, _ in pairs(AdminPlayers) do
                syncCatalog(staffId)
            end
            addLog('moderation', 'ADD_VEHICLE', GetPlayerName(src), src, data.name, '0', 'Ajout d\'un véhicule au catalogue : ' .. data.model)
        end
    end)
end)

RegisterNetEvent('bl_admin:removeVehicleFromCatalog')
AddEventHandler('bl_admin:removeVehicleFromCatalog', function(id)
    local src = source
    if not isPlayerStaff(src) then return end
    if not checkPermission(src, 'bl.spawnveh') then return end

    MySQL.update('DELETE FROM bl_catalog WHERE id = ?', { id }, function()
        for k, v in ipairs(CustomVehicles) do
            if v.id == id then
                table.remove(CustomVehicles, k)
                break
            end
        end
        -- Broadcast to all staff members
        for staffId, _ in pairs(AdminPlayers) do
            syncCatalog(staffId)
        end
    end)
end)

RegisterNetEvent('bl_admin:requestSpawnVehicle')
AddEventHandler('bl_admin:requestSpawnVehicle', function(data)
    local src = source
    local model, props = nil, nil
    if type(data) == 'table' then
        model = data.model
        props = data.props
    else
        model = data
    end

    if not checkPermission(src, 'bl.spawnveh') then
        TriggerClientEvent('bl_admin:notify', src, 'error', 'Vous n\'avez pas la permission de faire apparaître un véhicule.')
        return 
    end
    TriggerClientEvent('bl_admin:doSpawnVehicle', src, model, props)
    addLog('vehicle', 'SPAWN_VEHICLE', GetPlayerName(src), src, 'SERVEUR', 0, 'Apparition véhicule : ' .. tostring(model))
end)

RegisterNetEvent('bl_admin:requestDeleteVehicle')
AddEventHandler('bl_admin:requestDeleteVehicle', function(radius)
    local src = source
    if not checkPermission(src, 'bl.delveh') then
        TriggerClientEvent('bl_admin:notify', src, 'error', 'Vous n\'avez pas la permission de supprimer des véhicules.')
        return 
    end
    TriggerClientEvent('bl_admin:doDeleteVehicle', src, radius)
    addLog('vehicle', 'DELETE_VEHICLE', GetPlayerName(src), src, 'SERVEUR', 0, 'Suppression de véhicule(s)')
end)

RegisterNetEvent('bl_admin:requestVehicleAction')
AddEventHandler('bl_admin:requestVehicleAction', function(data)
    local src = source
    local action = data.action
    local perm = 'bl.repairveh'
    
    -- Actions avancées demandant bl.customveh
    local advanced = { color = true, plate = true, max = true, godmode = true, boost = true, eject = true }
    if advanced[action] then perm = 'bl.customveh' end

    if not checkPermission(src, perm) then
        TriggerClientEvent('bl_admin:notify', src, 'error', 'Vous n\'avez pas la permission pour cette action véhicule.')
        return 
    end

    TriggerClientEvent('bl_admin:doVehicleAction', src, data)
    addLog('vehicle', 'ACTION_' .. string.upper(action), GetPlayerName(src), src, 'SERVEUR', 0, 'Action : ' .. action)
end)
