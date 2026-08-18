---@type table Boot reporter (server.boot): one console summary instead of per-module prints.
local boot = require 'server.boot'

---@type table Marketplace persistence layer (server.marketplace.store): listing row CRUD.
local store = require 'server.marketplace.store'
---@type table Authoritative marketplace handlers (server.marketplace.actions).
local actions = require 'server.marketplace.actions'
---@type table Watcher registry (server.watchers): shared with the feed broadcast in actions.
local watchers = require('server.watchers').of('marketplace')

-- One-shot boot thread: creates/migrates the marketplace table.
CreateThread(function()
    local ok, err = pcall(store.ensureSchema)
    if not ok then
        boot.schemaFailed('marketplace', err)
        return
    end
    boot.schemaReady()
end)

-- Callbacks: thin delegates into server.marketplace.actions.
lib.callback.register('sd-phone:server:marketplace:list', function(src) return actions.list(src) end)
lib.callback.register('sd-phone:server:marketplace:create', function(src, payload) return actions.create(src, payload) end)
lib.callback.register('sd-phone:server:marketplace:update', function(src, payload) return actions.update(src, payload) end)

---Unwraps { id } before delegating; a non-table payload is coerced to {}.
---@param src integer player server id
---@param payload table|nil { id } (untrusted)
lib.callback.register('sd-phone:server:marketplace:delete', function(src, payload)
    if type(payload) ~= 'table' then payload = {} end
    return actions.delete(src, payload.id)
end)

---Subscribes or unsubscribes the caller to the live feed push while the app is open.
---@param src integer player server id
---@param payload table { on: boolean }
lib.callback.register('sd-phone:server:marketplace:watch', function(src, payload)
    payload = type(payload) == 'table' and payload or {}
    watchers.watch(src, payload.on == true)
    return { success = true }
end)

---Drops a departing watcher's entry.
AddEventHandler('playerDropped', function()
    watchers.drop(source)
end)
