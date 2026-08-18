if (Config.Inventory == 'auto' and not checkResource('ox_inventory')) or (Config.Inventory ~= 'auto' and Config.Inventory ~= 'ox_inventory') then
    return
end

while not Bridge do
    Citizen.Wait(0)
end

if Config.Debug then
    lib.print.info('[Inventory] Loaded: ox_inventory')
end

Bridge.Inventory = {}

Bridge.Inventory.openInventory = function(invType, data)
    exports['ox_inventory']:openInventory(invType, data)
end

Bridge.Inventory.getItemCount = function(itemName, metadata)
    return exports['ox_inventory']:Search('count', itemName, metadata or nil)
end

Bridge.Inventory.getItemData = function(itemName)
    local info = exports['ox_inventory']:Items(itemName)
    return info and {name = itemName, label = info.label, description = info.description, image = ('https://cfx-nui-ox_inventory/web/images/%s.png'):format(itemName)}
end

Bridge.Inventory.getPlayerItems = function()
    return exports['ox_inventory']:GetPlayerItems()
end

---@return weapon: table|nil [currently equipped weapon { name, label, metadata, slot, ... } or nil]
Bridge.Inventory.getCurrentWeapon = function()
    return exports.ox_inventory:getCurrentWeapon()
end

---@param state: boolean [true to force-holster/disarm the equipped weapon]
Bridge.Inventory.disarm = function(state)
    TriggerEvent('ox_inventory:disarm', true)
end