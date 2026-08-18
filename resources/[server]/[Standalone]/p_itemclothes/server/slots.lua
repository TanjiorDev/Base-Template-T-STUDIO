Slots = {}

Bridge = nil
if GetResourceState('p_bridge') == 'started' then
    local ok, bridge = pcall(function()
        return exports.p_bridge:getObject()
    end)
    if ok then
        Bridge = bridge
    end
end

function skinMatchesSlotSkin(currentSkin, slotConfig, playerSex)
    local defaultSkin = slotConfig.skin and slotConfig.skin[playerSex]
    if not defaultSkin then
        return false
    end
    for skinKey, skinValue in pairs(defaultSkin) do
        if currentSkin[skinKey] ~= skinValue then
            return false
        end
    end
    return true
end

function resolveInventoryId(inventoryRef)
    if type(inventoryRef) == "table" and inventoryRef.id then
        return inventoryRef.id
    end
    return inventoryRef
end

function checkBlacklistedItemTransfer(blacklistConfig, payload, fromInventoryId, toInventoryId)
    if type(blacklistConfig) ~= "table" then
        return true
    end
    local typeRules = blacklistConfig[payload.fromType]
    if not typeRules then
        typeRules = blacklistConfig[payload.toType]
    end
    if not typeRules or not fromInventoryId or not toInventoryId then
        return true
    end
    if payload.fromType == "player" and payload.toType == "player" and fromInventoryId ~= toInventoryId then
        if blacklistConfig.player and not blacklistConfig.player.giveTo then
            return false
        end
    else
        local fromRules = blacklistConfig[payload.fromType]
        if fromRules and not fromRules.takeFrom and fromInventoryId ~= toInventoryId then
            return false
        end
        local toRules = blacklistConfig[payload.toType]
        if toRules and not toRules.giveTo and fromInventoryId ~= toInventoryId then
            return false
        end
    end
    local toTypeRules = blacklistConfig[payload.toType]
    if toTypeRules and toTypeRules.job and fromInventoryId ~= toInventoryId then
        local targetJob = Bridge and Bridge.Framework and Bridge.Framework.getPlayerJob(toInventoryId)
        if targetJob and toTypeRules.job[targetJob.name] and not toTypeRules.job[targetJob.name].giveTo then
            return false
        end
    end
    local fromTypeRules = blacklistConfig[payload.fromType]
    if fromTypeRules and fromTypeRules.job and fromInventoryId ~= toInventoryId then
        local sourceJob = Bridge and Bridge.Framework and Bridge.Framework.getPlayerJob(fromInventoryId)
        if sourceJob and fromTypeRules.job[sourceJob.name] and not fromTypeRules.job[sourceJob.name].takeFrom then
            return false
        end
    end
    return true
end

function getTargetClothingSlotNumber(payload)
    if not payload.toSlot then
        return nil
    end
    if type(payload.toSlot) == "number" then
        return payload.toSlot
    end
    return tonumber(payload.toSlot.slot)
end

function Slots.restrictSlots(self)
    Citizen.Wait(1000)
    exports.ox_inventory:registerHook("swapItems", function(payload)
        local blacklistedItem = Config.BlacklistedItems[payload.fromSlot.name]
        local fromInventoryId = resolveInventoryId(payload.fromInventory)
        local toInventoryId = resolveInventoryId(payload.toInventory)
        if blacklistedItem and not checkBlacklistedItemTransfer(blacklistedItem, payload, fromInventoryId, toInventoryId) then
            return false
        end
        local targetSlot = getTargetClothingSlotNumber(payload)
        local clothingSlot = targetSlot and Config.ClothingSlots[targetSlot]
        if clothingSlot and payload.toType:find("player") then
            return payload.fromSlot.name == clothingSlot.itemName
        end
        return true
    end)
end

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while GetResourceState("ox_inventory") ~= "started" do
        Citizen.Wait(100)
    end
    Citizen.Wait(5000)
    Slots:restrictSlots()
end)

exports("getClothingSlots", function()
    return Config.ClothingSlots
end)
