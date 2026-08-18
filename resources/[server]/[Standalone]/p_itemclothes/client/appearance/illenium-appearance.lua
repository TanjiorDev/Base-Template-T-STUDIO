if not Config or Config.Appearance ~= "illenium-appearance" then
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

local function readSkinFromPed(ped)
    local skin = {
        ['mask_1'] = GetPedDrawableVariation(ped, 1),
        ['mask_2'] = GetPedTextureVariation(ped, 1),
        ['arms'] = GetPedDrawableVariation(ped, 3),
        ['arms_2'] = GetPedTextureVariation(ped, 3),
        ['pants_1'] = GetPedDrawableVariation(ped, 4),
        ['pants_2'] = GetPedTextureVariation(ped, 4),
        ['bags_1'] = GetPedDrawableVariation(ped, 5),
        ['bags_2'] = GetPedTextureVariation(ped, 5),
        ['shoes_1'] = GetPedDrawableVariation(ped, 6),
        ['shoes_2'] = GetPedTextureVariation(ped, 6),
        ['chain_1'] = GetPedDrawableVariation(ped, 7),
        ['chain_2'] = GetPedTextureVariation(ped, 7),
        ['tshirt_1'] = GetPedDrawableVariation(ped, 8),
        ['tshirt_2'] = GetPedTextureVariation(ped, 8),
        ['bproof_1'] = GetPedDrawableVariation(ped, 9),
        ['bproof_2'] = GetPedTextureVariation(ped, 9),
        ['torso_1'] = GetPedDrawableVariation(ped, 11),
        ['torso_2'] = GetPedTextureVariation(ped, 11),
        ['helmet_1'] = GetPedPropIndex(ped, 0),
        ['helmet_2'] = GetPedPropTextureIndex(ped, 0),
        ['glasses_1'] = GetPedPropIndex(ped, 1),
        ['glasses_2'] = GetPedPropTextureIndex(ped, 1),
        ['ears_1'] = GetPedPropIndex(ped, 2),
        ['ears_2'] = GetPedPropTextureIndex(ped, 2),
        ['watches_1'] = GetPedPropIndex(ped, 6),
        ['watches_2'] = GetPedPropTextureIndex(ped, 6),
        ['bracelets_1'] = GetPedPropIndex(ped, 7),
        ['bracelets_2'] = GetPedPropTextureIndex(ped, 7),
    }
    return skin
end

function getDrawableTextureKey(drawableKey)
    if drawableKey == "arms" then
        return "arms_2"
    end
    return drawableKey:gsub("_1", "_2")
end

local propSkinKeys = {
    helmet_1 = true,
    glasses_1 = true,
    ears_1 = true,
    watches_1 = true,
    bracelets_1 = true,
}

local function getFirstClothingSlot()
    return exports.ox_inventory:getPlayerInvSlots() - 14 + 1
end

local function getUnequippedSkinValue(skinKey, configValue)
    if propSkinKeys[skinKey] and configValue == 0 then
        return -1
    end

    return configValue
end

local function isClothingItemInRegularInventory(playerItems, itemName)
    local firstClothingSlot = getFirstClothingSlot()

    for slotId, item in pairs(playerItems) do
        local slot = tonumber(slotId)

        if slot and slot < firstClothingSlot and item.name == itemName then
            return true
        end
    end

    return false
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

local function waitForClothingSlots()
    while not loadedClothingSlots do
        Wait(50)
    end
end

local function syncClothingItems()
    if Config.Appearance ~= 'illenium-appearance' then
        return
    end

    waitForClothingSlots()

    if not next(Config.ClothingSlots) then
        lib.print.error('p_itemclothes: clothing slots are empty, retrying remap')
        loadedClothingSlots = false
        loadClothesSlots()
        waitForClothingSlots()
    end

    skinUpdateEnabled = true
    Skin:updateClothes()
end

function Skin.updateClothes(self)
    waitForClothingSlots()

    local clothesPayload = {}
    local pedSkin = readSkinFromPed(cache.ped)
    local clothingSlots = lib.table.deepclone(Config.ClothingSlots)
    local playerItems = exports.ox_inventory:GetPlayerItems()
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
                    skin = lib.table.deepclone(slotConfig.skin[playerSex]),
                }
            end

            local slotItem = playerItems[slotIndex]
            local useDefaultSkin = (not slotItem or slotItem.count == 0)
                and isClothingItemInRegularInventory(playerItems, slotConfig.itemName)

            for skinKey, defaultValue in pairs(sexSkin) do
                if useDefaultSkin then
                    clothesPayload[slotConfig.itemName].skin[skinKey] = getUnequippedSkinValue(skinKey, defaultValue)
                else
                    clothesPayload[slotConfig.itemName].skin[skinKey] = pedSkin[skinKey] or -1
                end
            end
        end
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
    if Config["17MovAppearance"] then
        TriggerEvent("17mov_CharacterSystem:SaveCurrentSkin")
    else
        TriggerServerEvent(
            "illenium-appearance:server:saveAppearance",
            exports["illenium-appearance"]:getPedAppearance(cache.ped)
        )
    end
end

RegisterNetEvent("p_itemclothes/client/updateClothes", function()
    if Config.WaitForLoad and Bridge and Bridge.Framework and not Bridge.Framework.isPlayerLoaded() then
        return
    end
    Wait(10)
    syncClothingItems()
end)

RegisterNetEvent('ox_inventory:setPlayerInventory', function()
    SetTimeout(750, syncClothingItems)
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
                    local textureValue = slotItem.metadata[textureKey] or 0
                    local changeData = buildAppearanceComponentChange(convertedEntry, metadataValue, textureValue)
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
                local unequippedValue = getUnequippedSkinValue(skinKey, skinValue)
                if convertedEntry and convertedEntry.id ~= unequippedValue then
                    local textureKey = getDrawableTextureKey(skinKey)
                    local textureValue = defaultSkin[textureKey] or 0
                    local changeData = buildAppearanceComponentChange(convertedEntry, unequippedValue, textureValue)
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
    local pedProps = exports["illenium-appearance"]:getPedProps(cache.ped)
    local pedComponents = exports["illenium-appearance"]:getPedComponents(cache.ped)
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
        exports["illenium-appearance"]:setPedComponents(cache.ped, componentsToSet)
        exports["illenium-appearance"]:setPedProps(cache.ped, propsToSet)
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
        if Config.WaitForLoad and Bridge and Bridge.Framework then
            while not Bridge.Framework.isPlayerLoaded() do
                Wait(100)
            end
        end
        syncClothingItems()
    end)
end

RegisterNetEvent("17mov_CharacterSystem:PlayerSpawned", function()
    Citizen.Wait(4000)
    if Bridge and Bridge.Config and Bridge.Config.Debug then
        lib.print.info("Player spawned")
    end
    skinUpdateEnabled = true
end)

RegisterNetEvent("17mov_CharacterSystem:SkinMenuClosed", function()
    Wait(500)
    syncClothingItems()
end)

RegisterCommand('syncclothes', function()
    syncClothingItems()
    lib.notify({
        title = 'p_itemclothes',
        description = 'Clothing sync requested',
        type = 'inform',
    })
end, false)

AddEventHandler('p_itemclothes:syncClothes', syncClothingItems)

AddEventHandler('p_itemclothes:togglePed', function(enabled)
    if enabled then
        skinUpdateEnabled = true
    end
end)

exports('syncClothingItems', syncClothingItems)
