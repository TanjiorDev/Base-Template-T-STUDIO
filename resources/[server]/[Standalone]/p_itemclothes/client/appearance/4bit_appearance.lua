while not Config or not Config.Appearance do
    Citizen.Wait(100)
end

if Config.Appearance ~= "4bit_appearance" then
    return
end

Skin = {}
Skin.timer = GetGameTimer()
Skin.timerThread = false
Skin.saveTimer = GetGameTimer()
Skin.saveThread = false
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

function getDrawableTextureKey(drawableKey)
    if drawableKey == "arms" then
        return "arms_2"
    end
    return drawableKey:gsub("_1", "_2")
end

function Skin.convert(self, appearanceData)
    local convertedSkin = {}
    for _, component in pairs(appearanceData.components) do
        local componentMapping = self.components[tostring(component.component_id)]
        if componentMapping then
            convertedSkin[componentMapping[1]] = {
                id = component.drawable,
                component = component.component_id,
            }
            convertedSkin[componentMapping[2]] = {
                id = component.texture,
                component = component.component_id,
            }
        end
    end
    for _, prop in pairs(appearanceData.props) do
        local propMapping = self.props[tostring(prop.prop_id)]
        if propMapping then
            convertedSkin[propMapping[1]] = {
                id = prop.drawable,
                component = prop.prop_id,
                prop = true,
            }
            convertedSkin[propMapping[2]] = {
                id = prop.texture,
                component = prop.prop_id,
                prop = true,
            }
        end
    end
    return convertedSkin
end

function Skin.updateClothes(self)
    local clothesPayload = {}
    local pedProps = exports["4bit_appearance"]:getPedProps(cache.ped)
    local pedComponents = exports["4bit_appearance"]:getPedComponents(cache.ped)
    local convertedSkin = self:convert({ props = pedProps, components = pedComponents })
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
        lib.print.info("Clothing data to save:", clothesPayload)
        lib.print.info("Current skin:", pedProps, pedComponents)
        lib.print.info("Converted skin:", convertedSkin)
        lib.print.info("Invoking resource", GetInvokingResource() or "N/A")
    end
    TriggerServerEvent("p_itemclothes/server/updateClothes", clothesPayload)
end

function Skin.saveSkin(self)
    if self.saveThread then
        self.saveTimer = GetGameTimer() + 1250
        return
    end
    self.saveThread = true
    self.saveTimer = GetGameTimer() + 1500
    while self.saveTimer > GetGameTimer() do
        Citizen.Wait(100)
    end
    self.saveThread = false
    TriggerServerEvent(
        "illenium-appearance:server:saveAppearance",
        exports["4bit_appearance"]:getPedAppearance(cache.ped)
    )
end

RegisterNetEvent("p_itemclothes/client/updateClothes", function()
    Citizen.Wait(10)
    skinUpdateEnabled = true
    Skin:updateClothes()
end)

function buildAppearanceComponentChange(convertedEntry, drawableId, textureId)
    if convertedEntry.prop then
        return {
            prop_id = convertedEntry.component,
            drawable = drawableId,
            texture = textureId,
        }
    end
    return {
        component_id = convertedEntry.component,
        drawable = drawableId,
        texture = textureId,
    }
end

function applyAppearanceSlotChanges(convertedSkin, componentsToSet, propsToSet, slotItem, defaultSkin)
    local slotChanged = false
    if slotItem and slotItem.metadata then
        for metadataKey, metadataValue in pairs(slotItem.metadata) do
            if not metadataKey:find("_2") then
                local convertedEntry = convertedSkin[metadataKey]
                if convertedEntry and convertedEntry.id ~= metadataValue then
                    local textureKey = getDrawableTextureKey(metadataKey)
                    local changeData = buildAppearanceComponentChange(
                        convertedEntry,
                        metadataValue,
                        slotItem.metadata[textureKey] or 0
                    )
                    if convertedEntry.prop then
                        propsToSet[#propsToSet + 1] = changeData
                    else
                        componentsToSet[#componentsToSet + 1] = changeData
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
                    local changeData = buildAppearanceComponentChange(
                        convertedEntry,
                        skinValue,
                        defaultSkin[textureKey] or 0
                    )
                    if convertedEntry.prop then
                        propsToSet[#propsToSet + 1] = changeData
                    else
                        componentsToSet[#componentsToSet + 1] = changeData
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
        skinUpdateEnabled = true
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
            Citizen.Wait(100)
        end
    else
        Skin.timer = GetGameTimer() + 100
        return
    end
    Skin.timerThread = false
    local hasAppearanceChanges = false
    local pedProps = exports["4bit_appearance"]:getPedProps(cache.ped)
    local pedComponents = exports["4bit_appearance"]:getPedComponents(cache.ped)
    local convertedSkin = Skin:convert({ props = pedProps, components = pedComponents })
    local componentsToSet = {}
    local propsToSet = {}
    local playerItems = exports.ox_inventory:GetPlayerItems()
    for slotId, slotConfig in pairs(Config.ClothingSlots) do
        local slotItem = playerItems[tonumber(slotId)]
        local defaultSkin = slotConfig.skin and slotConfig.skin[Clothes:getSex()]
        if applyAppearanceSlotChanges(convertedSkin, componentsToSet, propsToSet, slotItem, defaultSkin) then
            hasAppearanceChanges = true
        end
    end
    if hasAppearanceChanges then
        exports["4bit_appearance"]:setPedComponents(cache.ped, componentsToSet)
        exports["4bit_appearance"]:setPedProps(cache.ped, propsToSet)
        Citizen.Wait(1)
        Ped:update()
        Skin:saveSkin()
    end
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
        local spawnDelay = Config["17MovAppearance"] and 3000 or 2500
        Citizen.Wait(spawnDelay)
        if Config.WaitForLoad then
            while not Bridge.Framework.isPlayerLoaded() do
                Citizen.Wait(100)
            end
        end
        Skin:updateClothes()
    end)
end

RegisterNetEvent("17mov_CharacterSystem:SkinMenuClosed", function()
    Citizen.Wait(500)
    Skin:updateClothes()
end)

Citizen.CreateThread(function()
    exports["4bit_appearance"]:addHook("onMenuClose", function()
        Citizen.Wait(2000)
        TriggerEvent("p_itemclothes/client/updateClothes")
    end)
end)
