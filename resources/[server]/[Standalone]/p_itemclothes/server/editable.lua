Editable = {}

-- TODO:
-- 1. Save skin on player disconnect
-- Don't touch it for now
function Editable:saveSkinDB(playerId)
    local _source = playerId
    local clothesData = Clothes.playersClothes[_source] or nil
    if not clothesData then return end

    local identifier = Bridge.Framework.getUniqueId(_source)
    if GetResourceState('es_extended') == 'started' then
        MySQL.update('UPDATE users SET skin = ? WHERE identifier = ?', {
            json.encode(clothesData),
            identifier
        })
    elseif GetResourceState('qb-core') == 'started' then
        MySQL.update('UPDATE player_outfits SET skin = ? WHERE citizenid = ? AND active = 1', {
            json.encode(clothesData),
            identifier
        })
    end
end

local function getFirstClothingSlot()
    return exports.ox_inventory:getPlayerInvSlots() - 14 + 1
end

local function isUnequippedClothingSlot(skin)
    for clothName, clothIndex in pairs(skin) do
        if (clothName == 'arms' or clothName:find('_1')) and clothIndex ~= -1 then
            return false
        end
    end
    return true
end

local function hasClothingItemInRegularSlots(playerId, itemName, metadata)
    local firstClothingSlot = getFirstClothingSlot()
    local items = exports.ox_inventory:GetSlotsWithItem(playerId, itemName, metadata, true)
        or exports.ox_inventory:GetSlotsWithItem(playerId, itemName, nil, false)

    if not items then
        return false
    end

    for i = 1, #items do
        if items[i].slot < firstClothingSlot then
            return true
        end
    end

    return false
end

local function slotMetadataMatches(slotData, metadata)
    if not slotData or not slotData.metadata or not metadata then
        return false
    end

    for key, value in pairs(metadata) do
        if slotData.metadata[key] ~= value then
            return false
        end
    end

    return true
end

RegisterNetEvent('p_itemclothes/server/updateClothes', function(data)
    local _source = source

    while not Clothes.ready do
        Wait(50)
    end

    if type(data) ~= 'table' or not next(data) then
        lib.print.warn(('p_itemclothes: empty clothing payload from player %s'):format(_source))
        return
    end

    local added, skipped = 0, 0

    for itemName, itemData in pairs(data) do
        if not Clothes.allowedItems[itemName] then
            skipped = skipped + 1
            goto continue
        end

        local slot = itemData.slot
        local skin = itemData.skin
        local slotData = exports['ox_inventory']:GetSlot(_source, slot)

        if isUnequippedClothingSlot(skin) then
            if slotData and slotData.count > 0 then
                exports['ox_inventory']:RemoveItem(_source, slotData.name, slotData.count, slotData.metadata, slot)
            end
            goto continue
        end

        if hasClothingItemInRegularSlots(_source, itemName, skin) and (not slotData or slotData.count == 0) then
            goto continue
        end

        if slotData and slotData.count > 0 and slotData.name == itemName and slotMetadataMatches(slotData, skin) then
            goto continue
        end

        if slotData and slotData.count > 0 then
            exports['ox_inventory']:RemoveItem(_source, slotData.name, slotData.count, slotData.metadata, slot)
        end

        local success, response = exports['ox_inventory']:AddItem(_source, itemName, 1, skin, slot)
        if not success then
            lib.print.warn(('p_itemclothes: failed to add %s to slot %s (%s)'):format(itemName, slot, response))
        else
            added = added + 1
        end

        if success and not Config['17MovAppearance'] and Config.SaveClothing and slotData then
            exports['ox_inventory']:AddItem(_source, slotData.name, slotData.count, slotData.metadata)
        end

        ::continue::
    end

    if added == 0 and skipped > 0 then
        lib.print.warn(('p_itemclothes: no clothing items added for player %s (skipped %s)'):format(_source, skipped))
    end
end)