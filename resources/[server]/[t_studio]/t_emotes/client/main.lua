local menuOpen = false
local previewPed = nil
local menuCam = nil 
local currentProp = nil
local previewProp = nil
local isPlacing = false
local pendingRequest = nil

function GetEmoteData(emoteName)
    if not DP then return nil, nil end
    for catName, catTable in pairs(DP) do
        if type(catTable) == "table" and catTable[emoteName] then return catTable[emoteName], catName end
    end
    return nil, nil
end

-- Fonction pour trouver le joueur le plus proche
function GetClosestPlayer()
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply)

    for _, player in ipairs(players) do
        local target = GetPlayerPed(player)
        if target ~= ply then
            local distance = #(GetEntityCoords(target) - plyCoords)
            if closestDistance == -1 or distance < closestDistance then
                closestPlayer = player
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end

function CreateClone()
    local playerPed = PlayerPedId()
    if previewPed and DoesEntityExist(previewPed) then DeleteEntity(previewPed) end
    previewPed = ClonePed(playerPed, GetEntityHeading(playerPed), false, false)
    SetEntityCoordsNoOffset(previewPed, GetEntityCoords(playerPed))
    SetEntityHeading(previewPed, GetEntityHeading(playerPed))
    FreezeEntityPosition(previewPed, true)
    SetEntityCollision(previewPed, false, false)
    SetBlockingOfNonTemporaryEvents(previewPed, true)
    SetEntityInvincible(previewPed, true)
end

function CleanupPreview()
    DeleteCurrentProp(true)
    if previewPed and DoesEntityExist(previewPed) then DeleteEntity(previewPed); previewPed = nil end
end

RegisterCommand('emotes', function()
    if not DP then return end
    if isPlacing then return end 

    local categorizedEmotes = {
        Emotes = {}, Dances = {}, Props = {}, Shared = {}, Walks = {},
        DeadoV2 = {}, Others = {}, LAChicago = {}, Stacking = {},
        AnimalEmotes = {}, Expressions = {}
    }

    local function PopulateCategory(sourceTable, categoryName)
        if type(sourceTable) == "table" then
            for k, v in pairs(sourceTable) do
                if type(v) == "table" then
                    local dict, anim, label
                    if categoryName == "Walks" then
                        dict, anim, label = v[1], "", tostring(v[2] or k)
                    elseif categoryName == "Expressions" then
                        if v[3] then dict, anim, label = v[1], v[2], tostring(v[3]) else dict, anim, label = v[1], "", tostring(v[2] or k) end
                    else
                        if v[3] then dict, anim, label = v[1], v[2], tostring(v[3]) elseif v[2] then dict, anim, label = v[1], v[2], tostring(k) end
                    end
                    if dict and label then table.insert(categorizedEmotes[categoryName], { id = k, dict = dict, anim = anim, label = label }) end
                end
            end
            table.sort(categorizedEmotes[categoryName], function(a, b) return a.label < b.label end)
        end
    end

    PopulateCategory(DP.Emotes, "Emotes"); PopulateCategory(DP.Dances, "Dances"); PopulateCategory(DP.PropEmotes, "Props")
    PopulateCategory(DP.Shared, "Shared"); PopulateCategory(DP.Walks, "Walks"); PopulateCategory(DP.AnimalEmotes, "AnimalEmotes")
    PopulateCategory(DP.Expressions, "Expressions"); PopulateCategory(DP.whitecustom, "DeadoV2")
    PopulateCategory(DP.whitecustom2do, "Others"); PopulateCategory(DP.whitecustom4, "LAChicago"); PopulateCategory(DP.whitecustom5, "Stacking")

    menuOpen = true
    CreateClone()
    
    local playerPed = PlayerPedId()
    menuCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    local camPos = GetOffsetFromEntityInWorldCoords(previewPed, 1.0, 2.5, 0.2)
    SetCamCoord(menuCam, camPos.x, camPos.y, camPos.z)
    PointCamAtEntity(menuCam, previewPed, 0.8, 0.0, 0.0, true)
    RenderScriptCams(true, true, 500, true, true)

    SetNuiFocus(true, true)
    SendNUIMessage({ action = "open", emotes = categorizedEmotes })

    Citizen.CreateThread(function()
        while menuOpen do Citizen.Wait(0); SetEntityLocallyInvisible(PlayerPedId()) end
    end)
end)
RegisterKeyMapping('emotes', 'Ouvrir menu Animations', 'keyboard', 'F3')

