-- ============================================================
--  BLOODADMIN — CLIENT/MODULES/ACTIONS.LUA
-- ============================================================

local vehGodmodeActive = false

-- Helper function to safely initialize mod kit for both basic and custom/import vehicles
local function InitializeVehicleModKit(vehicle)
    if not DoesEntityExist(vehicle) then return end
    
    -- If it already has mods enabled, we don't need to overwrite or loop anything
    if GetNumVehicleMods(vehicle, 11) > 0 then return end
    
    -- Scan through mod kits from 0 to 49 to find the one that enables mods
    for i = 0, 49 do
        SetVehicleModKit(vehicle, i)
        if GetNumVehicleMods(vehicle, 11) > 0 then
            break
        end
    end
end

RegisterNUICallback('close', function(_, cb)
    toggleMenu(true)
    cb('ok')
end)

RegisterNUICallback('closeReport', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('kick', function(data, cb)
    TriggerServerEvent('bl_admin:kickPlayer', data.id, data.reason)
    cb('ok')
end)

RegisterNUICallback('ban', function(data, cb)
    TriggerServerEvent('bl_admin:banPlayer', data.id, data.reason, data.durationSeconds or data.duration)
    cb('ok')
end)

RegisterNUICallback('banPlayer', function(data, cb)
    TriggerServerEvent('bl_admin:banPlayer', data.id, data.reason, data.durationSeconds or data.duration)
    cb('ok')
end)

RegisterNUICallback('unbanPlayer', function(id, cb)
    TriggerServerEvent('bl_admin:unbanPlayer', id)
    cb('ok')
end)

RegisterNUICallback('teleport', function(data, cb)
    TriggerServerEvent('bl_admin:requestTeleport', data.id)
    cb('ok')
end)

RegisterNUICallback('revive', function(data, cb)
    TriggerServerEvent('bl_admin:revivePlayer', data.id)
    cb('ok')
end)

RegisterNUICallback('heal', function(data, cb)
    TriggerServerEvent('bl_admin:healPlayer', data.id)
    cb('ok')
end)

RegisterNUICallback('setJob', function(data, cb)
    TriggerServerEvent('bl_admin:setJob', data.id, data.job, data.grade)
    cb('ok')
end)

RegisterNUICallback('giveMoney', function(data, cb)
    TriggerServerEvent('bl_admin:giveMoney', data.id, data.account, data.amount)
    cb('ok')
end)

RegisterNUICallback('giveItem', function(data, cb)
    TriggerServerEvent('bl_admin:giveItem', data.id, data.item, data.count)
    cb('ok')
end)

RegisterNUICallback('spawnVehicle', function(data, cb)
    TriggerServerEvent('bl_admin:requestSpawnVehicle', data)
    cb('ok')
end)

RegisterNUICallback('saveCurrentVehicleToCatalog', function(data, cb)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then
        TriggerEvent('bl_admin:notify', 'error', 'Vous n\'êtes pas dans un véhicule')
        cb('error')
        return
    end

    if ESX and ESX.Game then
        local props = ESX.Game.GetVehicleProperties(vehicle)
        if props then
            data.model = props.model
            data.props = props
            TriggerServerEvent('bl_admin:addVehicleToCatalog', data)
        end
    end
    cb('ok')
end)

local LastAdminVehicle = nil

RegisterNetEvent('bl_admin:doSpawnVehicle')
AddEventHandler('bl_admin:doSpawnVehicle', function(model, propsText)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    if type(model) == 'string' and tonumber(model) then
        model = tonumber(model)
    end
    
    -- Supprime l'ancien véhicule de façon ultra-sécurisée s'il existe
    if LastAdminVehicle and DoesEntityExist(LastAdminVehicle) then
        -- Éjecter proprement le joueur s'il est dedans
        if GetVehiclePedIsIn(ped, false) == LastAdminVehicle then
            ClearPedTasksImmediately(ped)
        end
        
        -- Demander le contrôle réseau de l'entité pour forcer la suppression
        local timeout = 2000
        while DoesEntityExist(LastAdminVehicle) and not NetworkHasControlOfEntity(LastAdminVehicle) and timeout > 0 do
            NetworkRequestControlOfEntity(LastAdminVehicle)
            Citizen.Wait(50)
            timeout = timeout - 50
        end
        
        if DoesEntityExist(LastAdminVehicle) then
            SetEntityAsMissionEntity(LastAdminVehicle, true, true)
            DeleteVehicle(LastAdminVehicle)
            DeleteEntity(LastAdminVehicle)
        end
        LastAdminVehicle = nil
    end

    ESX.Game.SpawnVehicle(model, coords, GetEntityHeading(ped), function(vehicle)
        LastAdminVehicle = vehicle
        TaskWarpPedIntoVehicle(ped, vehicle, -1)
        
        if propsText then
            local props = type(propsText) == 'string' and json.decode(propsText) or propsText
            if props then
                ESX.Game.SetVehicleProperties(vehicle, props)
            end
        end
    end)
end)

RegisterNetEvent('bl_admin:doDeleteVehicle')
AddEventHandler('bl_admin:doDeleteVehicle', function(radius)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle ~= 0 then
        ESX.Game.DeleteVehicle(vehicle)
        TriggerEvent('bl_admin:notify', 'success', 'Véhicule supprimé')
    else
        TriggerEvent('bl_admin:notify', 'error', 'Vous n\'êtes pas dans un véhicule')
    end
end)

-- Management of permissions and grades
RegisterNUICallback('updatePermissions', function(data, cb)
    TriggerServerEvent('bl_admin:updatePermissions', data)
    cb('ok')
end)

RegisterNUICallback('savePermissionsSecure', function(data, cb)
    TriggerServerEvent('bl_admin:savePermissionsSecure', data)
    cb('ok')
end)

RegisterNUICallback('addGrade', function(data, cb)
    TriggerServerEvent('bl_admin:addGrade', data)
    cb('ok')
end)

RegisterNUICallback('deleteGrade', function(data, cb)
    TriggerServerEvent('bl_admin:deleteGrade', data)
    cb('ok')
end)

RegisterNetEvent('bl_admin:toggleNoclip')
AddEventHandler('bl_admin:toggleNoclip', function(active)
    toggleNoclip(active)
end)

RegisterNetEvent('bl_admin:toggleGodmode')
AddEventHandler('bl_admin:toggleGodmode', function(active)
    godmodeActive = active
    SetPlayerInvincible(PlayerId(), active)
    if active then
        SetEntityHealth(PlayerPedId(), 200)
    end
end)

RegisterNetEvent('bl_admin:toggleVanish')
AddEventHandler('bl_admin:toggleVanish', function(active)
    invisibleActive = active
end)

Citizen.CreateThread(function()
    local wasInvisible = false
    local lastVeh = 0
    while true do
        local sleep = 500
        if invisibleActive then
            sleep = 0
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)
            
            -- Keep the ped locally visible
            SetEntityLocallyVisible(ped)
            
            -- If in vehicle, keep vehicle locally visible too
            if veh ~= 0 then
                SetEntityLocallyVisible(veh)
                
                -- Handle transition to a new vehicle
                if veh ~= lastVeh then
                    if lastVeh ~= 0 and DoesEntityExist(lastVeh) then
                        SetEntityVisible(lastVeh, true, false)
                        ResetEntityAlpha(lastVeh)
                    end
                    SetEntityVisible(veh, false, false)
                    SetEntityAlpha(veh, 50, false)
                    lastVeh = veh
                end
            else
                -- If we left the vehicle
                if lastVeh ~= 0 and DoesEntityExist(lastVeh) then
                    SetEntityVisible(lastVeh, true, false)
                    ResetEntityAlpha(lastVeh)
                    lastVeh = 0
                end
            end
            
            -- Handle transition into invisibility
            if not wasInvisible then
                SetEntityVisible(ped, false, false)
                SetEntityAlpha(ped, 50, false)
                wasInvisible = true
            end
        else
            -- Handle transition out of invisibility
            if wasInvisible then
                local ped = PlayerPedId()
                SetEntityVisible(ped, true, false)
                ResetEntityAlpha(ped)
                
                if lastVeh ~= 0 and DoesEntityExist(lastVeh) then
                    SetEntityVisible(lastVeh, true, false)
                    ResetEntityAlpha(lastVeh)
                    lastVeh = 0
                end
                wasInvisible = false
            end
        end
        Citizen.Wait(sleep)
    end
end)

