Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        
        -- GetLocalTime() récupère l'heure réelle de ton PC/Serveur sans utiliser 'os'
        local year, month, day, hour, minute, second = GetLocalTime()
        
        SendNUIMessage({
            type = "update_hud",
            time = string.format("%02d:%02d", hour, minute),
            date = string.format("%02d/%02d", day, month),
            id = GetPlayerServerId(PlayerId())
        })
    end
end)