-- ============================================================
--  BLOODADMIN — CLIENT/MODULES/NOCLIP.LUA (ADVANCED)
-- ============================================================

local noclipSpeed = 1.0
local speeds = {
    { label = "Très Lent", speed = 0.1 },
    { label = "Lent", speed = 0.5 },
    { label = "Normal", speed = 1.0 },
    { label = "Rapide", speed = 2.0 },
    { label = "Très Rapide", speed = 5.0 },
    { label = "Maximum", speed = 10.0 }
}
local speedIdx = 3

function toggleNoclip(active)
    noclipActive = active
    SendNUIMessage({ action = 'syncTool', tool = 'noclip', active = active })
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    local target = veh ~= 0 and veh or ped

    if noclipActive then
        SetEntityCollision(target, false, false)
        FreezeEntityPosition(target, true)
        SetEntityInvincible(target, true)
        SetVehicleRadioEnabled(veh, false)
        
        -- Auto-vanish on noclip
        TriggerEvent('bl_admin:toggleVanish', true)
        SendNUIMessage({ action = 'syncTool', tool = 'vanish', active = true })
    else
        SetEntityCollision(target, true, true)
        FreezeEntityPosition(target, false)
        SetEntityInvincible(target, godmodeActive or false)
        
        -- Put player on ground safely
        local coords = GetEntityCoords(target)
        SetPedCoordsKeepVehicle(ped, coords.x, coords.y, coords.z)
        Wait(50)
        local ground, z = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, 0)
        
        if not ground then
            -- Try to find ground by looking down from current height
            for i = 1, 20 do
                ground, z = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z + (i * 5.0), 0)
                if ground then break end
                ground, z = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z - (i * 5.0), 0)
                if ground then break end
                Wait(10)
            end
        end

        if ground then
            SetEntityCoords(target, coords.x, coords.y, z + 1.1)
        else
            -- Last resort: Place at current Z and hope for the best
            SetEntityCoords(target, coords.x, coords.y, coords.z)
        end

        -- Auto-visible on noclip off
        TriggerEvent('bl_admin:toggleVanish', false)
        SendNUIMessage({ action = 'syncTool', tool = 'vanish', active = false })
    end
end

Citizen.CreateThread(function()
    while true do
        local sleep = 500
        if noclipActive then
            sleep = 0
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)
            local target = veh ~= 0 and veh or ped
            
            -- Speed Control (PgUp/PgDn)
            if IsDisabledControlJustPressed(0, 10) then -- PgUp
                speedIdx = math.min(#speeds, speedIdx + 1)
                noclipSpeed = speeds[speedIdx].speed
                TriggerEvent('bl_admin:notify', 'info', 'Vitesse: ' .. speeds[speedIdx].label)
            elseif IsDisabledControlJustPressed(0, 11) then -- PgDn
                speedIdx = math.max(1, speedIdx - 1)
                noclipSpeed = speeds[speedIdx].speed
                TriggerEvent('bl_admin:notify', 'info', 'Vitesse: ' .. speeds[speedIdx].label)
            end

            -- Toggle Vanish (G key)
            if IsDisabledControlJustPressed(0, 47) then -- G
                TriggerEvent('bl_admin:toggleVanish', not invisibleActive)
                SendNUIMessage({ action = 'syncTool', tool = 'vanish', active = invisibleActive })
            end

            local camRot = GetGameplayCamRot(2)
            SetEntityRotation(target, camRot.x, camRot.y, camRot.z, 2, true)
            
            local x, y, z = table.unpack(GetEntityCoords(target))
            local dx, dy, dz = table.unpack(GetGameplayCamRot(2))
            local z_rad = dx * (math.pi / 180.0)
            local x_rad = dz * (math.pi / 180.0)
            local num = math.abs(math.cos(z_rad))

            local newX = x
            local newY = y
            local newZ = z

            local moveSpeed = noclipSpeed
            if IsControlPressed(0, 21) then moveSpeed = moveSpeed * 3.0 end -- Shift
            if IsControlPressed(0, 36) then moveSpeed = moveSpeed * 0.3 end -- Ctrl

            if IsControlPressed(0, 32) then -- Z (Forward)
                newX = newX - (math.sin(x_rad) * moveSpeed * num)
                newY = newY + (math.cos(x_rad) * moveSpeed * num)
                newZ = newZ + (math.sin(z_rad) * moveSpeed)
            elseif IsControlPressed(0, 33) then -- S (Backward)
                newX = newX + (math.sin(x_rad) * moveSpeed * num)
                newY = newY - (math.cos(x_rad) * moveSpeed * num)
                newZ = newZ - (math.sin(z_rad) * moveSpeed)
            end

            if IsControlPressed(0, 34) then -- Q (Left)
                newX = newX - (math.cos(x_rad) * moveSpeed)
                newY = newY - (math.sin(x_rad) * moveSpeed)
            elseif IsControlPressed(0, 35) then -- D (Right)
                newX = newX + (math.cos(x_rad) * moveSpeed)
                newY = newY + (math.sin(x_rad) * moveSpeed)
            end

            if IsControlPressed(0, 22) then -- Space (Up)
                newZ = newZ + moveSpeed
            elseif IsControlPressed(0, 19) then -- Alt (Down)
                newZ = newZ - moveSpeed
            end

            if IsControlJustPressed(0, 38) then -- E
                TriggerEvent('bl_admin:tpToWaypoint')
            end

            if IsDisabledControlJustPressed(0, 73) then -- X
                toggleNoclip(false)
            end

            SetEntityCoordsNoOffset(target, newX, newY, newZ, true, true, true)
        end
        Citizen.Wait(sleep)
    end
end)
