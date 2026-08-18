---@type table Boot reporter (server.boot): one console summary instead of per-module prints.
local boot = require 'server.boot'

---@type table Streaks persistence layer (server.streaks.store): schema bootstrap + row CRUD.
local store   = require 'server.streaks.store'
---@type table Authoritative Streaks handlers (server.streaks.actions): validation + world mutation.
local actions = require 'server.streaks.actions'
---@type table Live-push module (server.streaks.live): the gallery presence set + scoped pushes.
local live    = require 'server.streaks.live'

-- Boot thread: creates the Streaks tables.
CreateThread(function()
    local ok, err = pcall(store.ensureSchema)
    if not ok then
        boot.schemaFailed('streaks', err)
        return
    end
    boot.schemaReady()
end)

---Register one Streaks callback under the app's 'sd-phone:server:streaks:' prefix.
---@param action string callback name suffix
---@param fn function handler fun(src, payload?): table
local function register(action, fn)
    lib.callback.register('sd-phone:server:streaks:' .. action, fn)
end

-- App callbacks: thin delegates into server.streaks.actions.
register('sync',        function(src) return actions.sync(src) end)
register('post',        function(src, payload) return actions.post(src, payload) end)
register('gallery',     function(src, payload) return actions.gallery(src, payload) end)
register('like',        function(src, payload) return actions.like(src, payload) end)
register('leaderboard', function(src) return actions.leaderboard(src) end)

---Toggles the caller's gallery-open presence for live post/like pushes. Self-scoped.
register('watch', function(src, payload)
    payload = type(payload) == 'table' and payload or {}
    live.watch(src, payload.on == true)
    return { success = true }
end)

---Drops a departing viewer's presence.
AddEventHandler('playerDropped', function()
    live.drop(source)
end)

---Confirm an admin command to its caller under the Streaks title.
---@param src integer player server id
---@param msg string notification text
local function notify(src, msg)
    TriggerClientEvent('ox_lib:notify', src, { title = 'Streaks', description = msg, type = 'success' })
end

---/streakset <days> - force the caller's own streak to a given day count (admin/testing).
---Restricted to group.admin; delegates to actions.setStreak.
---@param source integer player server id
---@param args table parsed command args { days: number }
lib.addCommand('streakset', {
    help = 'Set your Streaks day count (admin/testing)',
    params = { { name = 'days', type = 'number', help = 'Day count to set (0 = fresh)' } },
    restricted = 'group.admin',
}, function(source, args)
    local ok, days = actions.setStreak(source, args.days)
    if ok then notify(source, ('Streak set to day %d. Reopen the app.'):format(days)) end
end)

---/streakadd <amount> - raise (or, with a negative amount, revert) the caller's own streak days
---(admin/testing). Restricted to group.admin; delegates to actions.addStreak.
---@param source integer player server id
---@param args table parsed command args { amount: number }
lib.addCommand('streakadd', {
    help = 'Raise or revert your Streaks days (admin/testing)',
    params = { { name = 'amount', type = 'number', help = 'Days to add (use a negative number to revert)' } },
    restricted = 'group.admin',
}, function(source, args)
    local ok, days = actions.addStreak(source, args.amount)
    if ok then notify(source, ('Streak now day %d. Reopen the app.'):format(days)) end
end)

---/streakwipe - wipe ALL Streaks data for every player (admin/testing). Restricted to group.admin.
---@param source integer player server id
lib.addCommand('streakwipe', {
    help = 'Wipe ALL Streaks data for everyone (admin/testing)',
    restricted = 'group.admin',
}, function(source)
    actions.wipeAll(source)
    notify(source, 'All Streaks data wiped. You can post again now.')
end)
