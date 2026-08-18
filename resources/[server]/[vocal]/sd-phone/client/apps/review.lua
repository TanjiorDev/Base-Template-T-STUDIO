---@type fun(nuiAction: string, serverEvent: string) NUI->server pass-through registrar (client.nui).
local proxy = require 'client.nui'

-- Thin delegates into server/review: business listings, review CRUD, helpful votes and the
-- boss-gated manage view.
proxy('sd-phone:review:list',     'sd-phone:server:review:list')
proxy('sd-phone:review:business', 'sd-phone:server:review:business')
proxy('sd-phone:review:create',   'sd-phone:server:review:create')
proxy('sd-phone:review:delete',   'sd-phone:server:review:delete')
proxy('sd-phone:review:helpful',  'sd-phone:server:review:helpful')
proxy('sd-phone:review:manage',   'sd-phone:server:review:manage')
