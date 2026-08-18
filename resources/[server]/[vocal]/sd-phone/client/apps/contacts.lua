---@type fun(nuiAction: string, serverEvent: string) NUI->server pass-through registrar (client.nui).
local proxyCallback = require 'client.nui'

-- Thin delegates into server/contacts: contact CRUD, favourites, sharing, the call log and
-- number blocking.
proxyCallback('sd-phone:contacts:list',         'sd-phone:server:contacts:list')
proxyCallback('sd-phone:contacts:add',          'sd-phone:server:contacts:add')
proxyCallback('sd-phone:contacts:update',       'sd-phone:server:contacts:update')
proxyCallback('sd-phone:contacts:delete',       'sd-phone:server:contacts:delete')
proxyCallback('sd-phone:contacts:favorite',     'sd-phone:server:contacts:favorite')
proxyCallback('sd-phone:contacts:share',        'sd-phone:server:contacts:share')
proxyCallback('sd-phone:contacts:logCall',      'sd-phone:server:contacts:logCall')
proxyCallback('sd-phone:contacts:deleteRecent', 'sd-phone:server:contacts:deleteRecent')
proxyCallback('sd-phone:contacts:clearRecents', 'sd-phone:server:contacts:clearRecents')
proxyCallback('sd-phone:contacts:block',        'sd-phone:server:contacts:block')
proxyCallback('sd-phone:contacts:unblock',      'sd-phone:server:contacts:unblock')
proxyCallback('sd-phone:contacts:blockedList',  'sd-phone:server:contacts:blockedList')
proxyCallback('sd-phone:contacts:isBlocked',    'sd-phone:server:contacts:isBlocked')
proxyCallback('sd-phone:contacts:saveCard',     'sd-phone:server:contacts:saveCard')

---Server push: a nearby player shared a contact card with us; relays it to the list.
---@param contact table serialized contact from server/contacts/actions.lua
RegisterNetEvent('sd-phone:client:contacts:shared', function(contact)
    SendNUIMessage({ action = 'sd-phone:contacts:shared', data = contact })
end)

---Server push: another resource removed our contacts matching a number; relays it to the list.
---@param data { phone: string } bare-digits number whose contacts were removed
RegisterNetEvent('sd-phone:client:contacts:removed', function(data)
    SendNUIMessage({ action = 'sd-phone:contacts:removed', data = data })
end)
