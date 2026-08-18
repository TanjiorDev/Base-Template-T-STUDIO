local ESX = exports['es_extended']:getSharedObject()

local menuOpen = false
local radarEnabled = true
local playerData = {}

local mainMenu = RageUI.CreateMenu(Config.Title, Config.Subtitle)
local walletMenu = RageUI.CreateSubMenu(mainMenu, Config.Title, 'Portefeuille')
local clothesMenu = RageUI.CreateSubMenu(mainMenu, Config.Title, 'Vêtements')
local animationsMenu = RageUI.CreateSubMenu(mainMenu, Config.Title, 'Animations')
local vehicleMenu = RageUI.CreateSubMenu(mainMenu, Config.Title, 'Véhicule')
local vehicleDoorsMenu = RageUI.CreateSubMenu(vehicleMenu, Config.Title, 'Portes')
local gpsMenu = RageUI.CreateSubMenu(mainMenu, Config.Title, 'GPS rapide')
local miscMenu = RageUI.CreateSubMenu(mainMenu, Config.Title, 'Divers')

local menus = {
    mainMenu, walletMenu, clothesMenu, animationsMenu,
    vehicleMenu, vehicleDoorsMenu, gpsMenu, miscMenu
}

local function notify(message)
    ESX.ShowNotification(message)
end

local function refreshPlayerData()
    playerData = ESX.GetPlayerData() or {}
end

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    playerData = xPlayer or {}
end)

RegisterNetEvent('esx:setJob', function(job)
    playerData.job = job
end)

-- Compatibilité ESX Legacy : certaines versions n'exposent pas ESX.IsPlayerLoaded().
-- On initialise simplement les données après le chargement de la ressource ;
-- l'évènement esx:playerLoaded ci-dessus prendra ensuite le relais.
CreateThread(function()
    Wait(1000)
    refreshPlayerData()
end)

local function getAccount(name)
    local accounts = playerData.accounts or {}
    for i = 1, #accounts do
        if accounts[i].name == name then
            return tonumber(accounts[i].money) or 0
        end
    end
    return 0
end

local function keyboardInput(title, defaultText, maxLength)
    AddTextEntry('HC_F5_INPUT', title)
    DisplayOnscreenKeyboard(1, 'HC_F5_INPUT', '', defaultText or '', '', '', '', maxLength or 10)

    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end

    if GetOnscreenKeyboardResult() then
        return GetOnscreenKeyboardResult()
    end
end

local function getClosestPlayer(maxDistance)
    local players = GetActivePlayers()
    local myPed = PlayerPedId()
    local myCoords = GetEntityCoords(myPed)
    local closestPlayer, closestDistance

    for i = 1, #players do
        local player = players[i]
        if player ~= PlayerId() then
            local ped = GetPlayerPed(player)
            if DoesEntityExist(ped) then
                local distance = #(GetEntityCoords(ped) - myCoords)
                if (not closestDistance or distance < closestDistance) and distance <= maxDistance then
                    closestPlayer = player
                    closestDistance = distance
                end
            end
        end
    end

    return closestPlayer, closestDistance
end

local function closeAllMenus()
    menuOpen = false
    for i = 1, #menus do
        RageUI.Visible(menus[i], false)
    end
end

