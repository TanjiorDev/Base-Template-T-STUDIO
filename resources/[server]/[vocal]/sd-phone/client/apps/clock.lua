---@type fun(nuiAction: string, serverEvent: string) NUI->server pass-through registrar (client.nui).
local proxy = require 'client.nui'

-- Thin delegates into server/clock: alarm CRUD and the recent-timers list.
proxy('sd-phone:clock:alarms:list',   'sd-phone:server:clock:alarms:list')
proxy('sd-phone:clock:alarms:save',   'sd-phone:server:clock:alarms:save')
proxy('sd-phone:clock:alarms:delete', 'sd-phone:server:clock:alarms:delete')
proxy('sd-phone:clock:recents:list',  'sd-phone:server:clock:recents:list')
proxy('sd-phone:clock:recents:add',   'sd-phone:server:clock:recents:add')
