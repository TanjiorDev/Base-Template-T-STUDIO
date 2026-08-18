Clothes = {}
Clothes.allowedItems = {}
Clothes.playersClothes = {}
Clothes.ready = false

RegisterNetEvent("p_itemclothes/server/setClothes", function(clothesData)
    Clothes.playersClothes[source] = clothesData
end)

function Clothes.getSex(self, playerId)
    local playerPed = GetPlayerPed(playerId)
    if not playerPed or playerPed == 0 then
        return "male"
    end
    if GetEntityModel(playerPed) == 1885233650 then
        return "male"
    end
    return "female"
end

function Clothes.loadAllowedItems(self)
    for slotIndex, slotConfig in pairs(Config.ClothingSlots) do
        if slotConfig.itemName and slotConfig.skin then
            self.allowedItems[slotConfig.itemName] = {
                data = slotConfig,
                slot = slotIndex,
            }
        end
    end
end

exports("useClothingItem", function(event, item, inventory, slot)
    local playerId = inventory.id
    local allowedItem = Clothes.allowedItems[item.name]
    local clothingSlot = allowedItem and allowedItem.slot
    if not clothingSlot then
        return false
    end
    local currentSlotItem = exports.ox_inventory:GetSlot(playerId, slot)
    if slot ~= clothingSlot then
        local equippedSlotItem = exports.ox_inventory:GetSlot(playerId, clothingSlot)
        if equippedSlotItem and equippedSlotItem.count > 0 then
            exports.ox_inventory:RemoveItem(
                playerId,
                equippedSlotItem.name,
                equippedSlotItem.count,
                equippedSlotItem.metadata,
                equippedSlotItem.slot
            )
            Citizen.Wait(1)
        end
        exports.ox_inventory:RemoveItem(
            playerId,
            currentSlotItem.name,
            currentSlotItem.count,
            currentSlotItem.metadata,
            slot
        )
        Citizen.Wait(1)
        exports.ox_inventory:AddItem(playerId, currentSlotItem.name, currentSlotItem.count, currentSlotItem.metadata, clothingSlot)
        if equippedSlotItem then
            exports.ox_inventory:AddItem(
                playerId,
                equippedSlotItem.name,
                equippedSlotItem.count,
                equippedSlotItem.metadata,
                slot
            )
        end
        return true
    end
    return false
end)

function remapClothingSlots()
    if Clothes.remapped then
        return
    end

    local playerInvSlots = exports.ox_inventory:getPlayerInvSlots()
    local remappedSlots = {}

    for slotIndex = 1, 14 do
        local slotConfig = Config.ClothingSlots[slotIndex]
        if slotConfig then
            remappedSlots[playerInvSlots - 14 + slotIndex] = slotConfig
        end
    end

    Config.ClothingSlots = remappedSlots
    Clothes.remapped = true
end

CreateThread(function()
    while not Config or not Config.ClothingSlots or GetResourceState("ox_inventory") ~= "started" do
        Citizen.Wait(100)
    end
    remapClothingSlots()
    Clothes:loadAllowedItems()
    Clothes.ready = true
end)

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    local playerId = source
    SetTimeout(5000, function()
        if GetPlayerName(playerId) then
            TriggerClientEvent('p_itemclothes/client/updateClothes', playerId)
        end
    end)
end)
