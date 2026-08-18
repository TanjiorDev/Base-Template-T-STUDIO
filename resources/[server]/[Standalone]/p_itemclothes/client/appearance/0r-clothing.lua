while not Config or not Config.Appearance do
    Citizen.Wait(100)
end

if Config.Appearance ~= "0r-clothing" then
    return
end

Skin = {}
Skin.timer = GetGameTimer()
Skin.timerThread = false
Skin.saveTimer = GetGameTimer()
Skin.saveThread = false
skinUpdateEnabled = false

Skin.components = {
    hat = "helmet_1",
    mask = "mask_1",
    glass = "glasses_1",
    ear = "ears_1",
    undershirt = "tshirt_1",
    jacket = "torso_1",
    decals = "decals_1",
    arms = "arms",
    pants = "pants_1",
    shoes = "shoes_1",
    bag = "bags_1",
    vest = "bproof_1",
    accessory = "chain_1",
    watch = "watches_1",
    bracelet = "bracelets_1",
}

Skin.components2 = {
    helmet_1 = "hat",
    mask_1 = "mask",
    glasses_1 = "glass",
    ears_1 = "ear",
    tshirt_1 = "undershirt",
    torso_1 = "jacket",
    decals_1 = "decals",
    arms = "arms/gloves",
    pants_1 = "pants",
    shoes_1 = "shoes",
    bags_1 = "bag",
    bproof_1 = "vest",
    chain_1 = "accessory",
    watches_1 = "watch",
    bracelets_1 = "bracelet",
}

function getDrawableTextureKey(drawableKey)
    if drawableKey == "arms" then
        return "arms_2"
    end
    return drawableKey:gsub("_1", "_2")
end

function Skin.convert(self, outfitData)
    local convertedSkin = {}
    for outfitKey, drawableKey in pairs(self.components) do
        if outfitData[outfitKey] then
            if type(outfitData[outfitKey]) == "number" then
                local textureKey = getDrawableTextureKey(drawableKey)
                convertedSkin[drawableKey] = outfitData[outfitKey]
                convertedSkin[textureKey] = outfitData[textureKey] or 0
            else
                convertedSkin[drawableKey] = outfitData[outfitKey].item
                convertedSkin[getDrawableTextureKey(drawableKey)] = outfitData[outfitKey].texture
            end
        end
    end
    return convertedSkin
end

function Skin.updateClothes(self, outfitData)
    if not outfitData then
        outfitData = exports["0r-clothing"]:getPlayerClothing()
    end
    while not loadedClothingSlots do
        Citizen.Wait(100)
    end
    skinUpdateEnabled = true
    local clothesPayload = {}
    local clothingSlots = lib.table.deepclone(Config.ClothingSlots)
    local convertedSkin = self:convert(outfitData)
    local playerSex = Clothes:getSex()
    if Bridge and Bridge.Config and Bridge.Config.Debug then
        lib.print.info("Clothing slots", clothingSlots)
        lib.print.info("Converted skin", convertedSkin)
    end
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
                clothesPayload[slotConfig.itemName].skin[skinKey] = convertedSkin[skinKey] or -1
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
    self.saveTimer = GetGameTimer() + 2000
    while self.saveTimer > GetGameTimer() do
        Citizen.Wait(100)
    end
    self.saveThread = false
    local playerClothing = exports["0r-clothing"]:getPlayerClothing()
    TriggerEvent("0r-clothing:loadOutfit:client", { outfitData = playerClothing })
    TriggerServerEvent("qb-clothing:saveSkin", GetEntityModel(cache.ped), json.encode(playerClothing))
end

RegisterNetEvent("p_itemclothes/client/updateClothes", function(outfitData)
    Skin:updateClothes(outfitData)
end)

function applyInventoryOutfitSlot(outfitData, convertedSkin, slotItem, defaultSkin)
    local slotChanged = false
    if slotItem and slotItem.metadata then
        for metadataKey, metadataValue in pairs(slotItem.metadata) do
            if not metadataKey:find("_2") and convertedSkin[metadataKey] ~= metadataValue then
                local outfitKey = Skin.components2[metadataKey]
                outfitData[outfitKey] = {
                    item = metadataValue,
                    texture = slotItem.metadata[getDrawableTextureKey(metadataKey)] or 0,
                }
                slotChanged = true
            end
        end
    elseif defaultSkin then
        for skinKey, skinValue in pairs(defaultSkin) do
            if not skinKey:find("_2") and convertedSkin[skinKey] ~= skinValue then
                local outfitKey = Skin.components2[skinKey]
                outfitData[outfitKey] = {
                    item = skinValue,
                    texture = defaultSkin[getDrawableTextureKey(skinKey)] or 0,
                }
                slotChanged = true
            end
            if skinKey:find("mask") and Clothes.cacheFace then
                Clothes:toggleFace()
                slotChanged = true
            elseif skinKey:find("helmet") and Clothes.cacheHair then
                Clothes:toggleHair()
                slotChanged = true
            end
        end
    end
    return slotChanged
end

AddEventHandler("ox_inventory:updateInventory", function(inventoryChanges)
    if not skinUpdateEnabled then
        return
    end
    while not loadedClothingSlots do
        Citizen.Wait(100)
    end
    local clothingSlotChanged = false
    for slotId in pairs(inventoryChanges) do
        if Config.ClothingSlots[tonumber(slotId)] then
            clothingSlotChanged = true
            break
        end
    end
    if not clothingSlotChanged then
        return
    end
    if not Skin.timerThread then
        Skin.timerThread = true
        Skin.timer = GetGameTimer() + 100
        while Skin.timer > GetGameTimer() do
            Citizen.Wait(10)
        end
    else
        Skin.timer = GetGameTimer() + 100
        return
    end
    Skin.timerThread = false
    local hasOutfitChanges = false
    local outfitData = exports["0r-clothing"]:getPlayerClothing()
    local convertedSkin = Skin:convert(outfitData)
    local playerItems = exports.ox_inventory:GetPlayerItems()
    for slotId, slotConfig in pairs(Config.ClothingSlots) do
        local slotItem = playerItems[tonumber(slotId)]
        local defaultSkin = slotConfig.skin and slotConfig.skin[Clothes:getSex()]
        if applyInventoryOutfitSlot(outfitData, convertedSkin, slotItem, defaultSkin) then
            hasOutfitChanges = true
        end
    end
    if hasOutfitChanges then
        TriggerEvent("0r-clothing:loadOutfit:client", { outfitData = outfitData })
        Citizen.Wait(1)
        Ped:update()
        Skin:saveSkin()
    end
end)

AddEventHandler("qb-clothing:client:loadPlayerClothing", function(skinData, targetPed)
    if not skinData or not next(skinData) then
        return
    end
    Citizen.Wait(1000)
    if targetPed ~= PlayerPedId() then
        return
    end
    Skin:updateClothes(skinData)
end)

AddEventHandler("0r-clothing:client:loadPlayerClothing", function(_, targetPed)
    local invokingResource = GetInvokingResource() or GetCurrentResourceName()
    if invokingResource == GetCurrentResourceName() then
        return
    end
    if targetPed ~= PlayerPedId() then
        return
    end
    Citizen.Wait(1000)
    local playerClothing = exports["0r-clothing"]:getPlayerClothing()
    if not playerClothing or not next(playerClothing) then
        return
    end
    Skin:updateClothes(playerClothing)
end)
