while not Config or not Config.Appearance do
    Citizen.Wait(100)
end

if Config.Appearance ~= "tgiann-clothing" then
    return
end

Skin = {}

function Skin.updateClothes(self, skinData)
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
                local skinValue = skinData[skinKey]
                clothesPayload[slotConfig.itemName].skin[skinKey] = skinValue or -1
            end
        end
    end
    TriggerServerEvent("p_itemclothes/server/updateClothes", clothesPayload)
end

RegisterNetEvent("p_itemclothes/client/updateClothes", function(skinData)
    Skin:updateClothes(skinData)
end)

Skin.timer = GetGameTimer()
Skin.timerThread = false

function insertSkinchangerChange(skinChanges, skinKey, skinValue)
    if skinKey:find("_2") then
        table.insert(skinChanges, { skinKey, skinValue })
    else
        table.insert(skinChanges, 1, { skinKey, skinValue })
    end
end

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
    if not Skin:waitForInventoryDebounce() then
        return
    end
    local hasSkinChanges = false
    local currentSkin = exports.skinchanger:GetSkin()
    local playerItems = exports.ox_inventory:GetPlayerItems()
    local skinChanges = {}
    for slotId, slotConfig in pairs(Config.ClothingSlots) do
        local inventorySlot = tonumber(slotId)
        local slotItem = playerItems[inventorySlot]
        if slotItem and slotItem.metadata then
            for metadataKey, metadataValue in pairs(slotItem.metadata) do
                if currentSkin[metadataKey] ~= metadataValue then
                    insertSkinchangerChange(skinChanges, metadataKey, metadataValue)
                    hasSkinChanges = true
                end
            end
        else
            local defaultSkin = slotConfig.skin[Clothes:getSex()] or {}
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
            exports["tgiann-clothing"]:ChangeComponentValue(skinChanges[changeIndex][1], skinChanges[changeIndex][2])
        end
        Citizen.Wait(1)
        Ped:update()
        Citizen.Wait(100)
        exports["tgiann-clothing"]:SaveSkin()
    end
end)

RegisterNetEvent("esx:playerLoaded", function(_, _, skinData)
    if not skinData or not next(skinData) then
        return
    end
    Citizen.Wait(10)
    Skin:updateClothes(skinData)
end)

RegisterNetEvent("qb-clothing:client:loadPlayerClothing", function(skinData, targetPed)
    if not skinData or not next(skinData) then
        return
    end
    Citizen.Wait(10)
    Skin:updateClothes(skinData)
end)
