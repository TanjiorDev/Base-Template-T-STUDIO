local ox_inventory = exports.ox_inventory

local allowedTypes = {
    torso = true,
    pants = true,
    shoes = true,
    mask = true,
    helmet = true,
    bag = true,
    glasses = true,
    vest = true,
    ears = true,
    chain = true,
}

local function validGender(gender)
    return gender == 'Male' or gender == 'Female'
end

local function validNumber(value)
    return type(value) == 'number' and value == math.floor(value) and value >= -1 and value <= 10000
end

local function hasExactAccessory(sourceId, itemType, gender, skin1, skin2)
    local items = ox_inventory:Search(sourceId, 'slots', itemType) or {}
    for _, item in pairs(items) do
        local metadata = item.metadata or {}
        if metadata.gender == gender
            and tonumber(metadata.accessories) == skin1
            and tonumber(metadata.accessories2) == skin2 then
            return true
        end
    end
    return false
end

local function hasExactTorso(sourceId, gender, torso1, torso2, arms1, arms2, tshirt1, tshirt2)
    local items = ox_inventory:Search(sourceId, 'slots', 'torso') or {}
    for _, item in pairs(items) do
        local metadata = item.metadata or {}
        if metadata.gender == gender
            and tonumber(metadata.torso1) == torso1
            and tonumber(metadata.torso2) == torso2
            and tonumber(metadata.arms1) == arms1
            and tonumber(metadata.arms2) == arms2
            and tonumber(metadata.tshirt1) == tshirt1
            and tonumber(metadata.tshirt2) == tshirt2 then
            return true
        end
    end
    return false
end

RegisterNetEvent('remove:clothes', function(skin1, skin2, itemType, metadata)
    local sourceId = source
    if not allowedTypes[itemType] then return end
    if type(metadata) ~= 'table' then return end

    -- Un vêtement ne peut être retiré de l'inventaire que s'il existe réellement
    -- avec les métadonnées fournies. ox_inventory effectue ensuite la suppression.
    ox_inventory:RemoveItem(sourceId, itemType, 1, metadata)
end)

RegisterNetEvent('add:clothes', function(skin1, skin2, itemType, gender)
    local sourceId = source
    skin1, skin2 = tonumber(skin1), tonumber(skin2)

    if not allowedTypes[itemType] or itemType == 'torso' then return end
    if not validGender(gender) or not validNumber(skin1) or not validNumber(skin2) then return end
    if hasExactAccessory(sourceId, itemType, gender, skin1, skin2) then
        TriggerClientEvent('esx:showNotification', sourceId, 'Vous avez déjà ce vêtement dans votre inventaire.')
        return
    end

    local metadata = {
        gender = gender,
        accessories = skin1,
        accessories2 = skin2,
        description = ('[Genre: %s] [%s 1 #%s] - [%s 2 #%s]'):format(gender, itemType, skin1, itemType, skin2)
    }

    ox_inventory:AddItem(sourceId, itemType, 1, metadata)
end)

RegisterNetEvent('add:clothestorso', function(torso1, torso2, arms1, arms2, tshirt1, tshirt2, itemType, gender)
    local sourceId = source
    torso1, torso2 = tonumber(torso1), tonumber(torso2)
    arms1, arms2 = tonumber(arms1), tonumber(arms2)
    tshirt1, tshirt2 = tonumber(tshirt1), tonumber(tshirt2)

    if itemType ~= 'torso' or not validGender(gender) then return end
    if not validNumber(torso1) or not validNumber(torso2)
        or not validNumber(arms1) or not validNumber(arms2)
        or not validNumber(tshirt1) or not validNumber(tshirt2) then return end

    if hasExactTorso(sourceId, gender, torso1, torso2, arms1, arms2, tshirt1, tshirt2) then
        TriggerClientEvent('esx:showNotification', sourceId, 'Vous avez déjà cette tenue dans votre inventaire.')
        return
    end

    local metadata = {
        gender = gender,
        torso1 = torso1,
        torso2 = torso2,
        arms1 = arms1,
        arms2 = arms2,
        tshirt1 = tshirt1,
        tshirt2 = tshirt2,
        description = ('[Genre: %s] [torso #%s/%s] [arms #%s/%s] [tshirt #%s/%s]'):format(
            gender, torso1, torso2, arms1, arms2, tshirt1, tshirt2
        )
    }

    ox_inventory:AddItem(sourceId, 'torso', 1, metadata)
end)
