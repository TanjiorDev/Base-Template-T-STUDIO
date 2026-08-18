---@type fun(nuiAction: string, serverEvent: string) NUI->server pass-through registrar (client.nui).
local proxy = require 'client.nui'

-- Thin delegates into server/stocks: market snapshot, cash deposits/withdrawals and trades.
proxy('sd-phone:stocks:market',   'sd-phone:server:stocks:market')
proxy('sd-phone:stocks:deposit',  'sd-phone:server:stocks:deposit')
proxy('sd-phone:stocks:withdraw', 'sd-phone:server:stocks:withdraw')
proxy('sd-phone:stocks:buy',      'sd-phone:server:stocks:buy')
proxy('sd-phone:stocks:sell',     'sd-phone:server:stocks:sell')
proxy('sd-phone:stocks:holders',  'sd-phone:server:stocks:holders')
proxy('sd-phone:stocks:watch',    'sd-phone:server:stocks:watch')

---Server push: a live price tick; relays it to open charts and tickers.
---@param data table price snapshot from server/stocks
RegisterNetEvent('sd-phone:client:stocks:prices', function(data)
    SendNUIMessage({ action = 'sd-phone:stocks:prices', data = data })
end)
