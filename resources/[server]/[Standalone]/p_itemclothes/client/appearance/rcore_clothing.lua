while not Config or not Config.Appearance do
    Citizen.Wait(100)
end

if Config.Appearance ~= "rcore_clothing" then
    return
end

Skin = {}
Skin.timer = GetGameTimer()
Skin.timerThread = false
Skin.saveTimer = GetGameTimer()
Skin.saveThread = false
skinUpdateEnabled = false
shopSkinBackup = nil
restoreOutfitAfterShop = false

function getOutfitInventorySlot()
    return exports.ox_inventory:getPlayerInvSlots()
end

function getOutfitFromSlot()
    local outfitSlot = getOutfitInventorySlot()
    local playerItems = exports.ox_inventory:GetPlayerItems()
    local outfitItem = playerItems[outfitSlot]
    if outfitItem and outfitItem.name == "clothing_outfit" and outfitItem.metadata then
        local outfitData = outfitItem.metadata.outfitData
        if type(outfitData) == "string" then
            return json.decode(outfitData) or {}
        end
        if type(outfitData) == "table" then
            return outfitData
        end
        return outfitItem.metadata
    end
    return nil
end

function applyOutfitSkin(outfitData)
    if not outfitData then
        return
    end
    local flatSkin = {}
    local hasSkinValues = false
    for _, outfitPart in pairs(outfitData) do
        if type(outfitPart) == "table" then
            for skinKey, skinValue in pairs(outfitPart) do
                flatSkin[skinKey] = skinValue
                hasSkinValues = true
            end
        end
    end
    if hasSkinValues then
        if Bridge and Bridge.Config and Bridge.Config.Debug then
            lib.print.info("Applying outfit skin", flatSkin)
        end
        TriggerEvent("skinchanger:loadSkin", flatSkin)
        Citizen.Wait(10)
        Ped:update()
    end
end

function Skin.updateClothes(self, skinData)
    skinUpdateEnabled = true
    local clothesPayload = {}
    local clothingSlots = lib.table.deepclone(Config.ClothingSlots)
    local playerSex = Clothes:getSex()
    if not playerSex then
        return
    end
    for slotIndex, slotConfig in pairs(clothingSlots) do
        local sexSkin = slotConfig.skin and slotConfig.skin[playerSex]
        if sexSkin and slotConfig.itemName then
            if not clothesPayload[slotConfig.itemName] then
                clothesPayload[slotConfig.itemName] = {
                    slot = slotIndex,
                    skin = slotConfig.skin[playerSex],
                }
            end
            for skinKey, _ in pairs(sexSkin) do
                clothesPayload[slotConfig.itemName].skin[skinKey] = skinData[skinKey] or -1
            end
        end
    end
    TriggerServerEvent("p_itemclothes/server/updateClothes", clothesPayload)
end

function Skin.saveSkin(self)
    if self.saveThread then
        self.saveTimer = GetGameTimer() + 2000
        return
    end
    self.saveThread = true
    self.saveTimer = GetGameTimer() + 1500
    while self.saveTimer > GetGameTimer() do
        Citizen.Wait(100)
    end
    self.saveThread = false
    TriggerEvent("rcore_clothing:saveCurrentSkin")
end

function requestSkinchangerSkin()
    local skinData = nil
    TriggerEvent("skinchanger:getSkin", function(callbackSkin)
        skinData = callbackSkin
    end)
    while skinData == nil do
        Citizen.Wait(10)
    end
    return skinData
end

RegisterNetEvent("p_itemclothes/client/updateClothes", function(skinData)
    Skin:updateClothes(skinData)
end)

local playerSpawnEvents = {
    "esx:playerLoaded",
    "QBCore:Client:OnPlayerLoaded",
    "ND:characterLoaded",
    "ox:playerLoaded",
}

for _, eventName in pairs(playerSpawnEvents) do
    RegisterNetEvent(eventName, function()
        if Config.DisableItemsOverrideOnSpawn then
            return
        end
        Citizen.Wait(1000)
        local outfitSkin = getOutfitFromSlot()
        if outfitSkin then
            skinUpdateEnabled = true
            applyOutfitSkin(outfitSkin)
            return
        end
        local skinData = requestSkinchangerSkin()
        if Bridge and Bridge.Config and Bridge.Config.Debug then
            lib.print.info("Updating clothes on event", eventName)
        end
        Skin:updateClothes(skinData)
    end)
end

