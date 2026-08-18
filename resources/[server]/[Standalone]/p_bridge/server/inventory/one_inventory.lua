if (Config.Inventory == 'auto' and not checkResource('one_inventory')) or (Config.Inventory ~= 'auto' and Config.Inventory ~= 'one_inventory') then
    return
end

while not Bridge do
    Citizen.Wait(0)
end

if Config.Debug then
    lib.print.info('[Inventory] Loaded: one_inventory')
end

Bridge.Inventory = {}

--@param playerId: number [existing player id]
--@return items: table [{name: string, count: number, metadata: table, slot: number}]
Bridge.Inventory.getPlayerItems = function(playerId)
    return exports['one_inventory']:GetInventoryItems(playerId)
end

--@param prefix: string [prefix for the drop, unused in one_inventory]
--@param items: table [name: string, count: number, metadata: table]
--@param coords: vector3 [drop coordinates]
Bridge.Inventory.CustomDrop = function(prefix, items, coords)
    exports['one_inventory']:CreateDrop(coords, items)
end

--@param playerId: number [existing player id]
--@param itemName: string [item name]
--@param itemCount: number [amount of items to add]
--@param itemMetadata: table [item metadata, optional]
--@param itemSlot: number [item slot, optional]
Bridge.Inventory.addItem = function(playerId, itemName, itemCount, itemMetadata, itemSlot)
    exports['one_inventory']:AddItem(playerId, itemName, itemCount, itemMetadata, itemSlot)
end

--@param playerId: number [existing player id]
--@param itemName: string [item name]
--@param itemCount: number [amount of items to remove]
--@param itemMetadata: table [item metadata, optional]
--@param itemSlot: number [item slot, optional]
Bridge.Inventory.removeItem = function(playerId, itemName, itemCount, itemMetadata, itemSlot)
    exports['one_inventory']:RemoveItem(playerId, itemName, itemCount, itemMetadata, itemSlot)
end

--@param playerId: number [existing player id]
--@param itemName: string [item name]
--@param itemMetadata: table [item metadata, optional]
--@return count: number [amount of items in inventory]
Bridge.Inventory.getItemCount = function(playerId, itemName, itemMetadata)
    return exports['one_inventory']:GetItemCount(playerId, itemName, itemMetadata)
end

---@param playerId: number [existing player id]
---@param slot: number [inventory slot]
Bridge.Inventory.getItemSlot = function(playerId, slot)
    return exports['one_inventory']:GetSlot(playerId, slot)
end

---@param shopName: string [unique shop name]
---@param data: table
Bridge.Inventory.createShop = function(shopName, data)
    while GetResourceState('one_inventory') ~= 'started' do
        Citizen.Wait(100)
    end

    Citizen.Wait(100)
    exports['one_inventory']:RegisterShop({
        name = shopName,
        label = data.name or data.label or 'Shop',
        coords = data.coords or data.locations,
        jobs = data.groups,
        inventory = data.inventory
    })
end

---@param itemName: string [item name]
Bridge.Inventory.getItemData = function(itemName)
    return exports['one_inventory']:GetItemDefinition(itemName)
end

---@param stashId: string [unique stash id]
---@param label: string [stash label]
---@param slots: number [number of slots]
---@param weight: number [max weight]
-- one_inventory creates stashes when they are first opened ('stash:<name>'),
-- so nothing to pre-register here; kept for interface parity with ox_inventory.
Bridge.Inventory.registerStash = function(stashId, label, slots, weight)
    return
end

---@param playerId: number|string [player id or stash/inventory id]
---@param slot: number [slot index]
---@param metadata: table [new metadata to write to the slot]
Bridge.Inventory.setMetadata = function(playerId, slot, metadata)
    exports['one_inventory']:SetItemMetadata(playerId, slot, metadata)
end

---@param invId: number|string [player id or stash/inventory id]
---@return inventory: table|nil [{ slots, weight, maxWeight, ... }]
Bridge.Inventory.getInventory = function(invId)
    return exports['one_inventory']:GetInventory(invId)
end

---@param invId: number|string [player id or stash/inventory id]
Bridge.Inventory.clearInventory = function(invId)
    exports['one_inventory']:ClearInventory(invId)
end

---@param event: string [one_inventory hook name, e.g. 'beforeItemAdd']
---@param cb: function [hook callback, return false to cancel]
---@param options: table|nil [hook options, e.g. { itemFilter, inventoryFilter, typeFilter }]
---@return id: number|nil [hook id]
Bridge.Inventory.registerHook = function(event, cb, options)
    return exports['one_inventory']:RegisterHook(event, cb, options)
end
