Bridge = nil
if GetResourceState('p_bridge') == 'started' then
    local ok, bridge = pcall(function()
        return exports.p_bridge:getObject()
    end)
    if ok then
        Bridge = bridge
    end
end

loadedClothingSlots = false

Clothes = {}
Clothes.cacheHair = nil
Clothes.cacheFace = nil
Clothes.faceFeatures = {}
Clothes.trackThread = false

lib.locale()

exports("getClothingSlots", function()
    return Config.ClothingSlots
end)

function Clothes.getSex(self)
    if GetEntityModel(cache.ped) == 1885233650 then
        return "male"
    end
    return "female"
end

function Clothes.getHeadBlendData(self, ped)
    if GetResourceState('illenium-appearance') == 'started' then
        local ok, headBlend = pcall(function()
            return exports['illenium-appearance']:getPedHeadBlend(ped)
        end)

        if ok and headBlend then
            return headBlend
        end
    end

    local shapeFirst, shapeSecond, shapeThird, skinFirst, skinSecond, skinThird, shapeMix, skinMix, thirdMix =
        Citizen.InvokeNative(
            0x2746BD9D88C5C5D0,
            ped,
            Citizen.PointerValueIntInitialized(0),
            Citizen.PointerValueIntInitialized(0),
            Citizen.PointerValueIntInitialized(0),
            Citizen.PointerValueIntInitialized(0),
            Citizen.PointerValueIntInitialized(0),
            Citizen.PointerValueIntInitialized(0),
            Citizen.PointerValueFloatInitialized(0),
            Citizen.PointerValueFloatInitialized(0),
            Citizen.PointerValueFloatInitialized(0)
        )

    return {
        shapeFirst = shapeFirst or 0,
        shapeSecond = shapeSecond or 0,
        shapeThird = shapeThird or 0,
        skinFirst = skinFirst or 0,
        skinSecond = skinSecond or 0,
        skinThird = skinThird or 0,
        shapeMix = shapeMix or 0.0,
        skinMix = skinMix or 0.0,
        thirdMix = thirdMix or 0.0,
    }
end

function Clothes.shrinkFaceFeatures(self)
    for featureIndex = 0, 19 do
        if not self.faceFeatures[featureIndex] then
            self.faceFeatures[featureIndex] = GetPedFaceFeature(cache.ped, featureIndex)
        end
        SetPedFaceFeature(cache.ped, featureIndex, 0.0)
    end
end

function Clothes.getFaceFeatures(self)
    local features = {}
    for featureIndex = 0, 19 do
        features[featureIndex] = GetPedFaceFeature(cache.ped, featureIndex)
    end
    return features
end

function Clothes.resetFaceFeatures(self)
    for featureIndex = 0, 19 do
        if self.faceFeatures[featureIndex] then
            SetPedFaceFeature(cache.ped, featureIndex, self.faceFeatures[featureIndex])
            self.faceFeatures[featureIndex] = nil
        end
    end
end

function Clothes.toggleFace(self)
    if self.cacheFace then
        SetPedHeadBlendData(
            cache.ped,
            self.cacheFace.shapeFirst,
            self.cacheFace.shapeSecond,
            self.cacheFace.shapeThird,
            self.cacheFace.skinFirst,
            self.cacheFace.skinSecond,
            self.cacheFace.skinThird,
            self.cacheFace.shapeMix,
            self.cacheFace.skinMix,
            self.cacheFace.thirdMix,
            false
        )
        self.cacheFace = nil
        self:resetFaceFeatures()
        Citizen.Wait(10)
        Ped:update()
    else
        self.cacheFace = self:getHeadBlendData(cache.ped)
        Citizen.Wait(1)
        local shapeFirst = self:getSex() == "male" and 0 or 21
        SetPedHeadBlendData(
            cache.ped,
            shapeFirst,
            0,
            0,
            self.cacheFace.skinFirst,
            self.cacheFace.skinSecond,
            self.cacheFace.skinThird,
            0.0,
            self.cacheFace.skinMix,
            0.0,
            false
        )
        self:shrinkFaceFeatures()
        Citizen.Wait(10)
        Ped:update()
    end
end

function Clothes.toggleHair(self)
    if self.cacheHair then
        SetPedComponentVariation(cache.ped, 2, self.cacheHair[1], self.cacheHair[2], 2)
        self.cacheHair = nil
        Citizen.Wait(10)
        Ped:update()
    else
        local toggleHair = Config.ToggleHair[self:getSex()]
        if not toggleHair then
            return
        end
        self.cacheHair = {
            GetPedDrawableVariation(cache.ped, 2),
            GetPedTextureVariation(cache.ped, 2),
        }
        Citizen.Wait(1)
        SetPedComponentVariation(cache.ped, 2, toggleHair[1], toggleHair[2], 2)
        Citizen.Wait(10)
        Ped:update()
    end
end

function getClothingMetadataLabel(skinKey)
    if skinKey:find("_2") then
        return locale("variant")
    end
    return locale("type")
end

function Clothes.clothingMetadata(self)
    while GetResourceState("ox_inventory") ~= "started" do
        Citizen.Wait(100)
    end
    Citizen.Wait(1000)
    local metadataLabels = {}
    local clothingSlots = lib.table.deepclone(Config.ClothingSlots)
    for _, slotConfig in pairs(clothingSlots) do
        if slotConfig.skin then
            for skinKey in pairs(slotConfig.skin.male) do
                metadataLabels[skinKey] = getClothingMetadataLabel(skinKey)
            end
            for skinKey in pairs(slotConfig.skin.female) do
                metadataLabels[skinKey] = getClothingMetadataLabel(skinKey)
            end
        end
    end
    exports.ox_inventory:displayMetadata(metadataLabels)
end

RegisterNetEvent("p_itemclothes/client/toggleHair", function()
    Clothes:toggleHair()
end)

RegisterNetEvent("p_itemclothes/client/toggleFace", function()
    Clothes:toggleFace()
end)

CreateThread(function()
    while GetResourceState('ox_inventory') ~= 'started' do
        Wait(100)
    end
    loadClothesSlots()
    Wait(1000)
    Clothes:clothingMetadata()
end)

Citizen.CreateThread(function()
    while not Config or not Config.Appearance do
        Citizen.Wait(100)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(2000)
    if Config.DisableResourceCheck then
        return
    end
    if Config.Appearance == "illenium-appearance" then
        if GetResourceState("17mov_CharacterSystem") == "started" or GetResourceState("0r-clothing") == "started" then
            return
        end
    end
    if Config.Appearance == "esx_skin" and GetResourceState("p_appearance") == "started" then
        return
    end
    while GetResourceState(Config.Appearance) ~= "started" do
        Citizen.Wait(1000)
        lib.print.error(("Selected Appearance %s is not started!"):format(Config.Appearance))
    end
end)

function Clothes.trackClothing(self, enabled)
    self.trackThread = enabled
    if self.trackThread then
        Citizen.CreateThread(function()
            while self.trackThread do
                Citizen.Wait(100)
            end
            Skin:updateClothes()
        end)
    end
end

exports("trackClothing", function(enabled)
    Clothes:trackClothing(enabled)
end)

function loadClothesSlots()
    if loadedClothingSlots then
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
    loadedClothingSlots = true
end
