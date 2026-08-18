-- ============================================================
-- BLOODLEAK PREMIUM 2026 SPLIT GARAGE DASHBOARD — CLIENT/NUI.LUA
-- ============================================================

-- 1. Callbacks NUI standards (Joueur)
RegisterNUICallback('close', function(data, cb)
    IsSelectingCoords = false
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('playHoverSound', function(data, cb)
    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    cb('ok')
end)

RegisterNUICallback('playSelectSound', function(data, cb)
    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    cb('ok')
end)

RegisterNUICallback('trackVehicle', function(data, cb)
    local plate = data.plate
    local found = false
    local coords = nil

    -- Rechercher d'abord dans les véhicules chargés localement (Stream client)
    local vehicles = ESX.Game.GetVehicles()
    for _, vehicle in ipairs(vehicles) do
        local vehPlate = GetVehicleNumberPlateText(vehicle)
        if vehPlate then
            local cleanVehPlate = string.gsub(vehPlate, "^%s*(.-)%s*$", "%1"):upper()
            local cleanPlate = string.gsub(plate, "^%s*(.-)%s*$", "%1"):upper()
            if cleanVehPlate == cleanPlate then
                coords = GetEntityCoords(vehicle)
                found = true
                break
            end
        end
    end

    if found and coords then
        SetNewWaypoint(coords.x, coords.y)
        ESX.ShowNotification("~r~[GPS]~s~ Véhicule localisé ! Le tracé GPS a été ajouté à votre carte.")
        cb({ success = true })
    else
        -- Fallback : Demander aux serveurs la position globale (hors-stream)
        ESX.TriggerServerCallback('bl_garage:getVehiclePosition', function(position)
            if position then
                SetNewWaypoint(position.x, position.y)
                ESX.ShowNotification("~r~[GPS]~s~ Balise satellite active. Le tracé GPS a été mis à jour.")
                cb({ success = true })
            else
                ESX.ShowNotification("~r~[GPS]~s~ Impossible de localiser la balise de ce véhicule. Est-il détruit ?")
                cb({ success = false })
            end
        end, plate)
    end
end)

-- Helper pour obtenir un point de spawn libre (supporte un point unique ou une liste de points)
function GetFreeSpawnPoint(garage)
    if not garage or not garage.spawn then return nil end
    
    -- Si garage.spawn est une coordonnée directe (table ou vector4 avec x)
    if garage.spawn.x then
        local coords = vector3(garage.spawn.x, garage.spawn.y, garage.spawn.z)
        if IsSpawnPointClear(coords, Config.SpawnRadius) then
            return garage.spawn
        end
        return nil
    end
    
    -- Si garage.spawn est une liste/table de plusieurs points
    for _, point in ipairs(garage.spawn) do
        local coords = vector3(point.x, point.y, point.z)
        if IsSpawnPointClear(coords, Config.SpawnRadius) then
            return point
        end
    end
    
    return nil
end

RegisterNUICallback('spawnVehicle', function(data, cb)
    local plate = data.plate
    local playerPed = PlayerPedId()
    local garage = Config.Garages[CurrentGarage]

    if not garage then return end

    -- Vérifier si un point de spawn est libre
    local chosenSpawn = GetFreeSpawnPoint(garage)
    if not chosenSpawn then
        ESX.ShowNotification(_T('spawn_blocked'))
        cb({ success = false })
        return
    end

    -- Demande de spawn au serveur (mise à jour état)
    ESX.TriggerServerCallback('bl_garage:spawnVehicle', function(success, props)
        if success then
            -- Masquer le NUI
            SetNuiFocus(false, false)
            SendNUIMessage({ action = "close" })

            -- Charger le modèle
            local model = props.model
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(10)
            end

            -- Créer le véhicule sur le point libre choisi
            local vehicle = CreateVehicle(model, chosenSpawn.x, chosenSpawn.y, chosenSpawn.z, chosenSpawn.w or chosenSpawn.heading or 0.0, true, false)
            SetEntityAsMissionEntity(vehicle, true, true)
            
            -- Appliquer les propriétés
            ESX.Game.SetVehicleProperties(vehicle, props)
            
            -- Remettre le niveau d'essence et la santé
            if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
            if props.bodyHealth then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
            if props.fuelLevel then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) end

            -- Placer le joueur dedans
            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
            SetVehicleHasBeenOwnedByPlayer(vehicle, true)

            ESX.ShowNotification(_T('vehicle_spawned'))
            cb({ success = true })
        else
            cb({ success = false })
        end
    end, plate, CurrentGarage)
end)

