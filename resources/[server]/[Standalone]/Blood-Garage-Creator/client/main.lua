-- ============================================================
-- BLOODLEAK PREMIUM 2026 SPLIT GARAGE DASHBOARD — CLIENT/MAIN.LUA
-- ============================================================

if ESX == nil then
    local ok, result = pcall(function() return exports['es_extended']:getSharedObject() end)
    if ok and result then
        ESX = result
    else
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
end

-- Variables globales partagées (sans local pour le split modulaire)
PlayerData = {}
CurrentGarage = nil
CurrentAction = nil
InsideMarker = false
SpawnedPeds = {}
CreatedBlips = {}
IsSelectingCoords = false
SpawningInProgress = {}

-- 1. Initialisation immédiate et chargement sécurisé de l'objet ESX
Citizen.CreateThread(function()
    -- Lancer l'initialisation des blips et PNJs par défaut immédiatement (évite tout écran noir / carte vide)
    initGarage()

    -- Demander immédiatement au serveur la synchronisation des configurations personnalisées
    TriggerServerEvent('bl_garage:requestSync')

    -- Attendre ensuite le chargement de ESX en tâche de fond de manière non bloquante
    while ESX == nil do
        local ok, result = pcall(function() return exports['es_extended']:getSharedObject() end)
        if ok and result then
            ESX = result
        else
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        end
        Citizen.Wait(100)
    end

    -- Attendre que la session GTA 5 soit active et que le joueur soit chargé en jeu
    while not NetworkIsSessionActive() or not PlayerPedId() or PlayerPedId() == 0 do
        Citizen.Wait(200)
    end

    -- Courte pause de sécurité pour que le jeu se stabilise
    Citizen.Wait(1000)

    PlayerData = ESX.GetPlayerData() or {}
end)

-- Événements ESX pour rafraîchir le Job et recharger à la connexion
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    -- Recharger proprement en cas de changement de personnage ou spawn
    TriggerServerEvent('bl_garage:requestSync')
    initGarage()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