function PerformEmote(ped, emoteData, category)
    if not ped or not DoesEntityExist(ped) then return end
    
    if category == "Walks" then
        local dict = emoteData[1]
        RequestAnimSet(dict)
        local timer = 0
        while not HasAnimSetLoaded(dict) and timer < 100 do Wait(10); timer = timer + 1 end
        if HasAnimSetLoaded(dict) then SetPedMovementClipset(ped, dict, 0.2) end
        return
    end

    if category == "Expressions" then
        local animName = emoteData[2]
        if not animName or animName == "" then animName = emoteData[1] end
        SetFacialIdleAnimOverride(ped, animName, 0)
        return
    end

    ClearPedTasks(ped)
    if ped == previewPed then DeleteCurrentProp(true) else DeleteCurrentProp(false) end

    if emoteData[2] and emoteData[2] ~= "" then
        local dict = emoteData[1]
        RequestAnimDict(dict)
        local timer = 0
        while not HasAnimDictLoaded(dict) and timer < 100 do Wait(10); timer = timer + 1 end

        if HasAnimDictLoaded(dict) then
            local flag = 49
            if emoteData.AnimationOptions then
                if emoteData.AnimationOptions.EmoteLoop then flag = 1 end
                if emoteData.AnimationOptions.EmoteMoving then flag = 51 end
            end
            TaskPlayAnim(ped, dict, emoteData[2], 8.0, -8.0, -1, flag, 0, false, false, false)
        end
    end
    AttachProp(ped, emoteData, ped == previewPed)
end

-- Callback pour JOUER (Gère le Nearest Player pour les partagées)
RegisterNUICallback('playEmote', function(data, cb)
    local emoteData, category = GetEmoteData(data.id)
    if emoteData then
        if category == "Shared" then
            local closestPlayer, closestDistance = GetClosestPlayer()
            if closestPlayer ~= -1 and closestDistance < 3.0 then
                TriggerServerEvent('kzb_emotes:requestShared', GetPlayerServerId(closestPlayer), data.id)
                -- Petit message pour te dire que c'est envoyé
                BeginTextCommandThefeedPost("STRING")
                AddTextComponentSubstringPlayerName("Demande d'animation envoyée.")
                EndTextCommandThefeedPostTicker(false, false)
            else
                BeginTextCommandThefeedPost("STRING")
                AddTextComponentSubstringPlayerName("~r~Aucun joueur à proximité.")
                EndTextCommandThefeedPostTicker(false, false)
            end
        else
            PerformEmote(PlayerPedId(), emoteData, category)
        end

        menuOpen = false
        SetNuiFocus(false, false)
        SendNUIMessage({ action = "close" })
        CleanupPreview()
        if menuCam then RenderScriptCams(false, true, 500, true, true); DestroyCam(menuCam, false); menuCam = nil end
    end
    cb('ok')
end)

RegisterNUICallback('previewEmote', function(data, cb)
    local emoteData, category = GetEmoteData(data.id)
    if emoteData and previewPed then PerformEmote(previewPed, emoteData, category) end
    cb('ok')
end)

-- NOUVEAU BOUTON : Réinitialise uniquement le clone
RegisterNUICallback('resetPreview', function(data, cb)
    if previewPed then
        ClearPedTasks(previewPed)
        DeleteCurrentProp(true)
        ResetPedMovementClipset(previewPed, 0.0)
        ClearFacialIdleAnimOverride(previewPed)
    end
    cb('ok')
end)

function DeleteCurrentProp(isPreview)
    if isPreview then
        if previewProp and DoesEntityExist(previewProp) then DeleteEntity(previewProp); previewProp = nil end
    else
        if currentProp and DoesEntityExist(currentProp) then DeleteEntity(currentProp); currentProp = nil end
    end
end