RegisterNUICallback('retrieveImpound', function(data, cb)
    local plate = data.plate
    local playerPed = PlayerPedId()
    local garage = Config.Garages[CurrentGarage]

    if not garage then return end

    -- Vérifier si un point de spawn est libre
    local chosenSpawn = GetFreeSpawnPoint(garage)
    if not chosenSpawn then
        ESX.ShowNotification(_T('spawn_blocked'))
        cb({ success = false })
        return
    end

    -- Payer la fourrière et changer l'état côté serveur
    ESX.TriggerServerCallback('bl_garage:retrieveImpound', function(success, props)
        if success then
            -- Masquer le NUI
            SetNuiFocus(false, false)
            SendNUIMessage({ action = "close" })

            -- Charger le modèle
            local model = props.model
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(10)
            end

            -- Créer le véhicule sur le point libre choisi
            local vehicle = CreateVehicle(model, chosenSpawn.x, chosenSpawn.y, chosenSpawn.z, chosenSpawn.w or chosenSpawn.heading or 0.0, true, false)
            SetEntityAsMissionEntity(vehicle, true, true)
            
            -- Appliquer les propriétés
            ESX.Game.SetVehicleProperties(vehicle, props)
            
            -- Remettre le niveau d'essence et la santé
            if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
            if props.bodyHealth then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
            if props.fuelLevel then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) end

            -- Placer le joueur dedans
            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
            SetVehicleHasBeenOwnedByPlayer(vehicle, true)

            ESX.ShowNotification(_T('impound_retrieved', Config.ImpoundFee))
            cb({ success = true })
        else
            ESX.ShowNotification(_T('not_enough_money', Config.ImpoundFee))
            cb({ success = false })
        end
    end, plate, CurrentGarage)
end)

RegisterNUICallback('transferVehicle', function(data, cb)
    local plate = data.plate
    local playerPed = PlayerPedId()
    local garage = Config.Garages[CurrentGarage]

    if not garage then return end

    -- Vérifier si un point de spawn est libre
    local chosenSpawn = GetFreeSpawnPoint(garage)
    if not chosenSpawn then
        ESX.ShowNotification(_T('spawn_blocked'))
        cb({ success = false })
        return
    end

    -- Effectuer le transfert payant côté serveur
    ESX.TriggerServerCallback('bl_garage:transferVehicle', function(success, props)
        if success then
            -- Masquer le NUI
            SetNuiFocus(false, false)
            SendNUIMessage({ action = "close" })

            -- Charger le modèle
            local model = props.model
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(10)
            end

            -- Créer le véhicule sur le point libre choisi
            local vehicle = CreateVehicle(model, chosenSpawn.x, chosenSpawn.y, chosenSpawn.z, chosenSpawn.w or chosenSpawn.heading or 0.0, true, false)
            SetEntityAsMissionEntity(vehicle, true, true)
            
            -- Appliquer les propriétés
            ESX.Game.SetVehicleProperties(vehicle, props)
            
            -- Remettre le niveau d'essence et la santé
            if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
            if props.bodyHealth then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
            if props.fuelLevel then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) end

            -- Placer le joueur dedans
            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
            SetVehicleHasBeenOwnedByPlayer(vehicle, true)

            ESX.ShowNotification(string.format("Véhicule livré depuis un autre garage pour ~g~%d$~s~ !", Config.TransferFee))
            cb({ success = true })
        else
            ESX.ShowNotification(string.format("~r~Vous n'avez pas assez d'argent (%d$) !", Config.TransferFee))
            cb({ success = false })
        end
    end, plate, CurrentGarage)
end)

-- Helper pour vérifier si le point de spawn est libre
function IsSpawnPointClear(coords, radius)
    local vehicles = GetVehiclesInArea(coords, radius)
    return #vehicles == 0
end

-- Récupérer tous les véhicules proches via le pool de jeu natif (100% stable et indépendant d'ESX)
function GetVehiclesInArea(coords, radius)
    local vehicles = {}
    local allVehicles = GetGamePool('CVehicle')
    for _, vehicle in ipairs(allVehicles) do
        if DoesEntityExist(vehicle) then
            local vehicleCoords = GetEntityCoords(vehicle)
            if #(coords - vehicleCoords) < radius then
                table.insert(vehicles, vehicle)
            end
        end
    end
    return vehicles
end