local function openMenu()
    if menuOpen then
        closeAllMenus()
        return
    end

    refreshPlayerData()
    menuOpen = true
    RageUI.Visible(mainMenu, true)

    CreateThread(function()
        while menuOpen do
            RageUI.IsVisible(mainMenu, function()
                local job = playerData.job or {}
                RageUI.Separator(('ID : ~r~%s~s~ | Métier : ~r~%s~s~'):format(
                    GetPlayerServerId(PlayerId()),
                    job.label or job.name or 'Aucun'
                ))

                RageUI.Button('Inventaire', 'Ouvrir votre inventaire ox_inventory.', { RightLabel = '→→' }, true, {
                    onSelected = function()
                        if GetResourceState(Config.Dependencies.Inventory) ~= 'started' then
                            notify('~r~ox_inventory n\'est pas démarré.')
                            return
                        end
                        closeAllMenus()
                        ExecuteCommand(Config.InventoryCommand)
                    end
                })

                RageUI.Button('Portefeuille', 'Argent, banque et transfert d\'argent.', { RightLabel = '→→' }, true, {}, walletMenu)
                RageUI.Button('Vêtements', 'Gérer rapidement vos vêtements et accessoires.', { RightLabel = '→→' }, true, {}, clothesMenu)
                RageUI.Button('Animations', 'Animations personnelles rapides.', { RightLabel = '→→' }, true, {}, animationsMenu)
                -- Le menu véhicule est affiché uniquement lorsque le joueur est dans un véhicule.
                local ped = PlayerPedId()
                if IsPedInAnyVehicle(ped, false) then
                    RageUI.Button('Véhicule', 'Actions sur votre véhicule actuel.', { RightLabel = '→→' }, true, {}, vehicleMenu)
                end
                RageUI.Button('GPS rapide', 'Placer rapidement un point GPS.', { RightLabel = '→→' }, true, {}, gpsMenu)
                RageUI.Button('Divers', 'Options personnelles diverses.', { RightLabel = '→→' }, true, {}, miscMenu)
            end)

            RageUI.IsVisible(walletMenu, function()
                RageUI.Separator(('Liquide : ~g~$%s'):format(getAccount('money')))
                RageUI.Separator(('Banque : ~b~$%s'):format(getAccount('bank')))

                local blackMoney = getAccount('black_money')
                if blackMoney > 0 then
                    RageUI.Separator(('Argent sale : ~r~$%s'):format(blackMoney))
                end

                RageUI.Button('Donner de l\'argent liquide', 'Donne de l\'argent au joueur le plus proche.', { RightLabel = '→' }, true, {
                    onSelected = function()
                        local target = getClosestPlayer(Config.MaxGiveDistance)
                        if not target then
                            notify('~r~Aucun joueur suffisamment proche.')
                            return
                        end

                        local value = tonumber(keyboardInput('Montant à donner', '', 8))
                        if not value or value <= 0 then
                            notify('~r~Montant invalide.')
                            return
                        end

                        TriggerServerEvent('hc_f5:giveCash', GetPlayerServerId(target), math.floor(value))
                    end
                })

                RageUI.Button('Actualiser le portefeuille', 'Recharge les informations ESX du joueur.', {}, true, {
                    onSelected = refreshPlayerData
                })
            end)

            RageUI.IsVisible(clothesMenu, function()
                RageUI.Button('Recharger ma tenue', 'Recharge votre apparence sauvegardée via illenium-appearance.', {}, true, {
                    onSelected = function()
                        if GetResourceState(Config.Dependencies.Appearance) == 'started' then
                            closeAllMenus()
                            ExecuteCommand(Config.ReloadSkinCommand)
                        else
                            notify('~r~illenium-appearance n\'est pas démarré.')
                        end
                    end
                })

                RageUI.Separator('~r~Vêtements')

                RageUI.Button('Torse / chemise', 'Retirer votre haut et le placer dans ox_inventory.', {}, true, {
                    onSelected = function() TriggerEvent('remove:torso') end
                })
                RageUI.Button('Pantalon', 'Retirer votre pantalon et le placer dans ox_inventory.', {}, true, {
                    onSelected = function() TriggerEvent('remove:pants') end
                })
                RageUI.Button('Chaussures', 'Retirer vos chaussures et les placer dans ox_inventory.', {}, true, {
                    onSelected = function() TriggerEvent('remove:shoes') end
                })
                RageUI.Button('Masque', 'Retirer votre masque et le placer dans ox_inventory.', {}, true, {
                    onSelected = function() TriggerEvent('remove:mask') end
                })
                RageUI.Button('Chapeau', 'Retirer votre chapeau et le placer dans ox_inventory.', {}, true, {
                    onSelected = function() TriggerEvent('remove:hat') end
                })
                RageUI.Button('Sac', 'Retirer votre sac et le placer dans ox_inventory.', {}, true, {
                    onSelected = function() TriggerEvent('remove:bag') end
                })
                RageUI.Button('Lunettes', 'Retirer vos lunettes et les placer dans ox_inventory.', {}, true, {
                    onSelected = function() TriggerEvent('remove:glasses') end
                })
                RageUI.Button('Gilet', 'Retirer votre gilet et le placer dans ox_inventory.', {}, true, {
                    onSelected = function() TriggerEvent('remove:vest') end
                })
                RageUI.Button('Boucles d\'oreilles', 'Retirer vos boucles d\'oreilles et les placer dans ox_inventory.', {}, true, {
                    onSelected = function() TriggerEvent('remove:ears') end
                })
                RageUI.Button('Chaîne', 'Retirer votre chaîne et la placer dans ox_inventory.', {}, true, {
                    onSelected = function() TriggerEvent('remove:chain') end
                })
            end)

            RageUI.IsVisible(animationsMenu, function()
                for i = 1, #Config.Animations do
                    local data = Config.Animations[i]
                    RageUI.Button(data.label, 'Jouer cette animation.', {}, true, {
                        onSelected = function()
                            RequestAnimDict(data.dict)
                            while not HasAnimDictLoaded(data.dict) do Wait(25) end
                            TaskPlayAnim(PlayerPedId(), data.dict, data.anim, 8.0, -8.0, -1, data.flag or 49, 0.0, false, false, false)
                        end
                    })
                end

                RageUI.Button('Arrêter l\'animation', 'Arrête immédiatement l\'animation en cours.', {}, true, {
                    onSelected = function()
                        ClearPedTasks(PlayerPedId())
                    end
                })
            end)

            RageUI.IsVisible(vehicleMenu, function()
                local ped = PlayerPedId()
                local vehicle = GetVehiclePedIsIn(ped, false)
                local inVehicle = vehicle ~= 0

                RageUI.Button('Moteur', 'Démarrer ou couper le moteur si vous êtes conducteur.', {}, inVehicle, {
                    onSelected = function()
                        if GetPedInVehicleSeat(vehicle, -1) ~= ped then
                            return notify('~r~Vous devez être conducteur.')
                        end
                        SetVehicleEngineOn(vehicle, not GetIsVehicleEngineRunning(vehicle), false, true)
                    end
                })

                RageUI.Button('Portes', 'Ouvrir ou fermer les portes du véhicule.', { RightLabel = '→→' }, inVehicle, {}, vehicleDoorsMenu)

                RageUI.Button('Toutes les vitres : ouvrir', 'Baisse toutes les vitres disponibles.', {}, inVehicle, {
                    onSelected = function()
                        for window = 0, 3 do RollDownWindow(vehicle, window) end
                    end
                })

                RageUI.Button('Toutes les vitres : fermer', 'Remonte toutes les vitres disponibles.', {}, inVehicle, {
                    onSelected = function()
                        for window = 0, 3 do RollUpWindow(vehicle, window) end
                    end
                })
            end)

            RageUI.IsVisible(vehicleDoorsMenu, function()
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if vehicle == 0 then
                    RageUI.Separator('~r~Vous n\'êtes pas dans un véhicule.')
                    return
                end

                local doorLabels = { 'Avant gauche', 'Avant droite', 'Arrière gauche', 'Arrière droite', 'Capot', 'Coffre' }
                for door = 0, 5 do
                    RageUI.Button(doorLabels[door + 1], 'Ouvrir / fermer cette porte.', {}, true, {
                        onSelected = function()
                            if GetVehicleDoorAngleRatio(vehicle, door) > 0.1 then
                                SetVehicleDoorShut(vehicle, door, false)
                            else
                                SetVehicleDoorOpen(vehicle, door, false, false)
                            end
                        end
                    })
                end
            end)

            RageUI.IsVisible(gpsMenu, function()
                for i = 1, #Config.GPS do
                    local point = Config.GPS[i]
                    RageUI.Button(point.label, 'Placer ce lieu sur votre GPS.', {}, true, {
                        onSelected = function()
                            SetNewWaypoint(point.coords.x, point.coords.y)
                            notify(('GPS défini : ~r~%s'):format(point.label))
                        end
                    })
                end

                RageUI.Button('Retirer le GPS', 'Supprime votre point GPS actuel.', {}, true, {
                    onSelected = function()
                        SetWaypointOff()
                        notify('Point GPS supprimé.')
                    end
                })
            end)

            RageUI.IsVisible(miscMenu, function()
                RageUI.Button('Afficher mon ID serveur', 'Affiche votre identifiant serveur.', { RightLabel = tostring(GetPlayerServerId(PlayerId())) }, true, {
                    onSelected = function()
                        notify(('Votre ID serveur est ~r~%s'):format(GetPlayerServerId(PlayerId())))
                    end
                })

                RageUI.Checkbox('Mini-carte', 'Afficher ou masquer la mini-carte.', radarEnabled, {}, {
                    onChecked = function()
                        radarEnabled = true
                        DisplayRadar(true)
                    end,
                    onUnChecked = function()
                        radarEnabled = false
                        DisplayRadar(false)
                    end,
                    onSelected = function(value)
                        radarEnabled = value == true
                        DisplayRadar(radarEnabled)
                    end
                })

                RageUI.Button('Se relever / stopper les tâches', 'Annule les animations et tâches en cours.', {}, true, {
                    onSelected = function()
                        ClearPedTasksImmediately(PlayerPedId())
                    end
                })
            end)

            Wait(0)

            if menuOpen then
                local anyVisible = false
                for i = 1, #menus do
                    if RageUI.Visible(menus[i]) then
                        anyVisible = true
                        break
                    end
                end
                if not anyVisible then menuOpen = false end
            end
        end
    end)
end

RegisterCommand(Config.Command, openMenu, false)
RegisterKeyMapping(Config.Command, 'Ouvrir le menu personnel', 'keyboard', Config.Key)

exports('OpenF5Menu', openMenu)
exports('CloseF5Menu', closeAllMenus)

RegisterNetEvent('hc_f5:refreshPlayerData', function()
    refreshPlayerData()
end)