-- Helper pour afficher l'aide textuelle à l'écran (Anti-Spam Bip)
local lastNotificationText = nil
function showHelpNotification(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    local shouldBeep = (text ~= lastNotificationText)
    EndTextCommandDisplayHelp(0, false, shouldBeep, -1)
    if shouldBeep then
        lastNotificationText = text
    end
end

-- Nettoyage des Blips existants
function cleanupBlips()
    for _, blip in ipairs(CreatedBlips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    CreatedBlips = {}
end

-- 2. Création des Blips sur la carte
function createBlips()
    cleanupBlips()
    for id, garage in pairs(Config.Garages) do
        if garage.blip and garage.blip.active then
            local blip = AddBlipForCoord(garage.coords)
            SetBlipSprite(blip, garage.blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, garage.blip.scale)
            SetBlipColour(blip, garage.blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(garage.blip.label)
            EndTextCommandSetBlipName(blip)
            
            table.insert(CreatedBlips, blip)
        end
    end
end

-- Nettoyage des PNJs existants (Avec double sécurité anti-duplication par pool d'entités)
function cleanupPeds()
    -- Invalider tous les chargements et spawnings asynchrones en cours (sécurité anti PNJ-fantôme)
    SpawningInProgress = {}

    -- Étape 1 : Nettoyer via la table de suivi locale SpawnedPeds (indexée par garageId)
    for id, ped in pairs(SpawnedPeds) do
        if DoesEntityExist(ped) then
            SetEntityAsMissionEntity(ped, true, true)
            DeletePed(ped)
            DeleteEntity(ped)
        end
    end
    SpawnedPeds = {}

    -- Étape 2 : Sécurité supplémentaire par scan de zone (éradique définitivement les PNJs orphelins doublonnés)
    local ok, peds = pcall(function() return GetGamePool('CPed') end)
    if ok and peds then
        for _, ped in ipairs(peds) do
            if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
                local coords = GetEntityCoords(ped)
                for id, garage in pairs(Config.Garages) do
                    if garage.coords then
                        local dist = #(coords - garage.coords)
                        if dist < 2.0 then
                            SetEntityAsMissionEntity(ped, true, true)
                            DeletePed(ped)
                            DeleteEntity(ped)
                        end
                    end
                end
            end
        end
    end
end

-- 3. Spawning dynamique d'un seul PNJ Garagiste (Sécurisé avec Préchargement et Spawning Atomique anti-duplication)
function spawnSinglePed(id)
    local garage = Config.Garages[id]
    if not garage or not garage.pedModel or not garage.coords then return end
    
    -- Si le PNJ est déjà instancié ou si un spawn est déjà en cours pour ce garage, on ignore
    if SpawnedPeds[id] and DoesEntityExist(SpawnedPeds[id]) then return end
    if SpawningInProgress[id] then return end
    
    -- Verrouiller le processus de spawn pour ce garage
    SpawningInProgress[id] = true
    
    local modelHash = GetHashKey(garage.pedModel)
    
    -- Charger le modèle de manière asynchrone sans bloquer le thread principal
    Citizen.CreateThread(function()
        RequestModel(modelHash)
        local timeout = 3000
        while not HasModelLoaded(modelHash) and timeout > 0 do
            Citizen.Wait(50)
            timeout = timeout - 50
        end
        
        -- Vérifier si le spawn n'a pas été annulé entre-temps (par un cleanupPeds) et que le modèle est chargé
        if SpawningInProgress[id] and HasModelLoaded(modelHash) then
            -- Double check de sécurité anti-concurrence
            if not SpawnedPeds[id] or not DoesEntityExist(SpawnedPeds[id]) then
                -- Rechercher si un PNJ valide existe déjà à cet endroit précis dans le monde
                local ok, peds = pcall(function() return GetGamePool('CPed') end)
                local foundOrphan = false
                if ok and peds then
                    for _, ped in ipairs(peds) do
                        if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
                            local coords = GetEntityCoords(ped)
                            local dist = #(coords - garage.coords)
                            if dist < 1.5 then
                                local model = GetEntityModel(ped)
                                if model == modelHash then
                                    -- PNJ identique trouvé : on le réutilise au lieu d'en recréer un
                                    SpawnedPeds[id] = ped
                                    SetEntityCoords(ped, garage.coords.x, garage.coords.y, garage.coords.z - 0.98, false, false, false, false)
                                    SetEntityHeading(ped, garage.pedHeading or 0.0)
                                    FreezeEntityPosition(ped, true)
                                    SetEntityInvincible(ped, true)
                                    SetBlockingOfNonTemporaryEvents(ped, true)
                                    TaskSetBlockingOfNonTemporaryEvents(ped, true)
                                    SetPedHearingRange(ped, 0.0) -- Rendre sourd
                                    SetPedSeeingRange(ped, 0.0)  -- Rendre aveugle
                                    SetPedAlertness(ped, 0)     -- Calme
                                    SetPedRelationshipGroupHash(ped, GetHashKey("PLAYER")) -- Ami
                                    SetPedCanCowerInCover(ped, false)
                                    SetPedCombatAttributes(ped, 17, false) -- CA_ALWAYS_FLEE = false (ne s'enfuit pas)
                                    SetPedCombatAttributes(ped, 46, true)  -- CA_IGNORE_GUNSHOTS = true
                                    TaskStandStill(ped, -1) -- Forcer le surplace absolu
                                    SpawningInProgress[id] = nil
                                    return
                                else
                                    -- Modèle obsolète/différent, on le nettoie
                                    SetEntityAsMissionEntity(ped, true, true)
                                    DeletePed(ped)
                                    DeleteEntity(ped)
                                    foundOrphan = true
                                end
                            end
                        end
                    end
                end

                if foundOrphan then
                    Citizen.Wait(150) -- Laisser le temps au moteur de supprimer le vieux PNJ
                end

                local ped = CreatePed(4, modelHash, garage.coords.x, garage.coords.y, garage.coords.z - 0.98, garage.pedHeading or 0.0, false, true)
                SpawnedPeds[id] = ped -- Assigner immédiatement pour bloquer toute concurrence durant le wait
                SetEntityAsMissionEntity(ped, true, true) -- Rendre le PNJ persistant au niveau du moteur
                
                -- Attendre un court instant pour que l'entité soit pleinement instanciée par le moteur physique
                Citizen.Wait(200)
                
                SetEntityInvincible(ped, true)
                SetBlockingOfNonTemporaryEvents(ped, true)
                TaskSetBlockingOfNonTemporaryEvents(ped, true) -- Force la non-réaction aux événements (coups de feu, etc)
                SetEntityCanBeDamaged(ped, false)
                SetPedCanRagdollFromPlayerImpact(ped, false)
                SetPedCanRagdoll(ped, false)
                SetPedCanPlayAmbientAnims(ped, false) -- Désactiver les animations d'ambiance qui peuvent déplacer le PNJ
                SetPedFleeAttributes(ped, 0, false)
                SetPedHearingRange(ped, 0.0) -- Rendre sourd aux tirs
                SetPedSeeingRange(ped, 0.0)  -- Rendre aveugle aux armes
                SetPedAlertness(ped, 0)     -- Etat de calme
                SetPedRelationshipGroupHash(ped, GetHashKey("PLAYER")) -- Consommer comme allié
                SetPedCanCowerInCover(ped, false)
                SetPedCombatAttributes(ped, 17, false) -- CA_ALWAYS_FLEE = false
                SetPedCombatAttributes(ped, 46, true)  -- CA_IGNORE_GUNSHOTS = true
                SetEntityProofs(ped, true, true, true, true, true, true, true, true) -- Invulnérable à tout
                SetPedConfigFlag(ped, 281, true) -- Disable Cowering
                SetPedConfigFlag(ped, 188, true) -- Désactiver la panique
                                
                -- Figer immédiatement pour stabiliser la position au sol
                FreezeEntityPosition(ped, true)
                TaskStandStill(ped, -1) -- Forcer le surplace absolu

                SetModelAsNoLongerNeeded(modelHash)
                SpawnedPeds[id] = ped

                -- Double sécurité : s'assurer qu'il reste gelé 1 seconde plus tard
                Citizen.CreateThread(function()
                    Citizen.Wait(1000)
                    if DoesEntityExist(ped) then
                        FreezeEntityPosition(ped, true)
                    end
                end)
            end
        else
            if not HasModelLoaded(modelHash) then
                print('^1[bl_garage] ERREUR : Le modèle de PNJ ' .. garage.pedModel .. ' n\'a pas pu être chargé.^0')
            end
        end
        
        -- Libérer le verrou de spawn (qu'il y ait eu succès, échec ou annulation)
        SpawningInProgress[id] = nil
    end)
end

-- Fonction d'initialisation globale (PNJs + Blips)
function initGarage()
    print('^2[bl_garage] Initialisation du parc (PNJs + Blips)...^0')
    createBlips()
    cleanupPeds() -- La routine du thread s'occupera d'instancier les PNJs à proximité

    -- Bloc Diagnostic F8 pour vérifier les valeurs exactes chargées
    for id, g in pairs(Config.Garages) do
        print(string.format("[bl_garage DIAGNOSTIC] Garage ID: %s | Type: %s | Point Rangement (delete): %s | Taille Rangement (deleteSize): %s", 
            tostring(id), tostring(g.type), tostring(g.delete), tostring(g.deleteSize)))
    end
end

-- Nettoyage propre lors du redémarrage de la ressource
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        cleanupPeds()
        cleanupBlips()
    end
end)

-- 4. Thread principal (Interactions PNJs et Ranger Voiture)
Citizen.CreateThread(function()
    while true do
        local wait = 1000
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        InsideMarker = false
        CurrentAction = nil

        for id, garage in pairs(Config.Garages) do
            -- Gestion dynamique de spawn/despawn du PNJ à distance (150 mètres)
            if garage.coords then
                local distPed = #(coords - garage.coords)
                if distPed < 150.0 then
                    if not SpawnedPeds[id] or not DoesEntityExist(SpawnedPeds[id]) then
                        spawnSinglePed(id)
                    else
                        local ped = SpawnedPeds[id]
                        local pCoords = GetEntityCoords(ped)
                        local distMoved = #(pCoords - garage.coords)
                        if distMoved > 0.1 or IsPedFleeing(ped) then
                            -- Si le PNJ a bougé ou fuit, on le replace et on le ré-initialise complètement
                            SetEntityCoords(ped, garage.coords.x, garage.coords.y, garage.coords.z - 0.98, false, false, false, false)
                            SetEntityHeading(ped, garage.pedHeading or 0.0)
                            ClearPedTasksImmediately(ped)
                            FreezeEntityPosition(ped, true)
                            TaskStandStill(ped, -1)
                            SetPedHearingRange(ped, 0.0)
                            SetPedSeeingRange(ped, 0.0)
                            SetPedAlertness(ped, 0)
                            SetPedRelationshipGroupHash(ped, GetHashKey("PLAYER"))
                        end
                        FreezeEntityPosition(ped, true)
                    end
                else
                    if SpawnedPeds[id] and DoesEntityExist(SpawnedPeds[id]) then
                        SetEntityAsMissionEntity(SpawnedPeds[id], true, true)
                        DeletePed(SpawnedPeds[id])
                        DeleteEntity(SpawnedPeds[id])
                        SpawnedPeds[id] = nil
                    end
                end

                -- POINT D'OUVERTURE DU GARAGE (INTERACTION PNJ)
                local distMenu = distPed
                if distMenu < 10.0 then
                    wait = 0
                    
                    -- Interaction proche (3.0 mètres max pour parler au garagiste - ultra accessible !)
                    if distMenu < 3.0 then
                        InsideMarker = true
                        CurrentGarage = id
                        CurrentAction = "menu"
                        
                        -- Texte dynamique selon le type (Fourrière ou Garagiste)
                        local msg = _T('open_garage')
                        if garage.type == 'impound' then
                            msg = _T('open_impound')
                        end
                        showHelpNotification(msg)
                    end
                end

                -- POINT DE RANGER LE VEHICULE (si disponible, visible même à pied)
                if garage.delete then
                    local distDelete = #(coords - garage.delete)
                    if distDelete < 30.0 then -- Increased draw distance for storage zone (from 15m to 30m)
                        wait = 0
                        local size = 7.0
                        if type(garage.deleteSize) == 'number' then
                            size = garage.deleteSize
                        elseif type(garage.deleteSize) == 'string' then
                            size = tonumber(garage.deleteSize) or 7.0
                        end
                        -- Calcul de la hauteur Z exacte du sol à cette position (résout définitivement le conflit Z pieds/bassin)
                        local groundZ = garage.delete.z
                        if garage.type ~= "boat" and garage.type ~= "impound_boat" then
                            local foundGround, trueGroundZ = GetGroundZFor_3dCoord(garage.delete.x, garage.delete.y, garage.delete.z + 2.0, false)
                            if foundGround then
                                groundZ = trueGroundZ
                            end
                        end
                        
                        local radius = size / 2.0
                        
                        -- 1. Lumière dynamique rouge volcanique (100% visible sur tous les packs graphiques)
                        DrawLightWithRange(garage.delete.x, garage.delete.y, groundZ + 0.2,
                            239, 68, 68, radius + 1.0, 4.5)
                        
                        -- 2. Icône clé/voiture rotative au centre (Type 36 — style NoPixel)
                        DrawMarker(36, garage.delete.x, garage.delete.y, groundZ + 0.35,
                            0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                            0.6, 0.6, 0.6,
                            239, 68, 68, 255,
                            true, true, 2, true)
                        
                        -- 3. Cercle périphérique : 16 petits cylindres positionnés mathématiquement sur le périmètre
                        --    Fonctionne sur TOUS les PC et packs graphiques, indépendamment des shaders
                        local segments = 16
                        for i = 0, segments - 1 do
                            local angle = (i / segments) * (2.0 * math.pi)
                            local dotX = garage.delete.x + radius * math.cos(angle)
                            local dotY = garage.delete.y + radius * math.sin(angle)
                            DrawMarker(1, dotX, dotY, groundZ - 0.02,
                                0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                                0.35, 0.35, 0.25,
                                239, 68, 68, 230,
                                false, false, 2, false)
                        end
                        
                        -- L'interaction s'adapte également à la taille du point de rangement
                        if distDelete < size and IsPedInAnyVehicle(playerPed, false) then
                            InsideMarker = true
                            CurrentGarage = id
                            CurrentAction = "store"
                            showHelpNotification(_T('store_vehicle'))
                        end
                    end
                end
            end -- Fin de if garage.coords
        end -- Fin du for loop

        if not InsideMarker then
            lastNotificationText = nil
        end

        -- Gestion des touches
        if InsideMarker and CurrentAction and not IsSelectingCoords then
            if IsControlJustReleased(0, 38) then -- Touche E
                if CurrentAction == "menu" then
                    openGarageMenu(CurrentGarage)
                elseif CurrentAction == "store" then
                    storeVehicleInGarage(CurrentGarage)
                end
            end
        end

        Citizen.Wait(wait)
    end
end)

-- 4b. Ranger le véhicule
function storeVehicleInGarage(garageId)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if DoesEntityExist(vehicle) then
        local vehicleClass = GetVehicleClass(vehicle)
        local isBoat = (vehicleClass == 14)
        local isHeli = (vehicleClass == 15)
        local isPlane = (vehicleClass == 16)
        local isAir = (isHeli or isPlane)
        
        local garage = Config.Garages[garageId]
        local currentGarageType = garage and garage.type or "car"
        local canStore = false
        
        if currentGarageType == "car" and not isBoat and not isAir then
            canStore = true
        elseif currentGarageType == "boat" and isBoat then
            canStore = true
        elseif currentGarageType == "air" and isPlane then
            canStore = true
        elseif currentGarageType == "helicopter" and isHeli then
            canStore = true
        end
        
        if not canStore then
            ESX.ShowNotification(_T('invalid_vehicle_type'))
            return
        end

        local props = ESX.Game.GetVehicleProperties(vehicle)
        
        -- Demander au serveur de valider la plaque et de stocker
        ESX.TriggerServerCallback('bl_garage:checkVehicleOwner', function(isOwner)
            if isOwner then
                -- Récupérer la santé et essence pour sauvegarde
                props.engineHealth = GetVehicleEngineHealth(vehicle)
                props.bodyHealth = GetVehicleBodyHealth(vehicle)
                props.fuelLevel = GetVehicleFuelLevel(vehicle)
                
                -- Supprimer l'entité
                TaskLeaveVehicle(playerPed, vehicle, 0)
                Citizen.Wait(800)
                
                -- S'assurer que le véhicule est bien supprimé côté client
                local maxAttempts = 50
                while DoesEntityExist(vehicle) and maxAttempts > 0 do
                    DeleteVehicle(vehicle)
                    DeleteEntity(vehicle)
                    Citizen.Wait(50)
                    maxAttempts = maxAttempts - 1
                end

                TriggerServerEvent('bl_garage:setStoredState', props.plate, 1, props, garageId)
                ESX.ShowNotification(_T('vehicle_stored'))
            else
                ESX.ShowNotification(_T('not_owner'))
            end
        end, props.plate)
    else
        ESX.ShowNotification(_T('no_vehicle'))
    end
end

-- 5. Ouvrir l'interface NUI du Garage
function openGarageMenu(garageId)
    local garage = Config.Garages[garageId]
    if not garage then return end

    -- Demande de la liste des véhicules
    ESX.TriggerServerCallback('bl_garage:getVehicles', function(vehicles, isAdmin)
        -- Si aucun véhicule n'est renvoyé ou vide
        local vehicleList = vehicles or {}
        
        -- Formater les véhicules pour l'UI
        local formattedVehicles = {}
        for _, v in ipairs(vehicleList) do
            local props = json.decode(v.vehicle)
            
            -- Diagnostic F8 pour vérifier les valeurs brutes de la base de données
            debugPrint(string.format("^3[bl_garage DEBUG F8]^0 Plaque: %s | stored: %s (Type: %s) | state: %s (Type: %s) | garage: %s (Type: %s)", 
                tostring(v.plate), tostring(v.stored), type(v.stored), tostring(v.state), type(v.state), tostring(v.garage), type(v.garage)))
            
            local modelHash = props.model
            
            -- Déduire le nom du modèle propre en minuscule (pour récupération de l'image CDN)
            local modelNameStr = nil
            for hashStr, friendlyLabel in pairs(Config.VehicleLabels) do
                if GetHashKey(hashStr) == modelHash then
                    modelNameStr = hashStr:lower()
                    break
                end
            end
            
            if not modelNameStr and props.modelName then
                modelNameStr = props.modelName:lower()
            end
            
            if not modelNameStr then
                local modelNameNative = GetDisplayNameFromVehicleModel(modelHash)
                if modelNameNative and modelNameNative ~= "CARNOTFOUND" then
                    modelNameStr = modelNameNative:lower()
                end
            end
            
            local modelName = modelNameStr or "unknown"
            
            -- Récupération du label
            local label = "Véhicule Inconnu"
            for hashStr, friendlyLabel in pairs(Config.VehicleLabels) do
                if GetHashKey(hashStr) == modelHash then
                    label = friendlyLabel
                    break
                end
            end
            
            if label == "Véhicule Inconnu" and props.modelName then
                label = Config.VehicleLabels[props.modelName:lower()] or props.modelName
            end
 
            -- Si toujours inconnu, on récupère le DisplayName natif
            if label == "Véhicule Inconnu" then
                local modelNameNative = GetDisplayNameFromVehicleModel(modelHash)
                if modelNameNative and modelNameNative ~= "CARNOTFOUND" then
                    label = modelNameNative
                end
            end
 
            -- Détecter de manière ultra-robuste stored et state (conflit de scripts tiers évité !)
            local isStored = 1 -- Par défaut stocké s'il n'y a aucune donnée
            local sVal = v.stored
            local stVal = v.state
            
            if sVal ~= nil or stVal ~= nil then
                isStored = 0
                if sVal == 1 or sVal == true or tonumber(sVal) == 1 or stVal == 1 or stVal == true or tonumber(stVal) == 1 then
                    isStored = 1
                elseif sVal == 2 or tonumber(sVal) == 2 or stVal == 2 or tonumber(stVal) == 2 then
                    isStored = 2
                end
            end
 
            -- Si la colonne garage est vide, NULL ou invalide en BDD, on l'affecte au garage actuel par sécurité
            local vehicleGarage = v.garage
            if vehicleGarage == nil or vehicleGarage == "" or vehicleGarage == "NULL" then
                vehicleGarage = garageId
            end
 
            -- États : 1 = Rangé dans le garage actuel, 0 = Dehors (Fourrière), 2 = Fourrière explicite
            local status = _T('stored_status')
            local statusRaw = "stored"
 
            -- Si le véhicule n'est pas dans ce garage précis OU s'il est dehors, il est disponible en "Fourrière"
            if isStored == 0 then
                status = _T('out_status')
                statusRaw = "out"
            elseif isStored == 2 then
                status = _T('impounded_status')
                statusRaw = "impound"
            elseif vehicleGarage ~= garageId then
                status = "Autre Garage (" .. (Config.Garages[vehicleGarage] and Config.Garages[vehicleGarage].label or vehicleGarage) .. ")"
                statusRaw = "other_garage"
            end
 
            -- Santé par défaut
            local health = props.engineHealth or 1000.0
            local body = props.bodyHealth or 1000.0
            local fuel = props.fuelLevel or 100.0
 
            -- Détecter la classe pour le filtrage
            local vehicleClass = GetVehicleClassFromName(props.model)
            local isBoat = (vehicleClass == 14)
            local isAir = (vehicleClass == 15 or vehicleClass == 16)
            
            local showVehicle = false
            local currentGarageType = garage.type or "car"
            local isHeli = (vehicleClass == 15) -- Hélicoptères uniquement (class 15)
            local isPlane = (vehicleClass == 16) -- Avions uniquement (class 16)
            -- Reclassifier isAir : avions + helis pour les garages génériques
            
            if currentGarageType == "car" and not isBoat and not isAir then
                showVehicle = true
            elseif currentGarageType == "boat" and isBoat then
                showVehicle = true
            elseif currentGarageType == "air" and isPlane then
                showVehicle = true
            elseif currentGarageType == "helicopter" and isHeli then
                showVehicle = true
            elseif currentGarageType == "impound" then
                -- Fourrière voitures : tout sauf bateaux et aéronefs
                if isStored == 2 and not isBoat and not isAir then
                    showVehicle = true
                end
            elseif currentGarageType == "impound_boat" then
                -- Fourrière bateaux uniquement
                if isStored == 2 and isBoat then
                    showVehicle = true
                end
            elseif currentGarageType == "impound_air" then
                -- Fourrière avions uniquement (class 16)
                if isStored == 2 and isPlane then
                    showVehicle = true
                end
            elseif currentGarageType == "impound_helicopter" then
                -- Fourrière hélicoptères uniquement (class 15)
                if isStored == 2 and isHeli then
                    showVehicle = true
                end
            end
 
            if showVehicle then
                table.insert(formattedVehicles, {
                    plate = v.plate,
                    label = label,
                    model = props.model,
                    modelName = modelName,
                    status = status,
                    statusRaw = statusRaw,
                    engineHealth = math.floor(health / 10), -- En %
                    bodyHealth = math.floor(body / 10), -- En %
                    fuel = math.floor(fuel), -- En %
                    props = props,
                    originalGarage = v.garage,
                    class = vehicleClass
                })
            end
        end
 
        -- Construire la liste de tous les garages et fourrières existants pour l'édition admin
        local impoundsList = {}
        for id, g in pairs(Config.Garages) do
            local spawnData = nil
            if g.spawn then
                if type(g.spawn) == 'table' and g.spawn[1] then
                    spawnData = {}
                    for _, pt in ipairs(g.spawn) do
                        table.insert(spawnData, { x = pt.x or pt[1] or 0.0, y = pt.y or pt[2] or 0.0, z = pt.z or pt[3] or 0.0, w = pt.w or pt[4] or pt.heading or 0.0 })
                    end
                else
                    spawnData = { x = g.spawn.x or g.spawn[1] or 0.0, y = g.spawn.y or g.spawn[2] or 0.0, z = g.spawn.z or g.spawn[3] or 0.0, w = g.spawn.w or g.spawn[4] or g.spawn.heading or 0.0 }
                end
            end
 
            impoundsList[id] = {
                label = g.label,
                type = g.type or "car",
                coords = { x = g.coords.x or g.coords[1] or 0.0, y = g.coords.y or g.coords[2] or 0.0, z = g.coords.z or g.coords[3] or 0.0 },
                pedModel = g.pedModel or "s_m_y_xmech_01",
                pedHeading = g.pedHeading or 0.0,
                spawn = spawnData or { x = 0.0, y = 0.0, z = 0.0, w = 0.0 },
                delete = g.delete and { x = g.delete.x or g.delete[1] or 0.0, y = g.delete.y or g.delete[2] or 0.0, z = g.delete.z or g.delete[3] or 0.0 } or nil,
                deleteSize = g.deleteSize or 7.0,
                blipSprite = g.blipSprite or (g.blip and g.blip.sprite) or 357,
                blipColor = g.blipColor or (g.blip and g.blip.color) or 3
            }
        end
 
        -- Envoyer au NUI et l'afficher
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "open",
            garageLabel = garage.label,
            garageType = garage.type,
            currentGarageId = garageId,
            vehicles = formattedVehicles,
            impoundFee = Config.ImpoundFee,
            transferFee = Config.TransferFee,
            isAdmin = isAdmin or false,
            impoundsList = impoundsList
        })
 
    end, garageId)
end
