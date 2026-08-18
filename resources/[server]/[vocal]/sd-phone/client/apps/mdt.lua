---@type fun(nuiAction: string, serverEvent: string) NUI->server pass-through registrar (client.nui).
local proxyCallback = require 'client.nui'
---@type table Notify bridge (bridge.client.notify): backend-agnostic toast notifications.
local notify = require 'bridge.client.notify'

---@type string[] NUI action suffixes proxied 1:1 to sd-phone:server:mdt:<action>. Every MDT
---action except the waypoint below is a pass-through; identity, permissions and clamping all live
---on the server.
local ACTIONS = {
    'bootstrap', 'home',
    'dispatch:state', 'dispatch:setStatus', 'dispatch:attach', 'dispatch:detach', 'dispatch:locate',
    'persons:search', 'persons:get', 'persons:notes', 'persons:flags', 'persons:mugshot',
    'vehicles:search', 'vehicles:get', 'vehicles:update',
    'reports:list', 'reports:get', 'reports:save', 'reports:delete',
    'cases:list', 'cases:get', 'cases:save', 'cases:delete', 'cases:note', 'cases:assign', 'cases:linkReport',
    'warrants:list', 'warrants:get', 'warrants:issue', 'warrants:close', 'warrants:void',
    'offences:list',
    'jail:list', 'jail:quote', 'jail:book',
    'roster:list', 'roster:setCallsign', 'roster:setRadio', 'roster:setGrade', 'roster:dismiss', 'roster:page',
    'me:update',
    'chat:history', 'chat:send',
    'bulletins:list', 'bulletins:save', 'bulletins:delete',
    'logs:list',
    'phone:summary', 'phone:contacts', 'phone:calls', 'phone:threads', 'phone:thread',
    'phone:media', 'phone:notes', 'phone:note', 'phone:accounts',
    'patients:search', 'patients:get', 'patients:update',
    'protocols:list', 'protocols:save', 'protocols:delete',
    'sops:list',
    'affairs:list', 'affairs:get', 'affairs:officer', 'affairs:file', 'affairs:update',
    'affairs:note', 'affairs:close',
    'court:list', 'court:get', 'court:citizen', 'court:file', 'court:manage', 'court:note', 'court:rule',
    'expunge:list', 'expunge:file', 'expunge:rule',
}

for _, action in ipairs(ACTIONS) do
    proxyCallback('sd-phone:mdt:' .. action, 'sd-phone:server:mdt:' .. action)
end

---React -> Lua: drops a GPS waypoint at coords the server resolved. The only MDT action that is
---not a pass-through, because a waypoint is a client capability with no server to await.
---@param payload table { x: number, y: number, z?: number }
RegisterNUICallback('sd-phone:mdt:setWaypoint', function(payload, cb)
    local x = type(payload) == 'table' and tonumber(payload.x) or nil
    local y = type(payload) == 'table' and tonumber(payload.y) or nil
    if not x or not y then
        notify.show({ description = 'Could not set waypoint.', type = 'error' })
        cb({ success = false })
        return
    end

    SetNewWaypoint(x + 0.0, y + 0.0)
    notify.show({ description = 'Waypoint set.', type = 'success' })
    cb({ success = true })
end)

---Server push: the whole CAD state after any unit or call change; the pane replaces rather than
---patches.
---@param data table { units, calls }
RegisterNetEvent('sd-phone:client:mdt:dispatch', function(data)
    SendNUIMessage({ action = 'sd-phone:mdt:dispatch', data = data })
end)

---Server push: a NEW call only, so the pane can flash it and the shell can raise a badge.
---@param data table { call }
RegisterNetEvent('sd-phone:client:mdt:call', function(data)
    SendNUIMessage({ action = 'sd-phone:mdt:call', data = data })
end)

---Server push: one line on the department channel.
---@param data table { message }
RegisterNetEvent('sd-phone:client:mdt:chat', function(data)
    SendNUIMessage({ action = 'sd-phone:mdt:chat', data = data })
end)

---Server push: the bulletin board changed; carries the whole board.
---@param data table { bulletins }
RegisterNetEvent('sd-phone:client:mdt:bulletin', function(data)
    SendNUIMessage({ action = 'sd-phone:mdt:bulletin', data = data })
end)

---Server push: a citizen's wanted state changed, so an open record repaints without a refetch.
---@param data table { citizenid, wanted }
RegisterNetEvent('sd-phone:client:mdt:warrant', function(data)
    SendNUIMessage({ action = 'sd-phone:mdt:warrant', data = data })
end)
