-- ============================================================
-- BLOODLEAK PREMIUM 2026 SPLIT GARAGE DASHBOARD — SERVER/GARAGE.LUA
-- ============================================================

-- Table temporaire pour suivre les véhicules récemment sortis/récupérés (évite la duplication due à la latence de synchro réseau des plaques)
RecentlySpawned = {}

-- Déclaration des Callbacks joueur une fois ESX disponible
function registerServerCallbacks()
    -- Callback : Récupérer tous les véhicules possédés par un joueur
    ESX.RegisterServerCallback('bl_garage:getVehicles', function(source, cb, garageId)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then
            cb({})
            return
        end

        MySQL.query("SELECT * FROM owned_vehicles WHERE owner = ?", { xPlayer.identifier }, function(results)
            if results and #results > 0 then
                -- Récupérer la liste des plaques actives sur le serveur
                local activePlates = {}
                local allVehicles = GetAllVehicles()
                for _, vehicle in ipairs(allVehicles) do
                    if DoesEntityExist(vehicle) then
                        local plate = GetVehicleNumberPlateText(vehicle)
                        if plate then
                            local cleanPlate = string.gsub(plate, "^%s*(.-)%s*$", "%1"):upper()
                            activePlates[cleanPlate] = true
                        end
                    end
                end

                for _, v in ipairs(results) do
                    local cleanPlate = string.gsub(v.plate, "^%s*(.-)%s*$", "%1"):upper()
                    
                    -- Lire de manière ultra-robuste stored et state (conflit de scripts tiers évité !)
                    local isStored = 0
                    local sVal = v.stored
                    local stVal = v.state
                    
                    if sVal == 1 or sVal == true or tonumber(sVal) == 1 or stVal == 1 or stVal == true or tonumber(stVal) == 1 then
                        isStored = 1
                    elseif sVal == 2 or tonumber(sVal) == 2 or stVal == 2 or tonumber(stVal) == 2 then
                        isStored = 2
                    end

                    -- Si dehors (0) mais plus dans le monde réel -> Auto-impound !
                    -- Ajout de la vérification du cooldown RecentlySpawned (évite le retour immédiat en fourrière lors de la synchro)
                    local isRecentlySpawned = RecentlySpawned[cleanPlate] and (os.time() - RecentlySpawned[cleanPlate] < 15)
                    if isStored == 0 and not activePlates[cleanPlate] and not isRecentlySpawned then
                        v.stored = 2
                        if v.state ~= nil then v.state = 2 end
                        updateVehicleStorage(cleanPlate, 2)
                        debugPrint(string.format("^3[bl_garage DEBUG F8]^0 Plaque: %s | Auto-Impounded (Plus dans le monde)", cleanPlate))
                    end
                end
            else
                debugPrint("^3[bl_garage DEBUG]^0 Aucun véhicule possédé trouvé en BDD pour : " .. tostring(xPlayer.identifier))
            end
            cb(results or {}, isAdmin(source))
        end)
    end)

    -- Callback : Vérifier si le joueur possède le véhicule (Plaque)
    ESX.RegisterServerCallback('bl_garage:checkVehicleOwner', function(source, cb, plate)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then
            cb(false)
            return
        end

        local cleanPlate = string.gsub(plate or "", "^%s*(.-)%s*$", "%1"):upper()
        local noSpacePlate = string.gsub(plate or "", "[^%w]", ""):upper()

        MySQL.query("SELECT 1 FROM owned_vehicles WHERE owner = ? AND (plate = ? OR REPLACE(plate, ' ', '') = ?)", { 
            xPlayer.identifier, 
            cleanPlate,
            noSpacePlate
        }, function(results)
            if results and #results > 0 then
                cb(true)
            else
                local resType = type(results)
                local resLen = results and #results or 0
                debugPrint(string.format("^3[bl_garage DEBUG F8]^0 checkVehicleOwner FAILED! Player: %s, Plate sent: '%s', Cleaned: '%s', resType: %s, resLen: %d", xPlayer.identifier, tostring(plate), tostring(cleanPlate), resType, resLen))
                cb(false)
            end
        end)
    end)

    -- Callback : Sortir un véhicule du garage (stored = 1 -> stored = 0)
    ESX.RegisterServerCallback('bl_garage:spawnVehicle', function(source, cb, plate, garageId)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then
            cb(false)
            return
        end

        local cleanPlate = string.gsub(plate or "", "^%s*(.-)%s*$", "%1"):upper()
        local noSpacePlate = string.gsub(plate or "", "[^%w]", ""):upper()

        MySQL.query("SELECT * FROM owned_vehicles WHERE owner = ? AND (plate = ? OR REPLACE(plate, ' ', '') = ?)", { 
            xPlayer.identifier, 
            cleanPlate,
            noSpacePlate
        }, function(results)
            if results and #results > 0 then
                local vehicleData = results[1]
                
                -- Lire l'état actuel de stockage
                local isStored = 0
                local sVal = vehicleData.stored
                local stVal = vehicleData.state
                
                if sVal == 1 or sVal == true or tonumber(sVal) == 1 or stVal == 1 or stVal == true or tonumber(stVal) == 1 then
                    isStored = 1
                elseif sVal == 2 or tonumber(sVal) == 2 or stVal == 2 or tonumber(stVal) == 2 then
                    isStored = 2
                end

                -- Empêcher le spawn si le véhicule n'est pas stocké (évite la duplication par double-clic/triche)
                if isStored ~= 1 then
                    cb(false)
                    return
                end

                -- Mettre à jour en BDD à dehors (stored = 0)
                updateVehicleStorage(cleanPlate, 0, garageId, xPlayer.identifier, nil, function(affectedRows)
                    RecentlySpawned[cleanPlate] = os.time()
                    -- Nettoyage automatique des anciennes entrées
                    local now = os.time()
                    for p, t in pairs(RecentlySpawned) do
                        if now - t > 60 then RecentlySpawned[p] = nil end
                    end

                    local props = safeJsonDecode(vehicleData.vehicle)
                    props.plate = vehicleData.plate -- Force la plaque exacte de la DB
                    cb(true, props)
                end)
            else
                cb(false)
            end
        end)
    end)

    -- Callback : Récupérer le véhicule de la fourrière (Dépense d'argent + spawn)
    ESX.RegisterServerCallback('bl_garage:retrieveImpound', function(source, cb, plate, garageId)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then
            cb(false)
            return
        end

        local cleanPlate = string.gsub(plate or "", "^%s*(.-)%s*$", "%1"):upper()
        local noSpacePlate = string.gsub(plate or "", "[^%w]", ""):upper()
        local fee = Config.ImpoundFee or 1500

        -- Vérifier l'argent du joueur
        local hasEnough = false
        local account = 'cash'

        if xPlayer.getMoney() >= fee then
            hasEnough = true
            account = 'cash'
        elseif xPlayer.getAccount('bank') and xPlayer.getAccount('bank').money >= fee then
            hasEnough = true
            account = 'bank'
        end

        if hasEnough then
            MySQL.query("SELECT * FROM owned_vehicles WHERE owner = ? AND (plate = ? OR REPLACE(plate, ' ', '') = ?)", { 
                xPlayer.identifier, 
                cleanPlate,
                noSpacePlate
            }, function(results)
                if results and #results > 0 then
                    local vehicleData = results[1]
                    
                    -- Lire l'état actuel de stockage
                    local isStored = 0
                    local sVal = vehicleData.stored
                    local stVal = vehicleData.state
                    
                    if sVal == 1 or sVal == true or tonumber(sVal) == 1 or stVal == 1 or stVal == true or tonumber(stVal) == 1 then
                        isStored = 1
                    elseif sVal == 2 or tonumber(sVal) == 2 or stVal == 2 or tonumber(stVal) == 2 then
                        isStored = 2
                    end

                    -- Empêcher la récupération si le véhicule n'est pas en fourrière (évite la duplication)
                    if isStored ~= 2 then
                        cb(false)
                        return
                    end

                    -- Retirer l'argent du compte
                    if account == 'cash' then
                        xPlayer.removeMoney(fee)
                    else
                        xPlayer.removeAccountMoney('bank', fee)
                    end

                    -- Mettre à jour en BDD à dehors (stored = 0) et assigner au garage actuel
                    updateVehicleStorage(cleanPlate, 0, garageId, xPlayer.identifier, nil, function(affectedRows)
                        RecentlySpawned[cleanPlate] = os.time()
                        -- Nettoyage automatique des anciennes entrées
                        local now = os.time()
                        for p, t in pairs(RecentlySpawned) do
                            if now - t > 60 then RecentlySpawned[p] = nil end
                        end

                        local props = safeJsonDecode(vehicleData.vehicle)
                        props.plate = vehicleData.plate
                        cb(true, props)
                    end)
                else
                    cb(false)
                end
            end)
        else
            cb(false)
        end
    end)

    -- Callback : Transférer un véhicule depuis un autre garage (Dépense d'argent de transfert + spawn)
    ESX.RegisterServerCallback('bl_garage:transferVehicle', function(source, cb, plate, garageId)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then
            cb(false)
            return
        end

        local cleanPlate = string.gsub(plate or "", "^%s*(.-)%s*$", "%1"):upper()
        local noSpacePlate = string.gsub(plate or "", "[^%w]", ""):upper()
        local fee = Config.TransferFee or 500

        -- Vérifier l'argent du joueur
        local hasEnough = false
        local account = 'cash'

        if xPlayer.getMoney() >= fee then
            hasEnough = true
            account = 'cash'
        elseif xPlayer.getAccount('bank') and xPlayer.getAccount('bank').money >= fee then
            hasEnough = true
            account = 'bank'
        end

        if hasEnough then
            MySQL.query("SELECT * FROM owned_vehicles WHERE owner = ? AND (plate = ? OR REPLACE(plate, ' ', '') = ?)", { 
                xPlayer.identifier, 
                cleanPlate,
                noSpacePlate
            }, function(results)
                if results and #results > 0 then
                    local vehicleData = results[1]
                    
                    -- Lire l'état actuel de stockage
                    local isStored = 0
                    local sVal = vehicleData.stored
                    local stVal = vehicleData.state
                    
                    if sVal == 1 or sVal == true or tonumber(sVal) == 1 or stVal == 1 or stVal == true or tonumber(stVal) == 1 then
                        isStored = 1
                    elseif sVal == 2 or tonumber(sVal) == 2 or stVal == 2 or tonumber(stVal) == 2 then
                        isStored = 2
                    end

                    -- Empêcher le transfert si le véhicule n'est pas stocké dans un autre garage
                    if isStored ~= 1 then
                        cb(false)
                        return
                    end

                    -- Retirer l'argent du compte
                    if account == 'cash' then
                        xPlayer.removeMoney(fee)
                    else
                        xPlayer.removeAccountMoney('bank', fee)
                    end

                    -- Mettre à jour en BDD à dehors (stored = 0) et assigner au garage actuel
                    updateVehicleStorage(cleanPlate, 0, garageId, xPlayer.identifier, nil, function(affectedRows)
                        RecentlySpawned[cleanPlate] = os.time()
                        -- Nettoyage automatique des anciennes entrées
                        local now = os.time()
                        for p, t in pairs(RecentlySpawned) do
                            if now - t > 60 then RecentlySpawned[p] = nil end
                        end

                        local props = safeJsonDecode(vehicleData.vehicle)
                        props.plate = vehicleData.plate
                        cb(true, props)
                    end)
                else
                    cb(false)
                end
            end)
        else
            TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez pas assez d'argent (nécessite " .. fee .. "$) !")
            cb(false)
        end
    end)

    -- Callback : Récupérer les coordonnées d'un véhicule dans le monde (GPS Tracker)
    ESX.RegisterServerCallback('bl_garage:getVehiclePosition', function(source, cb, plate)
        local allVehicles = GetAllVehicles()
        local cleanPlate = string.gsub(plate, "^%s*(.-)%s*$", "%1"):upper()

        for _, vehicle in ipairs(allVehicles) do
            if DoesEntityExist(vehicle) then
                local vehPlate = GetVehicleNumberPlateText(vehicle)
                if vehPlate then
                    local cleanVehPlate = string.gsub(vehPlate, "^%s*(.-)%s*$", "%1"):upper()
                    if cleanVehPlate == cleanPlate then
                        local coords = GetEntityCoords(vehicle)
                        cb(coords)
                        return
                    end
                end
            end
        end
        cb(nil)
    end)
end

-- Hook d'initialisation découplé de l'ordre du manifeste
Citizen.CreateThread(function()
    while ESX == nil do
        local ok, result = pcall(function() return exports['es_extended']:getSharedObject() end)
        if ok and result then
            ESX = result
        else
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        end
        Citizen.Wait(100)
    end
    registerServerCallbacks()
end)
