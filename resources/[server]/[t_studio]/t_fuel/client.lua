Citizen.CreateThread(function()
    for _, station in pairs(Config.Stations) do
        local blip = AddBlipForCoord(station.coords)
        SetBlipSprite(blip, 361)
        SetBlipColour(blip, 1)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        SetBlipDisplay(blip, 4)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Station-Service")
        EndTextCommandSetBlipName(blip)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = false

        for _, station in pairs(Config.Stations) do
            if #(pos - station.coords) < 5.0 then
                inRange = true
                BeginTextCommandDisplayHelp("STRING")
                AddTextComponentSubstringPlayerName("Appuyez sur ~INPUT_CONTEXT~ pour faire le plein")
                EndTextCommandDisplayHelp(0, false, true, -1)

                if IsControlJustReleased(0, 38) then
                    local veh = GetVehiclePedIsIn(ped, false)
                    if veh ~= 0 then
                        local fuelLevel = GetVehicleFuelLevel(veh)
                        SetNuiFocus(true, true)
                        SendNUIMessage({
                            action = "openMenu",
                            fuel = math.floor(fuelLevel)
                        })
                    end
                end
            end
        end
        if not inRange then Citizen.Wait(1000) end
    end
end)

RegisterNUICallback('close', function() 
    SetNuiFocus(false, false) 
end)

RegisterNUICallback('confirm', function(data)
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh ~= 0 then
        local fuel = GetVehicleFuelLevel(veh)
        SetVehicleFuelLevel(veh, fuel + tonumber(data.amount))
    end
    SetNuiFocus(false, false)
    SendNUIMessage({action = "closeMenu"})
end)