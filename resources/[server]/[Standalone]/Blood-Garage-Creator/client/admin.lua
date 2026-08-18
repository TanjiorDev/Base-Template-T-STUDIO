-- ============================================================
-- BLOODLEAK PREMIUM 2026 SPLIT GARAGE DASHBOARD — CLIENT/ADMIN.LUA
-- ============================================================

-- Helper de normalisation universelle pour les points de spawn (indépendant du type d'indexation CEF)
function normalizeSpawnPoints(spawn)
    if not spawn then return nil end
    local normalized = {}
    
    -- Si c'est déjà un vecteur FiveM natif directement
    if type(spawn) == 'userdata' or type(spawn) == 'vector4' or type(spawn) == 'vector3' then
        return { { x = spawn.x, y = spawn.y, z = spawn.z, w = spawn.w or spawn.heading or 0.0 } }
    end

    if type(spawn) ~= 'table' then return nil end

    -- Si c'est un point unique indexé par ses axes (ex: { x = ..., y = ... })
    if spawn.x then
        return { { x = tonumber(spawn.x) or 0.0, y = tonumber(spawn.y) or 0.0, z = tonumber(spawn.z) or 0.0, w = tonumber(spawn.w or spawn.heading) or 0.0 } }
    end

    -- Si c'est un tableau de points (avec des clés numériques, chaînes ou des structures complexes)
    for k, v in pairs(spawn) do
        if type(v) == 'table' or type(v) == 'userdata' or type(v) == 'vector4' or type(v) == 'vector3' then
            local x = tonumber(v.x or v[1]) or 0.0
            local y = tonumber(v.y or v[2]) or 0.0
            local z = tonumber(v.z or v[3]) or 0.0
            local w = tonumber(v.w or v[4] or v.heading) or 0.0
            table.insert(normalized, { x = x, y = y, z = z, w = w })
        end
    end

    return #normalized > 0 and normalized or nil
end

-- Récupérer la position et orientation actuelle du joueur pour la configuration
RegisterNUICallback('getCurrentCoords', function(data, cb)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    cb({
        x = math.floor(coords.x * 100) / 100,
        y = math.floor(coords.y * 100) / 100,
        z = math.floor(coords.z * 100) / 100,
        w = math.floor(heading * 100) / 100
    })
end)

-- Sauvegarder la configuration d'une fourrière (Appelle le serveur)
RegisterNUICallback('saveImpoundConfig', function(data, cb)
    cb({ success = true }) -- Résolution instantanée pour éviter tout freeze CEF/NUI
    ESX.TriggerServerCallback('bl_garage:saveImpound', function(success)
        -- Traitement silencieux en tâche de fond (la synchronisation globale mettra à jour l'état)
    end, data.garageId, data.config)
end)

-- Supprimer la configuration d'un garage ou d'une fourrière (Appelle le serveur)
RegisterNUICallback('deleteGarage', function(data, cb)
    cb({ success = true }) -- Résolution instantanée pour éviter tout freeze CEF/NUI
    ESX.TriggerServerCallback('bl_garage:deleteGarage', function(success)
        -- Traitement silencieux en tâche de fond (la synchronisation globale mettra à jour l'état)
    end, data.garageId)
end)

-- Callback NUI pour démarrer la sélection interactive de coordonnées sur place
RegisterNUICallback('startPositionSelection', function(data, cb)
    local selectionType = data.type or 'ped'
    
    -- Activer l'état de sélection pour bloquer la boucle d'interaction principale
    IsSelectingCoords = true
    
    -- 1. Masquer temporairement l'interface NUI (sans détruire l'état)
    SendNUIMessage({ action = "tempHide", type = selectionType })
    SetNuiFocus(false, false)
    
    -- Notification sonore discrète
    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    
    -- 2. Démarrer la boucle asynchrone de sélection interactive
    Citizen.CreateThread(function()
        local selecting = true
        
        -- Empêcher le spam de validation immédiate si la touche E était déjà enfoncée
        Citizen.Wait(200)
        
        while selecting do
            Citizen.Wait(0)
            
            -- Bloquer temporairement certaines touches de combat/tir pour éviter les accidents
            DisableControlAction(0, 24, true) -- Tirer
            DisableControlAction(0, 25, true) -- Visée
            DisableControlAction(0, 37, true) -- Menu armes
            DisableControlAction(0, 140, true) -- Attaque corps à corps
            
            -- Touche [E] pressée : Validation de la position
            if IsControlJustReleased(0, 38) then
                local playerPed = PlayerPedId()
                local coords = GetEntityCoords(playerPed)
                local heading = GetEntityHeading(playerPed)
                
                -- Arrêter la boucle et réinitialiser l'état
                selecting = false
                IsSelectingCoords = false
                
                -- Rétablir le focus NUI
                SetNuiFocus(true, true)
                
                -- Envoyer les coordonnées au NUI
                SendNUIMessage({
                    action = "coordsSelected",
                    type = selectionType,
                    coords = {
                        x = math.floor(coords.x * 100) / 100,
                        y = math.floor(coords.y * 100) / 100,
                        z = math.floor(coords.z * 100) / 100,
                        w = math.floor(heading * 100) / 100
                    }
                })
                
                -- Rétablir visuellement le NUI
                SendNUIMessage({ action = "tempRestore" })
                
                -- Notification sonore de validation
                PlaySoundFrontend(-1, "Challenge_Passed", "HUD_AWARDS", true)
                ESX.ShowNotification("~g~[ADMIN]~s~ Position enregistrée avec succès !")
                
            -- Touche [BACKSPACE] / [CELLPHONE_CANCEL] pressée : Annulation
            elseif IsControlJustReleased(0, 177) then
                -- Arrêter la boucle et réinitialiser l'état
                selecting = false
                IsSelectingCoords = false
                
                -- Rétablir le focus NUI et l'affichage sans modification
                SetNuiFocus(true, true)
                SendNUIMessage({ action = "tempRestore" })
                
                -- Notification sonore d'annulation
                PlaySoundFrontend(-1, "CANCEL", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                ESX.ShowNotification("~r~[ADMIN]~s~ Sélection de position annulée.")
            end
        end
    end)
    
    cb('ok')
end)

-- Synchronisation en temps réel de tous les points de garage et fourrière depuis le serveur
RegisterNetEvent('bl_garage:syncGarages')
AddEventHandler('bl_garage:syncGarages', function(loaded, notify)
    if not loaded then loaded = {} end
    debugPrint('^2[bl_garage] Synchronisation dynamique reçue. Mise à jour des garages...^0')
    
    -- Supprimer d'abord les anciens garages personnalisés qui ne sont plus présents dans la liste synchronisée ou marqués comme supprimés
    for id, garage in pairs(Config.Garages) do
        local idStr = tostring(id)
        if (string.match(idStr, "^impound_custom_") and not loaded[idStr]) or (loaded[idStr] and loaded[idStr].deleted) then
            Config.Garages[id] = nil
        end
    end

    for id, data in pairs(loaded) do
        if data then
            if data.deleted then
                Config.Garages[tostring(id)] = nil
            elseif data.coords and data.spawn then
                local pointType = data.type or "impound"
                local blipSprite = tonumber(data.blipSprite)
                local blipColor = tonumber(data.blipColor)
                
                if not blipSprite or blipSprite == 0 then
                    blipSprite = 357
                    if pointType == "boat" then blipSprite = 427
                    elseif pointType == "air" then blipSprite = 307
                    elseif pointType == "helicopter" then blipSprite = 422
                    elseif pointType == "impound" then blipSprite = 68
                    elseif pointType == "impound_boat" then blipSprite = 427
                    elseif pointType == "impound_air" then blipSprite = 307
                    elseif pointType == "impound_helicopter" then blipSprite = 422 end
                    blipColor = 3
                    if pointType == "impound" then blipColor = 5 end
                end

                local normalized = normalizeSpawnPoints(data.spawn)
                local spawnPoints = {}
                local firstSpawn = { x = 0.0, y = 0.0, z = 0.0, w = 0.0 }
                if normalized then
                    for _, pt in ipairs(normalized) do
                        table.insert(spawnPoints, vector4(pt.x, pt.y, pt.z, pt.w))
                    end
                    firstSpawn = normalized[1]
                else
                    spawnPoints = { vector4(0.0, 0.0, 0.0, 0.0) }
                end

                local localData = {
                    label = data.label,
                    type = pointType,
                    coords = vector3(data.coords.x or 0.0, data.coords.y or 0.0, data.coords.z or 0.0),
                    pedModel = data.pedModel or "s_m_y_xmech_01",
                    pedHeading = tonumber(data.pedHeading) or 0.0,
                    spawn = spawnPoints,
                    delete = (pointType ~= "impound") and (data.delete and vector3(data.delete.x or 0.0, data.delete.y or 0.0, data.delete.z or 0.0) or vector3(firstSpawn.x or 0.0, firstSpawn.y or 0.0, firstSpawn.z or 0.0)) or nil,
                    deleteSize = type(data.deleteSize) == 'number' and data.deleteSize or (type(data.deleteSize) == 'string' and tonumber(data.deleteSize) or 7.0),
                    blipSprite = blipSprite,
                    blipColor = blipColor,
                    blip = { active = true, sprite = blipSprite, color = blipColor, scale = 0.8, label = data.label },
                    job = nil
                }
                Config.Garages[tostring(id)] = localData
                print(string.format("[bl_garage CLIENT SYNC] id: %s | Nom: %s | spawn (brut): %s | spawn (local): %s", tostring(id), tostring(localData.label), json.encode(data.spawn), json.encode(spawnPoints)))
            end
        end
    end
    
    -- Ré-initialiser les PNJs et les Blips pour appliquer immédiatement les modifications
    initGarage()
    if notify and ESX then
        ESX.ShowNotification("~g~[ADMIN]~s~ Configuration mise à jour en temps réel !")
    end
end)

-- Événement pour ouvrir le menu d'administration générale
RegisterNetEvent('bl_garage:openMasterAdmin')
AddEventHandler('bl_garage:openMasterAdmin', function()
    local allGaragesList = {}
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

        allGaragesList[id] = {
            label = g.label,
            type = g.type or "car",
            coords = { x = g.coords.x or g.coords[1] or 0.0, y = g.coords.y or g.coords[2] or 0.0, z = g.coords.z or g.coords[3] or 0.0 },
            pedModel = g.pedModel or "s_m_y_xmech_01",
            pedHeading = g.pedHeading or 0.0,
            spawn = spawnData or { x = 0.0, y = 0.0, z = 0.0, w = 0.0 },
            delete = g.delete and { x = g.delete.x or g.delete[1] or 0.0, y = g.delete.y or g.delete[2] or 0.0, z = g.delete.z or g.delete[3] or 0.0 } or nil,
            deleteSize = g.deleteSize or 7.0,
            blipSprite = g.blipSprite or (g.blip and g.blip.sprite) or 357,
        }
    end

    for id, g in pairs(allGaragesList) do
        print(string.format("[bl_garage CLIENT TO NUI] id: %s | Nom: %s | spawn envoyé: %s", tostring(id), tostring(g.label), json.encode(g.spawn)))
    end

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openMasterAdmin",
        isAdmin = true,
        impoundsList = allGaragesList
    })
end)

-- Suggestions pour le chat
Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/garageadmin', 'Ouvrir le panneau d\'administration de tous les garages/fourrières.')
    TriggerEvent('chat:addSuggestion', '/admingarage', 'Ouvrir le panneau d\'administration de tous les garages/fourrières.')
end)
