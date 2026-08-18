Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)  -- Execute every frame

        local playerPed = GetPlayerPed(-1)  -- Get the local player ped

        -- Check if the player is on foot
        if IsPedOnFoot(playerPed) then
            SetRadarZoom(1100)  -- Set the radar zoom level to 1100 (fully zoomed out)
        else
            -- Check if the player is inside any vehicle
            if IsPedInAnyVehicle(playerPed, true) then
                SetRadarZoom(1100)
            end
        end
    end
end)
