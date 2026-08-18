while not Config or not Config.Appearance do
    Citizen.Wait(100)
end

if Config.Appearance ~= "qb-clothing" then
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
    ["t-shirt"] = "tshirt_1",
    torso2 = "torso_1",
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
    tshirt_1 = "t-shirt",
    torso_1 = "torso2",
    decals_1 = "decals",
    arms = "arms",
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
            convertedSkin[drawableKey] = outfitData[outfitKey].item
            convertedSkin[getDrawableTextureKey(drawableKey)] = outfitData[outfitKey].texture
        end
    end
    return convertedSkin
end

function Skin.updateClothes(self, outfitData)
    skinUpdateEnabled = true
    local clothesPayload = {}
    local clothingSlots = lib.table.deepclone(Config.ClothingSlots)
    local convertedSkin = self:convert(outfitData)
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
    TriggerServerEvent(
        "qb-clothing:saveSkin",
        GetEntityModel(cache.ped),
        json.encode(exports["qb-clothing"]:GetSkinData())
    )
end

RegisterNetEvent("p_itemclothes/client/updateClothes", function(outfitData)
    Skin:updateClothes(outfitData)
end)

function applySlotOutfitChange(convertedSkin, outfitChanges, slotItem, defaultSkin)
    local slotChanged = false
    if slotItem and slotItem.metadata then
        for metadataKey, metadataValue in pairs(slotItem.metadata) do
            if not metadataKey:find("_2") and convertedSkin[metadataKey] ~= metadataValue then
                local outfitKey = Skin.components2[metadataKey]
                outfitChanges[outfitKey] = {
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
                outfitChanges[outfitKey] = {
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
    local convertedSkin = Skin:convert(exports["qb-clothing"]:GetSkinData())
    local playerItems = exports.ox_inventory:GetPlayerItems()
    local outfitChanges = {}
    for slotId, slotConfig in pairs(Config.ClothingSlots) do
        local slotItem = playerItems[tonumber(slotId)]
        local defaultSkin = slotConfig.skin and slotConfig.skin[Clothes:getSex()]
        if applySlotOutfitChange(convertedSkin, outfitChanges, slotItem, defaultSkin) then
            hasOutfitChanges = true
        end
    end
    if hasOutfitChanges then
        TriggerEvent("qb-clothing:client:loadOutfit", { outfitData = outfitChanges })
        Citizen.Wait(1)
        Ped:update()
        Skin:saveSkin()
    end
end)

AddEventHandler("qb-clothing:client:loadOutfit", function(outfitPayload)
    local invokingResource = GetInvokingResource() or GetCurrentResourceName()
    if invokingResource == GetCurrentResourceName() then
        return
    end
    if not outfitPayload or not outfitPayload.outfitData or not next(outfitPayload.outfitData) then
        return
    end
    Citizen.Wait(100)
    Skin:updateClothes(exports["qb-clothing"]:GetSkinData())
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