local delgunActive = false
RegisterNetEvent('bl_admin:toggleDelgun')
AddEventHandler('bl_admin:toggleDelgun', function(active)
    if active == delgunActive then return end -- Ne fait rien si l'état est déjà le même
    delgunActive = active
    local ped = PlayerPedId()
    local hash = GetHashKey("WEAPON_PISTOL")
    if delgunActive then
        GiveWeaponToPed(ped, hash, 999, false, true)
        SetCurrentPedWeapon(ped, hash, true)
        TriggerEvent('bl_admin:notify', 'success', 'Delete Gun Activé (Tirez pour supprimer)')
    else
        RemoveWeaponFromPed(ped, hash)
        TriggerEvent('bl_admin:notify', 'info', 'Delete Gun Désactivé')
    end
end)

RegisterNetEvent('bl_admin:disableAllTools')
AddEventHandler('bl_admin:disableAllTools', function()
    -- Noclip
    if noclipActive then
        toggleNoclip(false)
    end
    
    -- Godmode
    godmodeActive = false
    SetPlayerInvincible(PlayerId(), false)
    vehGodmodeActive = false
    
    -- Vanish
    invisibleActive = false
    SetEntityVisible(PlayerPedId(), true, false)
    ResetEntityAlpha(PlayerPedId())
    
    -- Delgun
    delgunActive = false
    local ped = PlayerPedId()
    local hash = GetHashKey("WEAPON_PISTOL")
    RemoveWeaponFromPed(ped, hash)

    -- Spectate
    if NetworkIsInSpectatorMode() then
        NetworkSetInSpectatorMode(false, PlayerPedId())
    end

    -- ESP (if defined elsewhere, we should trigger its toggle)
    TriggerEvent('bl_admin:toggleESP', false)

    -- Notify NUI to reset button states
    SendNUIMessage({ action = 'resetTools' })
    
    TriggerEvent('bl_admin:notify', 'info', 'Tous les outils administratifs ont été désactivés.')
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 500
        if delgunActive then
            sleep = 0
            local ped = PlayerPedId()
            local isAiming, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
            
            if IsPedShooting(ped) or (isAiming and IsControlJustPressed(0, 38)) then -- 38 is E
                if not DoesEntityExist(entity) then
                    local found, target = GetClosestEntityInFrontOfPlayer()
                    if found then entity = target end
                end

                if DoesEntityExist(entity) then
                    SetEntityAsMissionEntity(entity, true, true)
                    DeleteEntity(entity)
                    if IsEntityAPed(entity) then DeletePed(entity) end
                    TriggerEvent('bl_admin:notify', 'success', 'Entité supprimée')
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

function GetClosestEntityInFrontOfPlayer()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local forward = GetEntityForwardVector(ped)
    local target = coords + (forward * 50.0)
    
    local ray = StartShapeTestRay(coords.x, coords.y, coords.z, target.x, target.y, target.z, -1, ped, 0)
    local _, hit, _, _, entity = GetShapeTestResult(ray)
    return hit, entity
end

RegisterNUICallback('noclip', function(data, cb)
    TriggerEvent('bl_admin:toggleNoclip', data.active)
    cb('ok')
end)

RegisterNUICallback('godmode', function(data, cb)
    TriggerEvent('bl_admin:toggleGodmode', data.active)
    cb('ok')
end)

RegisterNUICallback('vanish', function(data, cb)
    TriggerEvent('bl_admin:toggleVanish', data.active)
    cb('ok')
end)

RegisterNUICallback('delgun', function(data, cb)
    TriggerEvent('bl_admin:toggleDelgun', data.active)
    cb('ok')
end)

RegisterNUICallback('esp', function(data, cb)
    TriggerEvent('bl_admin:toggleESP', data.active)
    cb('ok')
end)

RegisterNUICallback('blackout', function(data, cb)
    TriggerServerEvent('bl_admin:toggleBlackout', data.active)
    cb('ok')
end)

RegisterNUICallback('armor', function(data, cb)
    TriggerServerEvent('bl_admin:setArmor', data.id)
    cb('ok')
end)

RegisterNetEvent('bl_admin:receiveArmor')
AddEventHandler('bl_admin:receiveArmor', function()
    SetPedArmour(PlayerPedId(), 100)
end)

local espActive = false
RegisterNetEvent('bl_admin:toggleESP')
AddEventHandler('bl_admin:toggleESP', function(active)
    if active == espActive then return end
    espActive = active
    if espActive then
        TriggerEvent('bl_admin:notify', 'success', 'ESP Activé')
    else
        TriggerEvent('bl_admin:notify', 'info', 'ESP Désactivé')
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        if espActive then
            sleep = 0
            local myCoords = GetEntityCoords(PlayerPedId())
            for _, player in ipairs(GetActivePlayers()) do
                local targetPed = GetPlayerPed(player)
                local targetCoords = GetEntityCoords(targetPed)
                local dist = #(myCoords - targetCoords)
                if dist < 150.0 then
                    local sId = GetPlayerServerId(player)
                    local r, g, b = 255, 255, 255
                    local text = ("[%d] %s"):format(sId, GetPlayerName(player))
                    
                    if staffList[sId] then
                        text = "★ " .. text
                        r, g, b = 239, 68, 68 -- Rouge moderne
                    end

                    local health = GetEntityHealth(targetPed) - 100
                    if health < 0 then health = 0 end
                    
                    DrawESP(targetCoords.x, targetCoords.y, targetCoords.z + 1.1, text, r, g, b, health)
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

function DrawESP(x, y, z, text, r, g, b, health)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        -- Texte
        SetTextScale(0.32, 0.32)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextOutline()
        SetTextCentre(1)
        BeginTextCommandDisplayText("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)

        -- Barre de vie (Background)
        local barWidth = 0.04
        local barHeight = 0.006
        DrawRect(_x, _y + 0.025, barWidth, barHeight, 0, 0, 0, 150)
        
        -- Barre de vie (Active)
        local healthWidth = (health / 100) * barWidth
        local hr, hg, hb = 34, 197, 94 -- Vert
        if health < 50 then hr, hg, hb = 234, 179, 8 end -- Jaune
        if health < 25 then hr, hg, hb = 239, 68, 68 end -- Rouge
        
        DrawRect(_x - (barWidth/2) + (healthWidth/2), _y + 0.025, healthWidth, barHeight, hr, hg, hb, 200)
    end
end

RegisterNUICallback('globalAction', function(data, cb)
    TriggerServerEvent('bl_admin:globalAction', data.action)
    cb('ok')
end)

RegisterNUICallback('setWeather', function(data, cb)
    TriggerServerEvent('bl_admin:setWeather', data)
    cb('ok')
end)

RegisterNUICallback('setTime', function(data, cb)
    TriggerServerEvent('bl_admin:setTime', data)
    cb('ok')
end)

RegisterNUICallback('serverAnnounce', function(msg, cb)
    TriggerServerEvent('bl_admin:serverAnnounce', msg)
    cb('ok')
end)

RegisterNUICallback('updateGradeSettings', function(data, cb)
    TriggerServerEvent('bl_admin:updateGradeSettings', data)
    cb('ok')
end)

RegisterNetEvent('bl_admin:tpToWaypoint')
AddEventHandler('bl_admin:tpToWaypoint', function()
    local waypoint = GetFirstBlipInfoId(8)
    if DoesBlipExist(waypoint) then
        local coords = GetBlipInfoIdCoord(waypoint)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        local entity = vehicle ~= 0 and vehicle or ped
        
        local x, y = coords.x, coords.y
        local groundZ = 0.0
        local groundFound = false
        
        TriggerEvent('bl_admin:notify', 'info', 'Recherche du sol...')
        FreezeEntityPosition(entity, true)
        
        for tempZ = 950.0, 0.0, -50.0 do
            SetEntityCoords(entity, x, y, tempZ, false, false, false, true)
            RequestCollisionAtCoord(x, y, tempZ)
            Citizen.Wait(50)
            
            local found, z = GetGroundZFor_3dCoord(x, y, tempZ, false)
            if found then
                groundZ = z + 1.0
                groundFound = true
                break
            end
        end
        
        if not groundFound then
            SetEntityCoords(entity, x, y, 100.0, false, false, false, true)
            RequestCollisionAtCoord(x, y, 100.0)
            Citizen.Wait(300)
            local found, z = GetGroundZFor_3dCoord(x, y, 100.0, false)
            if found then
                groundZ = z + 1.0
                groundFound = true
            else
                groundZ = 500.0
                TriggerEvent('bl_admin:notify', 'warning', 'Sol introuvable, téléportation à 500m.')
            end
        end
        
        SetEntityCoords(entity, x, y, groundZ, false, false, false, true)
        FreezeEntityPosition(entity, false)
        
        SendNUIMessage({ action = 'toast', type = 'success', message = 'Téléportation au marqueur effectuée' })
    else
        TriggerEvent('bl_admin:notify', 'error', 'Aucun marqueur sur la carte')
    end
end)

RegisterNUICallback('tpmarker', function(_, cb)
    TriggerEvent('bl_admin:tpToWaypoint')
    cb('ok')
end)

local blipsActive = false
local playerBlips = {}

RegisterNUICallback('blips', function(data, cb)
    blipsActive = data.active
    if not blipsActive then
        for _, blip in pairs(playerBlips) do
            if DoesBlipExist(blip) then RemoveBlip(blip) end
        end
        playerBlips = {}
        TriggerEvent('bl_admin:notify', 'info', 'Blips désactivés')
    else
        TriggerEvent('bl_admin:notify', 'success', 'Blips activés')
    end
    cb('ok')
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 2000
        if blipsActive then
            sleep = 1000
            local activePlayers = GetActivePlayers()
            for _, player in ipairs(activePlayers) do
                local ped = GetPlayerPed(player)
                local serverId = GetPlayerServerId(player)
                
                if ped ~= PlayerPedId() then
                    if not playerBlips[serverId] or not DoesBlipExist(playerBlips[serverId]) then
                        local blip = AddBlipForEntity(ped)
                        SetBlipSprite(blip, 1)
                        SetBlipScale(blip, 0.8)
                        SetBlipCategory(blip, 7)
                        SetBlipAsShortRange(blip, false)
                        
                        local name = GetPlayerName(player)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString(("[%d] %s"):format(serverId, name))
                        EndTextCommandSetBlipName(blip)
                        
                        playerBlips[serverId] = blip
                    else
                        -- Optional: Update color based on job or distance
                        SetBlipRotation(playerBlips[serverId], math.ceil(GetEntityHeading(ped)))
                    end
                end
            end

            -- Clean up blips for players who left
            for sId, blip in pairs(playerBlips) do
                local found = false
                for _, player in ipairs(activePlayers) do
                    if GetPlayerServerId(player) == sId then
                        found = true
                        break
                    end
                end
                if not found then
                    if DoesBlipExist(blip) then RemoveBlip(blip) end
                    playerBlips[sId] = nil
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNUICallback('fixWorld', function(_, cb)
    TriggerServerEvent('bl_admin:globalAction', 'fixworld')
    cb('ok')
end)

RegisterNUICallback('wipeProps', function(_, cb)
    TriggerEvent('bl_admin:wipeProps')
    cb('ok')
end)

-- Staff management (recently added)
RegisterNUICallback('getAllStaff', function(_, cb)
    TriggerServerEvent('bl_admin:getAllStaff')
    cb('ok')
end)

RegisterNUICallback('setStaffGrade', function(data, cb)
    TriggerServerEvent('bl_admin:setStaffGrade', data)
    cb('ok')
end)

RegisterNUICallback('addStaff', function(data, cb)
    TriggerServerEvent('bl_admin:addStaff', data)
    cb('ok')
end)

RegisterNUICallback('vehicleAction', function(data, cb)
    TriggerServerEvent('bl_admin:requestVehicleAction', data)
    cb('ok')
end)

RegisterNetEvent('bl_admin:doVehicleAction')
AddEventHandler('bl_admin:doVehicleAction', function(data)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then
        vehicle = GetClosestVehicle(GetEntityCoords(ped), 5.0, 0, 70)
    end

    if vehicle ~= 0 or data.action == 'wipe' then
        if data.action == 'repair' then
            SetVehicleFixed(vehicle)
            SetVehicleDeformationFixed(vehicle)
            SetVehicleUndriveable(vehicle, false)
            SetVehicleEngineOn(vehicle, true, true)
            TriggerEvent('bl_admin:notify', 'success', 'Véhicule réparé')
        elseif data.action == 'clean' then
            SetVehicleDirtLevel(vehicle, 0)
            SetVehicleEnveffScale(vehicle, 0.0)
            TriggerEvent('bl_admin:notify', 'success', 'Véhicule nettoyé')
        elseif data.action == 'flip' then
            local coords = GetEntityCoords(vehicle)
            SetEntityCoords(vehicle, coords.x, coords.y, coords.z + 0.5)
            SetEntityRotation(vehicle, 0.0, 0.0, GetEntityHeading(vehicle))
            TriggerEvent('bl_admin:notify', 'info', 'Véhicule retourné')
        elseif data.action == 'fuel' then
            SetVehicleFuelLevel(vehicle, 100.0)
            TriggerEvent('fuel:setFuel', vehicle, 100.0)
            TriggerEvent('bl_admin:notify', 'success', 'Plein effectué')
        elseif data.action == 'lock' then
            local status = GetVehicleDoorLockStatus(vehicle)
            if status == 1 then
                SetVehicleDoorsLocked(vehicle, 2)
                TriggerEvent('bl_admin:notify', 'warning', 'Véhicule verrouillé')
            else
                SetVehicleDoorsLocked(vehicle, 1)
                TriggerEvent('bl_admin:notify', 'success', 'Véhicule déverrouillé')
            end
        elseif data.action == 'plate' then
            SetVehicleNumberPlateText(vehicle, data.text or "BLOOD")
            TriggerEvent('bl_admin:notify', 'success', 'Plaque mise à jour')
        elseif data.action == 'max' then
            InitializeVehicleModKit(vehicle)
            -- Performances maximums
            SetVehicleMod(vehicle, 11, GetNumVehicleMods(vehicle, 11) - 1, false) -- Moteur
            SetVehicleMod(vehicle, 12, GetNumVehicleMods(vehicle, 12) - 1, false) -- Freins
            SetVehicleMod(vehicle, 13, GetNumVehicleMods(vehicle, 13) - 1, false) -- Transmission
            SetVehicleMod(vehicle, 15, GetNumVehicleMods(vehicle, 15) - 1, false) -- Suspension
            SetVehicleMod(vehicle, 16, GetNumVehicleMods(vehicle, 16) - 1, false) -- Blindage
            ToggleVehicleMod(vehicle, 18, true) -- Turbo
            
            -- Améliorations visuelles premium
            ToggleVehicleMod(vehicle, 22, true) -- Phares Xénon
            SetVehicleWindowTint(vehicle, 1) -- Vitres teintées Limo (Ultra sombre)
            SetVehicleNumberPlateTextIndex(vehicle, 4) -- Plaque noire premium
            
            -- Pneus customs (White decals)
            SetVehicleMod(vehicle, 23, GetVehicleMod(vehicle, 23), true)
            SetVehicleMod(vehicle, 24, GetVehicleMod(vehicle, 24), true)
            
            -- Néons complets avec couleur rouge BloodLeak
            for i = 0, 3 do
                SetVehicleNeonLightEnabled(vehicle, i, true)
            end
            SetVehicleNeonLightsColour(vehicle, 220, 38, 38)
            
            TriggerEvent('bl_admin:notify', 'success', 'Véhicule entièrement amélioré (Perf & Esthétique Max)')
        elseif data.action == 'color' then
            SetVehicleCustomPrimaryColour(vehicle, data.r, data.g, data.b)
            TriggerEvent('bl_admin:notify', 'success', 'Couleur mise à jour')
        elseif data.action == 'godmode' then
            vehGodmodeActive = not vehGodmodeActive
            if vehGodmodeActive then
                SetVehicleFixed(vehicle)
                SetVehicleDeformationFixed(vehicle)
                SetVehicleUndriveable(vehicle, false)
                SetVehicleEngineOn(vehicle, true, true)
                
                SetEntityInvincible(vehicle, true)
                SetVehicleStrong(vehicle, true)
                SetVehicleCanBreak(vehicle, false)
                SetVehicleExplodesOnHighExplosionDamage(vehicle, false)
                SetVehicleTyresCanBurst(vehicle, false)
                SetVehicleWheelsCanBreak(vehicle, false)
                SetVehicleEngineCanDegrade(vehicle, false)
                
                SetVehicleBodyHealth(vehicle, 1000.0)
                SetVehicleEngineHealth(vehicle, 1000.0)
                SetVehiclePetrolTankHealth(vehicle, 1000.0)
                
                TriggerEvent('bl_admin:notify', 'success', 'Godmode Véhicule Activé')
            else
                SetEntityInvincible(vehicle, false)
                SetVehicleStrong(vehicle, false)
                SetVehicleCanBreak(vehicle, true)
                SetVehicleExplodesOnHighExplosionDamage(vehicle, true)
                SetVehicleTyresCanBurst(vehicle, true)
                SetVehicleWheelsCanBreak(vehicle, true)
                SetVehicleEngineCanDegrade(vehicle, true)
                
                TriggerEvent('bl_admin:notify', 'info', 'Godmode Véhicule Désactivé')
            end
        elseif data.action == 'boost' then
            SetVehicleEnginePowerMultiplier(vehicle, 50.0)
            SetVehicleEngineTorqueMultiplier(vehicle, 50.0)
            TriggerEvent('bl_admin:notify', 'success', 'MEGA BOOST Activé !')
        elseif data.action == 'engine' then
            local isRunning = GetIsVehicleEngineRunning(vehicle)
            SetVehicleEngineOn(vehicle, not isRunning, true, true)
            TriggerEvent('bl_admin:notify', 'success', not isRunning and 'Moteur Allumé' or 'Moteur Coupé')
        elseif data.action == 'eject' then
            for i = -1, GetVehicleMaxNumberOfPassengers(vehicle) do
                local occupant = GetPedInVehicleSeat(vehicle, i)
                if occupant ~= 0 then
                    ClearPedTasksImmediately(occupant)
                end
            end
            TriggerEvent('bl_admin:notify', 'success', 'Occupants éjectés')
        elseif data.action == 'wipe' then
            local coords = GetEntityCoords(ped)
            local vehicles = GetGamePool('CVehicle')
            local count = 0
            for _, veh in ipairs(vehicles) do
                local vCoords = GetEntityCoords(veh)
                if #(coords - vCoords) < 50.0 then
                    if GetVehicleNumberOfPassengers(veh) == 0 and IsVehicleSeatFree(veh, -1) then
                        SetEntityAsMissionEntity(veh, true, true)
                        DeleteVehicle(veh)
                        count = count + 1
                    end
                end
            end
            TriggerEvent('bl_admin:notify', 'success', count .. ' véhicules supprimés')
        end
    else
        TriggerEvent('bl_admin:notify', 'error', 'Aucun véhicule à proximité')
    end
end)

RegisterNUICallback('sendMessage', function(data, cb)
    TriggerServerEvent('bl_admin:sendMessage', data.id, data.message)
    cb('ok')
end)

RegisterNUICallback('teleportToMe', function(data, cb)
    TriggerServerEvent('bl_admin:teleportToMe', data.id)
    cb('ok')
end)

RegisterNUICallback('freeze', function(data, cb)
    TriggerServerEvent('bl_admin:freezePlayer', data.id)
    cb('ok')
end)

RegisterNUICallback('clearInventory', function(data, cb)
    TriggerServerEvent('bl_admin:clearInventory', data.id)
    cb('ok')
end)

local spectateActive = false
RegisterNUICallback('spectate', function(data, cb)
    spectateActive = data.active
    local targetId = data.id
    TriggerServerEvent('bl_admin:logSpectate', targetId, spectateActive)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetId))
    
    if spectateActive then
        if DoesEntityExist(targetPed) then
            NetworkSetInSpectatorMode(true, targetPed)
            SendNUIMessage({ action = 'toast', type = 'info', message = 'Spectate actif' })
        else
            SendNUIMessage({ action = 'toast', type = 'error', message = 'Joueur trop loin pour le spectate' })
        end
    else
        NetworkSetInSpectatorMode(false, PlayerPedId())
        SendNUIMessage({ action = 'toast', type = 'info', message = 'Spectate désactivé' })
    end
    cb('ok')
end)

RegisterNUICallback('warn', function(data, cb)
    TriggerServerEvent('bl_admin:warn', data)
    cb('ok')
end)

RegisterNUICallback('reviveAll', function(_, cb)
    -- Disabled by user request
    SendNUIMessage({ action = 'toast', type = 'error', message = 'Action désactivée' })
    cb('ok')
end)

RegisterNUICallback('healAll', function(_, cb)
    TriggerServerEvent('bl_admin:globalAction', {action = 'healAll'})
    cb('ok')
end)

RegisterNUICallback('clearVehicles', function(_, cb)
    TriggerServerEvent('bl_admin:globalAction', {action = 'clearVeh'})
    cb('ok')
end)

RegisterNUICallback('kickAll', function(_, cb)
    TriggerServerEvent('bl_admin:globalAction', {action = 'kickAll'})
    cb('ok')
end)

RegisterNUICallback('deleteVehicle', function(data, cb)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then
        vehicle = GetClosestVehicle(GetEntityCoords(ped), 5.0, 0, 70)
    end
    if vehicle ~= 0 then
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)
        SendNUIMessage({ action = 'toast', type = 'success', message = 'Véhicule supprimé' })
    else
        SendNUIMessage({ action = 'toast', type = 'error', message = 'Aucun véhicule à proximité' })
    end
    cb('ok')
end)

RegisterNUICallback('serverAnnounce', function(msg, cb)
    TriggerServerEvent('bl_admin:serverAnnounce', msg)
    cb('ok')
end)

RegisterNUICallback('teleportCoords', function(data, cb)
    TriggerEvent('bl_admin:doTeleport', data.x, data.y, data.z)
    cb('ok')
end)

RegisterNUICallback('getLogs', function(data, cb)
    local category = data.category or data -- fallback if data is just the string
    TriggerServerEvent('bl_admin:getLogs', category)
    cb('ok')
end)

RegisterNUICallback('requestResources', function(_, cb)
    TriggerServerEvent('bl_admin:requestResources')
    cb('ok')
end)

RegisterNUICallback('requestPlayers', function(_, cb)
    TriggerServerEvent('bl_admin:requestPlayers')
    cb('ok')
end)

RegisterNUICallback('requestOfflinePlayers', function(_, cb)
    TriggerServerEvent('bl_admin:requestOfflinePlayers')
    cb('ok')
end)

RegisterNUICallback('banOfflinePlayer', function(data, cb)
    TriggerServerEvent('bl_admin:banOfflinePlayer', data)
    cb('ok')
end)

RegisterNUICallback('warnOfflinePlayer', function(data, cb)
    TriggerServerEvent('bl_admin:warnOfflinePlayer', data)
    cb('ok')
end)

RegisterNUICallback('resourceAction', function(data, cb)
    TriggerServerEvent('bl_admin:resourceAction', data.name, data.action)
    cb('ok')
end)

RegisterNUICallback('requestConfig', function(_, cb)
    TriggerServerEvent('bl_admin:requestConfig')
    cb('ok')
end)

RegisterNUICallback('requestPlayers', function(_, cb)
    TriggerServerEvent('bl_admin:requestPlayers')
    cb('ok')
end)

RegisterNUICallback('toggleService', function(data, cb)
    TriggerServerEvent('bl_admin:toggleService', data)
    cb('ok')
end)

RegisterNUICallback('addStaff', function(data, cb)
    TriggerServerEvent('bl_admin:addStaff', data)
    cb('ok')
end)

RegisterNUICallback('setStaffGrade', function(data, cb)
    TriggerServerEvent('bl_admin:setStaffGrade', data)
    cb('ok')
end)

RegisterNUICallback('sendStaffMessage', function(data, cb)
    TriggerServerEvent('bl_admin:sendStaffMessage', data)
    cb('ok')
end)

RegisterNUICallback('getStaffChat', function(_, cb)
    TriggerServerEvent('bl_admin:getStaffChat')
    cb('ok')
end)

RegisterNUICallback('requestReports', function(_, cb)
    TriggerServerEvent('bl_admin:requestReports')
    cb('ok')
end)

RegisterNUICallback('reportAction', function(data, cb)
    TriggerServerEvent('bl_admin:reportAction', data)
    cb('ok')
end)

RegisterNUICallback('submitReport', function(data, cb)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    data.coords = { x = coords.x, y = coords.y, z = coords.z }
    TriggerServerEvent('bl_admin:submitReport', data)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('getReportsLeaderboard', function(_, cb)
    TriggerServerEvent('bl_admin:getReportsLeaderboard')
    cb('ok')
end)

RegisterNUICallback('tpPlayerToZone', function(data, cb)
    TriggerServerEvent('bl_admin:tpPlayerToZone', data)
    cb('ok')
end)

-- ── SANCTIONS CALLBACKS ────────────────────────────────────

RegisterNUICallback('jailPlayer', function(data, cb)
    TriggerServerEvent('bl_admin:jailPlayer', data)
    cb('ok')
end)

RegisterNUICallback('ghostBan', function(targetId, cb)
    TriggerServerEvent('bl_admin:ghostBan', targetId)
    cb('ok')
end)

RegisterNUICallback('revokeWarn', function(warnId, cb)
    TriggerServerEvent('bl_admin:revokeWarn', warnId)
    cb('ok')
end)

RegisterNUICallback('unjailPlayer', function(targetId, cb)
    TriggerServerEvent('bl_admin:unjailPlayer', targetId)
    cb('ok')
end)

RegisterNUICallback('unghostPlayer', function(targetId, cb)
    TriggerServerEvent('bl_admin:unghostPlayer', targetId)
    cb('ok')
end)

RegisterNUICallback('requestSanctions', function(_, cb)
    TriggerServerEvent('bl_admin:requestSanctions')
    cb('ok')
end)

RegisterNUICallback('clearLogs', function(_, cb)
    TriggerServerEvent('bl_admin:clearLogs')
    cb('ok')
end)

RegisterNUICallback('addVehicleToCatalog', function(data, cb)
    TriggerServerEvent('bl_admin:addVehicleToCatalog', data)
    cb('ok')
end)

RegisterNUICallback('removeVehicleFromCatalog', function(id, cb)
    TriggerServerEvent('bl_admin:removeVehicleFromCatalog', id)
    cb('ok')
end)

RegisterNUICallback('rotateVehicle', function(data, cb)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle ~= 0 then
        local currentHeading = GetEntityHeading(vehicle)
        SetEntityHeading(vehicle, currentHeading + (data.delta * 2.0))
    end
    cb('ok')
end)

RegisterNUICallback('getVehicleMods', function(_, cb)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then
        vehicle = GetClosestVehicle(GetEntityCoords(ped), 10.0, 0, 71)
    end

    if vehicle ~= 0 then
        InitializeVehicleModKit(vehicle)

            local props = {
                modEngine = GetVehicleMod(vehicle, 11),
                modBrakes = GetVehicleMod(vehicle, 12),
                modTransmission = GetVehicleMod(vehicle, 13),
                modSuspension = GetVehicleMod(vehicle, 15),
                modTurbo = IsToggleModOn(vehicle, 18),
                modArmor = GetVehicleMod(vehicle, 16),
                modWheels = GetVehicleMod(vehicle, 23),
                modBackWheels = GetVehicleMod(vehicle, 24),
                modSpoilers = GetVehicleMod(vehicle, 0),
                modFrontBumper = GetVehicleMod(vehicle, 1),
                modRearBumper = GetVehicleMod(vehicle, 2),
                modSideSkirt = GetVehicleMod(vehicle, 3),
                modExhaust = GetVehicleMod(vehicle, 4),
                modFrame = GetVehicleMod(vehicle, 5),
                modGrille = GetVehicleMod(vehicle, 6),
                modHood = GetVehicleMod(vehicle, 7),
                modFender = GetVehicleMod(vehicle, 8),
                modRightFender = GetVehicleMod(vehicle, 9),
                modRoof = GetVehicleMod(vehicle, 10),
                modHorns = GetVehicleMod(vehicle, 14),
                modPlateHolder = GetVehicleMod(vehicle, 25),
                modVanityPlate = GetVehicleMod(vehicle, 26),
                modTrimA = GetVehicleMod(vehicle, 27),
                modOrnaments = GetVehicleMod(vehicle, 28),
                modDashboard = GetVehicleMod(vehicle, 29),
                modDial = GetVehicleMod(vehicle, 30),
                modDoorSpeaker = GetVehicleMod(vehicle, 31),
                modSeats = GetVehicleMod(vehicle, 32),
                modSteeringWheel = GetVehicleMod(vehicle, 33),
                modShifterLeavers = GetVehicleMod(vehicle, 34),
                modAPlate = GetVehicleMod(vehicle, 35),
                modSpeakers = GetVehicleMod(vehicle, 36),
                modTrunk = GetVehicleMod(vehicle, 37),
                modHydraulics = GetVehicleMod(vehicle, 38),
                modEngineBlock = GetVehicleMod(vehicle, 39),
                modAirFilter = GetVehicleMod(vehicle, 40),
                modStruts = GetVehicleMod(vehicle, 41),
                modArchCover = GetVehicleMod(vehicle, 42),
                modAerials = GetVehicleMod(vehicle, 43),
                modTrimB = GetVehicleMod(vehicle, 44),
                modTank = GetVehicleMod(vehicle, 45),
                modWindows = GetVehicleMod(vehicle, 46),
                modLivery = GetVehicleMod(vehicle, 48),
                wheelsType = GetVehicleWheelType(vehicle),
                windowTint = GetVehicleWindowTint(vehicle),
                plateIndex = GetVehicleNumberPlateTextIndex(vehicle),
                neonEnabled = {
                    IsVehicleNeonLightEnabled(vehicle, 0),
                    IsVehicleNeonLightEnabled(vehicle, 1),
                    IsVehicleNeonLightEnabled(vehicle, 2),
                    IsVehicleNeonLightEnabled(vehicle, 3)
                }
            }

            -- Merge ESX properties safely if available
            if ESX and ESX.Game then
                local esxProps = ESX.Game.GetVehicleProperties(vehicle)
                if type(esxProps) == 'table' then
                    for k, v in pairs(esxProps) do
                        if type(v) == 'number' or type(v) == 'string' or type(v) == 'boolean' then
                            props[k] = v
                        end
                    end
                end
            end

            -- Gather localized names for all mods
            local labels = {}
            local modTypes = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,15,16,14,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,48}
            for _, modType in ipairs(modTypes) do
                local count = GetNumVehicleMods(vehicle, modType)
                local modNames = {}
                if count > 0 then
                    for i = 0, count - 1 do
                        local label = GetModTextLabel(vehicle, modType, i)
                        local name = GetLabelText(label)
                        if not name or name == "NULL" or name == "" then 
                            name = "Pièce #" .. (i + 1)
                        end
                        table.insert(modNames, name)
                    end
                end
                labels[tostring(modType)] = { 
                    current = GetVehicleMod(vehicle, modType), 
                    total = count, 
                    names = modNames 
                }
            end
            
            props.modLabels = labels
            cb(props)
    else
        print('[bl_admin] getVehicleMods: No vehicle found near player.')
        cb(nil)
    end
end)

RegisterNUICallback('setNeonColor', function(data, cb)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle ~= 0 then
        SetVehicleNeonLightsColour(vehicle, data.r, data.g, data.b)
        if ESX and ESX.Game then
            TriggerServerEvent('bl_admin:saveVehicleIfOwned', ESX.Game.GetVehicleProperties(vehicle))
        end
    end
    cb('ok')
end)

RegisterNUICallback('setVehicleMod', function(data, cb)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then
        vehicle = GetClosestVehicle(GetEntityCoords(ped), 5.0, 0, 71)
    end

    if vehicle ~= 0 then
        InitializeVehicleModKit(vehicle)
        if data.modType == 'neon' then
            SetVehicleNeonLightEnabled(vehicle, data.index, data.enabled)
        elseif data.modType == 'color' then
            if data.mode == 'primary' then
                SetVehicleCustomPrimaryColour(vehicle, data.r, data.g, data.b)
            elseif data.mode == 'secondary' then
                SetVehicleCustomSecondaryColour(vehicle, data.r, data.g, data.b)
            elseif data.mode == 'interior' then
                SetVehicleInteriorColour(vehicle, data.index or 0)
            elseif data.mode == 'wheels' then
                local pearl, wheel = GetVehicleExtraColours(vehicle)
                SetVehicleExtraColours(vehicle, pearl, data.index or 0)
            end
        elseif data.modType == 'tint' then
            SetVehicleWindowTint(vehicle, data.index)
        elseif data.modType == 'plate' then
            SetVehicleNumberPlateTextIndex(vehicle, data.index)
        elseif data.modType == 'wheelType' then
            SetVehicleWheelType(vehicle, data.index)
            SetVehicleMod(vehicle, 23, 0, false)
        else
            local modType = tonumber(data.modType) or data.modType
            local index = data.index
            if data.cycle then
                local count = GetNumVehicleMods(vehicle, modType)
                if count == 0 then
                    -- Fallback to standard counts for performance & wheels to prevent getting stuck at -1 on custom/import vehicles
                    if modType == 11 or modType == 15 then count = 4
                    elseif modType == 12 or modType == 13 then count = 3
                    elseif modType == 16 then count = 5
                    elseif modType == 23 or modType == 24 then count = 50
                    end
                end
                if count > 0 then
                    if index >= count then index = -1
                    elseif index < -1 then index = count - 1 end
                end
            end
            SetVehicleMod(vehicle, modType, index, false)
        end
        
        -- Auto-save if it's a personal vehicle
        if ESX and ESX.Game then
            TriggerServerEvent('bl_admin:saveVehicleIfOwned', ESX.Game.GetVehicleProperties(vehicle))
        end
    end
    cb('ok')
end)

RegisterNUICallback('giveVehicleToPlayer', function(data, cb)
    TriggerServerEvent('bl_admin:giveVehicleToPlayer', data)
    cb('ok')
end)

-- Exit Spectate Thread
Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        if spectateActive then
            sleep = 0
            -- 177 is Backspace/ESC/Right Click
            if IsControlJustPressed(0, 177) or IsDisabledControlJustPressed(0, 177) then
                spectateActive = false
                NetworkSetInSpectatorMode(false, PlayerPedId())
                SendNUIMessage({ action = 'toast', type = 'info', message = 'Spectate désactivé' })
                SendNUIMessage({ action = 'resetTools' })
            end
        end
        Citizen.Wait(sleep)
    end
end)