function AttachProp(ped, emoteData, isPreview)
    local options = emoteData.AnimationOptions
    if not options or not options.Prop then return end
    local hash = GetHashKey(options.Prop)
    RequestModel(hash)
    while not HasModelLoaded(hash) do Wait(10) end
    local prop = CreateObject(hash, 0.0, 0.0, 0.0, true, true, false)
    local boneIndex = GetPedBoneIndex(ped, options.PropBone or 28422)
    local plac = options.PropPlacement or {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
    AttachEntityToEntity(prop, ped, boneIndex, plac[1], plac[2], plac[3], plac[4], plac[5], plac[6], true, true, false, true, 1, true)
    if isPreview then previewProp = prop else currentProp = prop end
end

RegisterNUICallback('closeMenu', function(data, cb)
    menuOpen = false; SetNuiFocus(false, false); SendNUIMessage({ action = "close" }); CleanupPreview()
    if menuCam then RenderScriptCams(false, true, 500, true, true); DestroyCam(menuCam, false); menuCam = nil end
    cb('ok')
end)

RegisterNUICallback('cancelEmote', function(data, cb)
    local playerPed = PlayerPedId()
    ClearPedTasks(playerPed); DeleteCurrentProp(false); ResetPedMovementClipset(playerPed, 0.0); ClearFacialIdleAnimOverride(playerPed)
    cb('ok')
end)

-- ==========================================
-- SYSTÈME D'ANIMATIONS PARTAGÉES (RÉCEPTION & SYNC)
-- ==========================================
RegisterNetEvent('kzb_emotes:receiveRequest')
AddEventHandler('kzb_emotes:receiveRequest', function(requesterId, emoteId)
    local emoteData, _ = GetEmoteData(emoteId)
    local emoteLabel = emoteData and (emoteData[3] or "Animation") or "Animation"
    pendingRequest = { requester = requesterId, emote = emoteId, label = emoteLabel }

    Citizen.CreateThread(function()
        local timer = 1000 -- Laisse ~10 secondes au joueur pour accepter
        while pendingRequest and timer > 0 do
            Citizen.Wait(10)
            timer = timer - 1
            BeginTextCommandDisplayHelp("STRING")
            AddTextComponentSubstringPlayerName("~INPUT_REPLAY_TOGGLE_TIMELINE~ (Y) Accepter : ~b~" .. pendingRequest.label .. "~s~\n~INPUT_REPLAY_NEW_MARKER~ (N) Refuser")
            EndTextCommandDisplayHelp(0, false, true, -1)

            if IsControlJustPressed(0, 246) then -- Touche Y
                TriggerServerEvent('kzb_emotes:acceptShared', pendingRequest.requester, pendingRequest.emote)
                pendingRequest = nil
                ClearAllHelpMessages()
            elseif IsControlJustPressed(0, 245) then -- Touche N
                pendingRequest = nil
                ClearAllHelpMessages()
            end
        end
        if timer <= 0 then pendingRequest = nil; ClearAllHelpMessages() end
    end)
end)

RegisterNetEvent('kzb_emotes:syncShared')
AddEventHandler('kzb_emotes:syncShared', function(emoteId, isTarget, otherPlayerServerId)
    local emoteData, _ = GetEmoteData(emoteId)
    if not emoteData then return end

    local playerPed = PlayerPedId()
    local otherPlayer = GetPlayerFromServerId(otherPlayerServerId)
    local otherPed = GetPlayerPed(otherPlayer)

    if isTarget then
        -- Le joueur qui a accepté (la cible)
        local targetEmoteData = emoteData
        if emoteData.AnimationOptions and emoteData.AnimationOptions.TargetEmote then
            local tData, _ = GetEmoteData(emoteData.AnimationOptions.TargetEmote)
            if tData then targetEmoteData = tData end
        end

        local syncOffsetFront = emoteData.AnimationOptions and emoteData.AnimationOptions.SyncOffsetFront or 1.0
        local syncOffsetSide = emoteData.AnimationOptions and emoteData.AnimationOptions.SyncOffsetSide or 0.0
        local syncOffsetHeight = emoteData.AnimationOptions and emoteData.AnimationOptions.SyncOffsetHeight or 0.0
        local syncHeading = emoteData.AnimationOptions and emoteData.AnimationOptions.SyncOffsetHeading or 180.0

        -- Accroche brièvement la cible au lanceur pour aligner les corps parfaitement
        AttachEntityToEntity(playerPed, otherPed, 0, syncOffsetSide, syncOffsetFront, syncOffsetHeight, 0.0, 0.0, syncHeading, false, false, false, false, 1, true)
        Wait(150)
        DetachEntity(playerPed, true, false)

        PerformEmote(playerPed, targetEmoteData, "Emotes")
    else
        -- Le lanceur de l'animation
        PerformEmote(playerPed, emoteData, "Emotes")
    end
end)

-- (Le raycast pour placer les emotes reste ici en dessous comme d'habitude)
function RaycastCamera(distance)
    local camRot = GetGameplayCamRot(2)
    local camPos = GetGameplayCamCoord()
    local rx, ry, rz = math.rad(camRot.x), math.rad(camRot.y), math.rad(camRot.z)
    local dirX = -math.sin(rz) * math.abs(math.cos(rx))
    local dirY = math.cos(rz) * math.abs(math.cos(rx))
    local dirZ = math.sin(rx)
    local dest = vector3(camPos.x + dirX * distance, camPos.y + dirY * distance, camPos.z + dirZ * distance)
    local rayHandle = StartShapeTestRay(camPos.x, camPos.y, camPos.z, dest.x, dest.y, dest.z, -1, PlayerPedId(), 0)
    local _, hit, endCoords, _, _ = GetShapeTestResult(rayHandle)
    return hit, endCoords
end

RegisterNUICallback('placeEmote', function(data, cb)
    local emoteData, category = GetEmoteData(data.id)
    if not emoteData then return cb('ok') end
    local playerPed = PlayerPedId()
    menuOpen = false; SetNuiFocus(false, false); SendNUIMessage({ action = "close" }); CleanupPreview()
    if menuCam then RenderScriptCams(false, true, 500, true, true); DestroyCam(menuCam, false); menuCam = nil end
    isPlacing = true

    Citizen.CreateThread(function()
        local ghostClone = ClonePed(playerPed, GetEntityHeading(playerPed), false, false)
        SetEntityAlpha(ghostClone, 150, false)
        SetEntityCollision(ghostClone, false, false)
        SetBlockingOfNonTemporaryEvents(ghostClone, true)
        PerformEmote(ghostClone, emoteData, category)

        local targetCoords = nil
        local targetHeading = 0.0

        BeginTextCommandDisplayHelp("STRING")
        AddTextComponentSubstringPlayerName("~INPUT_ATTACK~ Confirmer l'emplacement\n~INPUT_AIM~ Annuler\nTournez la caméra pour orienter le personnage.")
        EndTextCommandDisplayHelp(0, false, true, -1)

        while isPlacing do
            Citizen.Wait(0)
            local hit, coords = RaycastCamera(15.0)
            if hit == 1 then
                local camHeading = GetGameplayCamRot(2).z
                SetEntityCoordsNoOffset(ghostClone, coords.x, coords.y, coords.z + 1.0, false, false, false)
                SetEntityHeading(ghostClone, camHeading)
                if IsControlJustPressed(0, 24) then 
                    targetCoords = vector3(coords.x, coords.y, coords.z + 1.0)
                    targetHeading = camHeading
                    isPlacing = false
                end
            end
            if IsControlJustPressed(0, 25) then isPlacing = false end
        end

        DeleteEntity(ghostClone); DeleteCurrentProp(true); ClearAllHelpMessages()

        if targetCoords then
            TaskGoStraightToCoord(playerPed, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, targetHeading, 0.1)
            local timer = 0
            while #(GetEntityCoords(playerPed) - targetCoords) > 0.5 and timer < 100 do
                Citizen.Wait(100); timer = timer + 1
                if IsControlJustPressed(0, 73) then ClearPedTasks(playerPed); return end
            end
            SetEntityCoordsNoOffset(playerPed, targetCoords.x, targetCoords.y, targetCoords.z, false, false, false)
            SetEntityHeading(playerPed, targetHeading)
            PerformEmote(playerPed, emoteData, category)
        end
    end)
    cb('ok')
end)