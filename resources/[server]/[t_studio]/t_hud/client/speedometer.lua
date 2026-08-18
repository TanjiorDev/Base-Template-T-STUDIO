Citizen.CreateThread(function()
    local speedometerEnabled = false
    while true do
        local ped = PlayerPedId()
        local waitTime = 1000
        local vehicle = GetVehiclePedIsIn(ped)
        if IsPauseMenuActive() then
            SendNUIMessage({ showspeedo_so_213 = false })
        elseif GetPedInVehicleSeat(vehicle, -1) == ped and GetIsVehicleEngineRunning(vehicle) then
            speedometerEnabled = true
            waitTime = 100
            local _, positionLight, roadLight = GetVehicleLightsState(vehicle)
            SendNUIMessage({
                showspeedo_so_213 = true,
                speed = math.ceil(GetEntitySpeed(vehicle) * 3.6),
                feuPosition = (positionLight == 1),
                feuRoute = (roadLight == 1),
                clignotantDroite = true,
                clignotantGauche = true,
            })
        elseif speedometerEnabled then
            speedometerEnabled = false
            SendNUIMessage({ showspeedo_so_213 = false })
        end
        Citizen.Wait(waitTime)
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        if IsPedInAnyVehicle(ped) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            if vehicle and GetPedInVehicleSeat(vehicle, -1) == ped then
                local carSpeed = math.ceil(GetEntitySpeed(vehicle) * 3.6)
                local fuelLevel = GetVehicleFuelLevel(vehicle)
                SendNUIMessage({
                    showfuel = true,
                    essence = fuelLevel
                })
            end
        end
        Citizen.Wait(350)
    end
end)