-- Dynamic Vehicle Godmode Loop Thread
Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        if vehGodmodeActive then
            sleep = 100
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(ped, false)
            if vehicle ~= 0 then
                SetEntityInvincible(vehicle, true)
                SetVehicleStrong(vehicle, true)
                SetVehicleCanBreak(vehicle, false)
                SetVehicleExplodesOnHighExplosionDamage(vehicle, false)
                SetVehicleTyresCanBurst(vehicle, false)
                SetVehicleWheelsCanBreak(vehicle, false)
                SetVehicleEngineCanDegrade(vehicle, false)
                
                -- Continuously keep health at maximum
                SetVehicleBodyHealth(vehicle, 1000.0)
                SetVehicleEngineHealth(vehicle, 1000.0)
                SetVehiclePetrolTankHealth(vehicle, 1000.0)
                SetVehicleDirtLevel(vehicle, 0.0)
                
                if GetIsVehicleEngineRunning(vehicle) then
                    SetVehicleEngineOn(vehicle, true, true, false)
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNUICallback('toggleFreezeTime', function(data, cb)
    TriggerServerEvent('bl_admin:toggleFreezeTime', data)
    cb('ok')
end)

RegisterNUICallback('toggleFreezeWeather', function(data, cb)
    TriggerServerEvent('bl_admin:toggleFreezeWeather', data)
    cb('ok')
end)

RegisterNUICallback('toggleBlackout', function(data, cb)
    TriggerServerEvent('bl_admin:toggleBlackout', data)
    cb('ok')
end)