local rcoreClothingEvents = {
    "rcore_clothing:charcreator:done",
    "rcore_clothing:onClothingShopClosed",
}

for _, eventName in pairs(rcoreClothingEvents) do
    RegisterNetEvent(eventName, function()
        Citizen.Wait(1000)
        local skinData = requestSkinchangerSkin()
        if Bridge and Bridge.Config and Bridge.Config.Debug then
            lib.print.info("Updating clothes on event", eventName)
        end
        Skin:updateClothes(skinData)
    end)
end

AddEventHandler("rcore_clothing:onClothingShopOpened", function()
    TriggerEvent("skinchanger:getSkin", function(callbackSkin)
        shopSkinBackup = callbackSkin
    end)
end)

AddEventHandler("rcore_clothing:onClothingShopClosed", function()
    if shopSkinBackup and restoreOutfitAfterShop then
        Citizen.Wait(100)
        TriggerEvent("skinchanger:loadSkin", shopSkinBackup)
        shopSkinBackup = nil
    end
    restoreOutfitAfterShop = false
end)

RegisterNetEvent("rcore_clothing:outfitChanged", function()
    Citizen.Wait(1)
    restoreOutfitAfterShop = true
    local skinData = requestSkinchangerSkin()
    TriggerServerEvent("p_itemclothes/server/giveOutfitItem", skinData)
    if shopSkinBackup then
        Citizen.Wait(10)
        TriggerEvent("skinchanger:loadSkin", shopSkinBackup)
        Citizen.Wait(100)
        TriggerEvent("rcore_clothing:saveCurrentSkin")
    end
end)

RegisterNetEvent("p_itemclothes/client/applyOutfitVisual", function(outfitData)
    if not outfitData then
        return
    end
    Citizen.Wait(10)
    applyOutfitSkin(outfitData)
end)

function Skin.waitForInventoryDebounce(self)
    if not self.timerThread then
        self.timerThread = true
        self.timer = GetGameTimer() + 100
        while self.timer > GetGameTimer() do
            Citizen.Wait(10)
        end
    else
        self.timer = GetGameTimer() + 100
        return false
    end
    self.timerThread = false
    return true
end

AddEventHandler("ox_inventory:updateInventory", function(inventoryChanges)
    if not skinUpdateEnabled then
        skinUpdateEnabled = true
        return
    end
    local outfitSlot = getOutfitInventorySlot()
    local outfitSlotChanged = inventoryChanges[outfitSlot] ~= nil
    local clothingSlotChanged = false
    for slotId in pairs(inventoryChanges) do
        if Config.ClothingSlots[tonumber(slotId)] then
            clothingSlotChanged = true
            break
        end
    end
    if not clothingSlotChanged and not outfitSlotChanged then
        return
    end
    if not Skin:waitForInventoryDebounce() then
        return
    end
    local outfitSkin = getOutfitFromSlot()
    if outfitSkin then
        applyOutfitSkin(outfitSkin)
        return
    end
    local hasSkinChanges = false
    local currentSkin = requestSkinchangerSkin()
    local skinChanges = {}
    local playerItems = exports.ox_inventory:GetPlayerItems()
    for slotId, slotConfig in pairs(Config.ClothingSlots) do
        local slotItem = playerItems[tonumber(slotId)]
        if slotItem and slotItem.metadata then
            for metadataKey, metadataValue in pairs(slotItem.metadata) do
                if currentSkin[metadataKey] ~= metadataValue then
                    skinChanges[metadataKey] = metadataValue
                    hasSkinChanges = true
                end
            end
        else
            local defaultSkin = slotConfig.skin[Clothes:getSex()] or {}
            for skinKey, skinValue in pairs(defaultSkin) do
                if currentSkin[skinKey] ~= skinValue then
                    skinChanges[skinKey] = skinValue
                    hasSkinChanges = true
                end
                if skinKey:find("mask") and Clothes.cacheFace then
                    Clothes:toggleFace()
                    hasSkinChanges = true
                elseif skinKey:find("helmet") and Clothes.cacheHair then
                    Clothes:toggleHair()
                    hasSkinChanges = true
                end
            end
        end
    end
    if hasSkinChanges then
        if Bridge and Bridge.Config and Bridge.Config.Debug then
            lib.print.info("Updated skin data", skinChanges)
        end
        Citizen.Wait(1)
        TriggerEvent("skinchanger:loadSkin", skinChanges)
        Citizen.Wait(1)
        Ped:update()
        Skin:saveSkin()
    end
end)
