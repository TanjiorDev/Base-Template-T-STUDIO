local ESX = exports["es_extended"]:getSharedObject()
local currentShop = nil
local shopPeds = {}
local spawnDistance = 50.0 
local deleteDistance = 70.0 

CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        for marketType, locations in pairs(Config.Locations) do
            if not shopPeds[marketType] then
                shopPeds[marketType] = {}
            end
            
            for i, coords in ipairs(locations) do
                local distance = #(playerCoords - vector3(coords.x, coords.y, coords.z))
                local pedData = shopPeds[marketType][i]
                
                if distance <= spawnDistance and (not pedData or not DoesEntityExist(pedData.ped)) then
                    local pedModel = GetHashKey(Config.PedModels[marketType])
                    
                    RequestModel(pedModel)
                    while not HasModelLoaded(pedModel) do
                        Wait(1)
                    end
                    
                    local ped = CreatePed(4, pedModel, coords.x, coords.y, coords.z - 1, coords.w, false, true)
                    
                    SetEntityHeading(ped, coords.w)
                    FreezeEntityPosition(ped, true)
                    SetEntityInvincible(ped, true)
                    SetBlockingOfNonTemporaryEvents(ped, true)
                    
                    shopPeds[marketType][i] = {
                        ped = ped,
                        coords = coords,
                        marketType = marketType
                    }
                    
                    exports.ox_target:addLocalEntity(ped, {
                        {
                            name = 'open_shop_' .. marketType .. '_' .. i,
                            icon = 'fas fa-shopping-cart',
                            label = 'Otvori ' .. Config.Markets[marketType].name,
                            onSelect = function()
                                openShop(marketType)
                            end
                        }
                    })
                    
                    SetModelAsNoLongerNeeded(pedModel)
                    
                elseif distance > deleteDistance and pedData and DoesEntityExist(pedData.ped) then
                    exports.ox_target:removeLocalEntity(pedData.ped)
                    DeleteEntity(pedData.ped)
                    shopPeds[marketType][i] = nil
                end
            end
        end
        
        Wait(2000)
    end
end)

CreateThread(function()
    for marketType, locations in pairs(Config.Locations) do
        local blipData = Config.Blips[marketType]
        if blipData and blipData.enabled then
            for _, coords in ipairs(locations) do
                local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                SetBlipSprite(blip, blipData.sprite)
                SetBlipDisplay(blip, 4)
                SetBlipScale(blip, blipData.scale)
                SetBlipColour(blip, blipData.color)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(blipData.name)
                EndTextCommandSetBlipName(blip)
            end
        end
    end
end)

function openShop(marketType)
    currentShop = marketType
    
    ESX.TriggerServerCallback('tr_marketi:getPlayerData', function(playerData)
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "openShop",
            shopData = Config.Markets[marketType],
            playerData = playerData
        })
    end)
end

function closeShop()
    currentShop = nil
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "closeShop"
    })
end

RegisterNUICallback('closeShop', function(data, cb)
    closeShop()
    cb('ok')
end)

RegisterNUICallback('buyItems', function(data, cb)
    if not currentShop then
        cb('error')
        return
    end
    
    ESX.TriggerServerCallback('tr_marketi:buyItems', function(success, message)
        if success then
            ESX.ShowNotification(message, 'success')
        else
            ESX.ShowNotification(message, 'error')
        end
        
        ESX.TriggerServerCallback('tr_marketi:getPlayerData', function(playerData)
            SendNUIMessage({
                type = "updatePlayerData", 
                playerData = playerData
            })
        end)
        
        cb(success)
    end, currentShop, data.items, data.paymentMethod, data.totalPrice)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for marketType, peds in pairs(shopPeds) do
            for i, pedData in pairs(peds) do
                if pedData and DoesEntityExist(pedData.ped) then
                    exports.ox_target:removeLocalEntity(pedData.ped)
                    DeleteEntity(pedData.ped)
                end
            end
        end
        shopPeds = {}
        
        if currentShop then
            closeShop()
        end
    end
end)