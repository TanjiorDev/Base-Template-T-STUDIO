---@type fun(nuiAction: string, serverEvent: string) NUI->server pass-through registrar (client.nui).
local proxyCallback = require 'client.nui'

-- Thin delegates into server/apps: the installable-app catalogue, install/uninstall state and
-- the home-screen layout.
proxyCallback('sd-phone:apps:list',       'sd-phone:server:apps:list')
proxyCallback('sd-phone:apps:install',    'sd-phone:server:apps:install')
proxyCallback('sd-phone:apps:uninstall',  'sd-phone:server:apps:uninstall')
proxyCallback('sd-phone:apps:saveLayout', 'sd-phone:server:apps:saveLayout')
