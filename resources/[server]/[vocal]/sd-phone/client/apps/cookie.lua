---@type fun(nuiAction: string, serverEvent: string) NUI->server pass-through registrar (client.nui).
local proxy = require 'client.nui'

-- Thin delegates into server/cookie: cookie-clicker save/load, the leaderboard and the
-- leaderboard nickname.
proxy('sd-phone:cookie:load',        'sd-phone:server:cookie:load')
proxy('sd-phone:cookie:save',        'sd-phone:server:cookie:save')
proxy('sd-phone:cookie:leaderboard', 'sd-phone:server:cookie:leaderboard')
proxy('sd-phone:cookie:nickname',    'sd-phone:server:cookie:nickname')
