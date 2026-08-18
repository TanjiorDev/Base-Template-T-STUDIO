while not Config or not Config.Appearance do
    Citizen.Wait(100)
end

if Config.Appearance ~= "crm-appearance" then
    return
end

Skin = {}
Skin.saveThread = false
Skin.saveTimer = GetGameTimer()
skinUpdateEnabled = false

Skin.components = {
    ["1"] = { "mask_1", "mask_2" },
    ["3"] = { "arms", "arms_2" },
    ["4"] = { "pants_1", "pants_2" },
    ["5"] = { "bags_1", "bags_2" },
    ["6"] = { "shoes_1", "shoes_2" },
    ["7"] = { "chain_1", "chain_2" },
    ["8"] = { "tshirt_1", "tshirt_2" },
    ["9"] = { "bproof_1", "bproof_2" },
    ["10"] = { "decals_1", "decals_2" },
    ["11"] = { "torso_1", "torso_2" },
}

Skin.props = {
    ["0"] = { "helmet_1", "helmet_2" },
    ["1"] = { "glasses_1", "glasses_2" },
    ["2"] = { "ears_1", "ears_2" },
    ["6"] = { "watches_1", "watches_2" },
    ["7"] = { "bracelets_1", "bracelets_2" },
}

Skin.timer = GetGameTimer()
Skin.timerThread = false

function getDrawableTextureKey(drawableKey)
    if drawableKey == "arms" then
        return "arms_2"
    end
    return drawableKey:gsub("_1", "_2")
end

function Skin.convert(self, appearanceData)
    local convertedSkin = {}
    for _, clothingItem in pairs(appearanceData.crm_clothing) do
        local componentMapping = self.components[tostring(clothingItem.crm_id)]
        if componentMapping then
            convertedSkin[componentMapping[1]] = {
                id = clothingItem.crm_style,
                component = clothingItem.crm_id,
            }
            convertedSkin[componentMapping[2]] = {
                id = clothingItem.crm_texture,
                component = clothingItem.crm_id,
            }
        end
    end
    for _, accessoryItem in pairs(appearanceData.crm_accessories) do
        local propMapping = self.props[tostring(accessoryItem.crm_id)]
        if propMapping then
            convertedSkin[propMapping[1]] = {
                id = accessoryItem.crm_style,
                component = accessoryItem.crm_id,
                prop = true,
            }
            convertedSkin[propMapping[2]] = {
                id = accessoryItem.crm_texture,
                component = accessoryItem.crm_id,
                prop = true,
            }
        end
    end
    return convertedSkin
end

function Skin.updateClothes(self, appearanceData)
    skinUpdateEnabled = true
    local clothesPayload = {}
    local convertedSkin = self:convert(appearanceData)
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
                local convertedValue = convertedSkin[skinKey]
                clothesPayload[slotConfig.itemName].skin[skinKey] = convertedValue and convertedValue.id or -1
            end
        end
    end
    if Bridge and Bridge.Config and Bridge.Config.Debug then
        lib.print.info("Skin:updateClothes", clothesPayload)
        lib.print.info("updating clothes items")
    end
    TriggerServerEvent("p_itemclothes/server/updateClothes", clothesPayload)
end

function Skin.save(self)
    if self.saveThread then
        self.saveTimer = GetGameTimer() + 2000
        return
    end
    self.saveThread = true
    self.saveTimer = GetGameTimer() + 2500
    while self.saveTimer > GetGameTimer() do
        Citizen.Wait(10)
    end
    self.saveThread = false
    exports["crm-appearance"]:crm_save_appearance(nil, function() end, true)
end

RegisterNetEvent("p_itemclothes/client/updateClothes", function(appearanceData)
    Citizen.Wait(10)
    Skin:updateClothes(appearanceData)
end)

function buildCrmAppearanceChange(convertedEntry, drawableId, textureId)
    if convertedEntry.prop then
        return {
            crm_id = convertedEntry.component,
            crm_style = drawableId,
            crm_texture = textureId,
        }
    end
    return {
        crm_id = convertedEntry.component,
        crm_style = drawableId,
        crm_texture = textureId,
    }
end

function applyCrmSlotChanges(convertedSkin, clothingChanges, accessoryChanges, slotItem, defaultSkin)
    local slotChanged = false
    if slotItem and type(slotItem) == "table" and slotItem.metadata then
        for metadataKey, metadataValue in pairs(slotItem.metadata) do
            if not metadataKey:find("_2") then
                local convertedEntry = convertedSkin[metadataKey]
                if convertedEntry and convertedEntry.id ~= metadataValue then
                    local textureKey = getDrawableTextureKey(metadataKey)
                    local textureValue = slotItem.metadata[textureKey] or 0
                    local changeData = buildCrmAppearanceChange(convertedEntry, metadataValue, textureValue)
                    if convertedEntry.prop then
                        accessoryChanges[#accessoryChanges + 1] = changeData
                    else
                        clothingChanges[#clothingChanges + 1] = changeData
                    end
                    slotChanged = true
                end
            end
        end
    elseif defaultSkin then
        for skinKey, skinValue in pairs(defaultSkin) do
            if not skinKey:find("_2") then
                local convertedEntry = convertedSkin[skinKey]
                if convertedEntry and convertedEntry.id ~= skinValue then
                    local textureKey = getDrawableTextureKey(skinKey)
                    local textureValue = defaultSkin[textureKey] or 0
                    local changeData = buildCrmAppearanceChange(convertedEntry, skinValue, textureValue)
                    if convertedEntry.prop then
                        accessoryChanges[#accessoryChanges + 1] = changeData
                    else
                        clothingChanges[#clothingChanges + 1] = changeData
                    end
                    slotChanged = true
                end
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
    Citizen.Wait(1)
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
    local hasAppearanceChanges = false
    local pedAccessories = exports["crm-appearance"]:crm_get_ped_accessories(cache.ped)
    local pedClothing = exports["crm-appearance"]:crm_get_ped_clothing(cache.ped)
    local convertedSkin = Skin:convert({
        crm_accessories = pedAccessories,
        crm_clothing = pedClothing,
    })
    local clothingChanges = {}
    local accessoryChanges = {}
    local playerItems = exports.ox_inventory:GetPlayerItems()
    for slotId, slotConfig in pairs(Config.ClothingSlots) do
        local slotItem = playerItems[tonumber(slotId)]
        local defaultSkin = slotConfig.skin and slotConfig.skin[Clothes:getSex()]
        if applyCrmSlotChanges(convertedSkin, clothingChanges, accessoryChanges, slotItem, defaultSkin) then
            hasAppearanceChanges = true
        end
    end
    if hasAppearanceChanges then
        exports["crm-appearance"]:crm_set_ped_clothing(cache.ped, clothingChanges)
        exports["crm-appearance"]:crm_set_ped_accessories(cache.ped, accessoryChanges)
        Citizen.Wait(1)
        Ped:update()
        Skin:save()
    end
end)

local crmSpawnEvents = {
    "esx:playerLoaded",
    "QBCore:Client:OnPlayerLoaded",
    "ND:characterLoaded",
    "ox:playerLoaded",
    "crm-appearance:outfit-changed",
}

for _, eventName in pairs(crmSpawnEvents) do
    RegisterNetEvent(eventName, function()
        Citizen.Wait(2000)
        Skin:updateClothes(exports["crm-appearance"]:crm_get_ped_appearance(cache.ped))
    end)
end
