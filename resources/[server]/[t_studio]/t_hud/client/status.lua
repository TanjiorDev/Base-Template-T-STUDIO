Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        -- Désactive l'affichage de la santé et de l'armure d'origine
        HideHudComponentThisFrame(3) -- Santé
        HideHudComponentThisFrame(4) -- Armure
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        
        TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
            TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)
                SendNUIMessage({
                    action = "updateStatus",
                    hunger = hunger.getPercent(),
                    thirst = thirst.getPercent()
                })
            end)
        end)
    end
end)