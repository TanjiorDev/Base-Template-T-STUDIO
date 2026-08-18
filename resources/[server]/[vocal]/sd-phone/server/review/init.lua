---@type table Boot reporter (server.boot): one console summary instead of per-module prints.
local boot = require 'server.boot'

---@type table Review persistence layer (server.review.store): review/helpful-vote/override row CRUD.
local store = require 'server.review.store'
---@type table Authoritative review handlers (server.review.actions): validation + row mutation.
local actions = require 'server.review.actions'

---Schema bootstrap. Runs once at boot.
CreateThread(function()
    local ok, err = pcall(store.ensureSchema)
    if not ok then
        boot.schemaFailed('review', err)
        return
    end
    boot.schemaReady()
end)

-- App callbacks: thin delegates into server.review.actions.
lib.callback.register('sd-phone:server:review:list', function(src) return actions.list(src) end)
lib.callback.register('sd-phone:server:review:business', function(src, payload) return actions.business(src, type(payload) == 'table' and payload.id or nil) end)
lib.callback.register('sd-phone:server:review:create', function(src, payload) return actions.create(src, payload) end)
lib.callback.register('sd-phone:server:review:delete', function(src, payload) return actions.delete(src, type(payload) == 'table' and payload.id or nil) end)
lib.callback.register('sd-phone:server:review:helpful', function(src, payload) return actions.helpful(src, type(payload) == 'table' and payload.id or nil) end)
lib.callback.register('sd-phone:server:review:manage', function(src, payload) return actions.manage(src, payload) end)
