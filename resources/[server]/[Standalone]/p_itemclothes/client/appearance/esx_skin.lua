while not Config or not Config.Appearance do
    Citizen.Wait(100)
end

if Config.Appearance ~= "esx_skin" then
    return
end

Skin = {}
Skin.timer = GetGameTimer()
Skin.timerThread = false
Skin.saveTimer = GetGameTimer()
Skin.saveThread = false
skinUpdateEnabled = true

function insertSkinchangerChange(skinChanges, skinKey, skinValue)
    if skinKey:find("_2") then
        table.insert(skinChanges, { skinKey, skinValue })
    else
        table.insert(skinChanges, 1, { skinKey, skinValue })
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
    TriggerServerEvent("esx_skin:save", exports.skinchanger:GetSkin())
end

RegisterNetEvent("p_itemclothes/client/updateClothes", function(skinData)
    Skin:updateClothes(skinData)
end)

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
    local hasSkinChanges = false
    local currentSkin = exports.skinchanger:GetSkin()
    local playerItems = exports.ox_inventory:GetPlayerItems()
    local skinChanges = {}
    for slotId, slotConfig in pairs(Config.ClothingSlots) do
        local slotItem = playerItems[tonumber(slotId)]
        if slotItem and slotItem.metadata then
            for metadataKey, metadataValue in pairs(slotItem.metadata) do
                if currentSkin[metadataKey] ~= metadataValue then
                    insertSkinchangerChange(skinChanges, metadataKey, metadataValue)
                    hasSkinChanges = true
                end
            end
        else
            local defaultSkin = Config.ClothingSlots[tonumber(slotId)].skin[Clothes:getSex()] or {}
            for skinKey, skinValue in pairs(defaultSkin) do
                if currentSkin[skinKey] ~= skinValue then
                    insertSkinchangerChange(skinChanges, skinKey, skinValue)
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
        for changeIndex = 1, #skinChanges do
            TriggerEvent("skinchanger:change", skinChanges[changeIndex][1], skinChanges[changeIndex][2])
        end
        Ped:update()
        Skin:saveSkin()
    end
end)

RegisterNetEvent("esx:playerLoaded", function(_, _, skinData)
    if not skinData or not next(skinData) then
        return
    end
    Citizen.Wait(100)
    Skin:updateClothes(skinData)
end)
