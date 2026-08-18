---@type fun(nuiAction: string, serverEvent: string) NUI->server pass-through registrar (client.nui).
local proxyCallback = require 'client.nui'

-- Thin delegates into server/gifs: read-only GIF-picker lookups.
proxyCallback('sd-phone:gifs:categories', 'sd-phone:server:gifs:categories')
proxyCallback('sd-phone:gifs:featured',   'sd-phone:server:gifs:featured')
proxyCallback('sd-phone:gifs:search',     'sd-phone:server:gifs:search')
