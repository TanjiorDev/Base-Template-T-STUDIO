-- ============================================================
--  BLOODADMIN — CLIENT/MODULES/UTILS.LUA
-- ============================================================

ESX = nil
menuOpen = false
noclipActive = false
godmodeActive = false
invisibleActive = false
playerGrade = ''
playerPerms = {}
staffList = {}

Citizen.CreateThread(function()
    local ok, result = pcall(function() return exports['es_extended']:getSharedObject() end)
    if ok and result then
        ESX = result
    else
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(500)
    end
end)

function toggleMenu(forceClose, data)
    if forceClose then
        menuOpen = false
    else
        menuOpen = not menuOpen
    end
    
    if menuOpen then
        SetNuiFocus(true, true)
    else
        -- Small delay to prevent ESC from bleeding into the game (opening map)
        Citizen.CreateThread(function()
            Citizen.Wait(100)
            SetNuiFocus(false, false)
        end)
    end
    
    local payload = {
        action = menuOpen and 'openMenu' or 'closeMenu',
        config = Config,
        grade  = playerGrade
    }

    if menuOpen then
        TriggerServerEvent('bl_admin:requestWorldState')
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)
        if veh ~= 0 then
            local modelHash = GetEntityModel(veh)
            -- GetDisplayNameFromVehicleModel returns the internal name (e.g., "T20")
            payload.currentVehicle = string.lower(GetDisplayNameFromVehicleModel(modelHash))
        end
    end
    
    if data then
        for k, v in pairs(data) do
            payload[k] = v
        end
    end
    
    SendNUIMessage(payload)
end

-- Block map/pause menu while UI is active
Citizen.CreateThread(function()
    while true do
        local sleep = 500
        if menuOpen or IsNuiFocused() then
            sleep = 0
            DisableControlAction(0, 200, true) -- Pause Menu (ESC)
            DisableControlAction(0, 199, true) -- Pause Menu (P)
            DisableControlAction(0, 322, true) -- ESC
        end
        Citizen.Wait(sleep)
    end
end)

RegisterCommand('report', function()
    if menuOpen then return end
    SetNuiFocus(true, true)
    local coords = GetEntityCoords(PlayerPedId())
    SendNUIMessage({
        action = 'openPlayerReport',
        coords = { x = coords.x, y = coords.y, z = coords.z }
    })
end, false)

-- Fired by server when a staff member is destituted
RegisterNetEvent('bl_admin:revokeAccess')
AddEventHandler('bl_admin:revokeAccess', function()
    -- Reset all local state
    playerGrade = ''
    playerPerms = {}
    
    -- Force-close the menu if open
    if menuOpen then
        toggleMenu(true)
    end
    
    -- Notify the NUI to wipe its state
    SendNUIMessage({ action = 'revokeAccess' })
end)
