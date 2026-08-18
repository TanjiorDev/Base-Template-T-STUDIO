---@type fun(nuiAction: string, serverEvent: string) NUI->server pass-through registrar (client.nui).
local proxyCallback = require 'client.nui'

-- Thin delegates into server/photos: photo listing, deletion, favourites, URL saves and album
-- CRUD.
proxyCallback('sd-phone:photos:list',        'sd-phone:server:photos:list')
proxyCallback('sd-phone:photos:delete',      'sd-phone:server:photos:delete')
proxyCallback('sd-phone:photos:setFavorite', 'sd-phone:server:photos:setFavorite')
proxyCallback('sd-phone:photos:saveUrl',     'sd-phone:server:photos:saveUrl')

proxyCallback('sd-phone:albums:list',        'sd-phone:server:albums:list')
proxyCallback('sd-phone:albums:create',      'sd-phone:server:albums:create')
proxyCallback('sd-phone:albums:delete',      'sd-phone:server:albums:delete')
proxyCallback('sd-phone:albums:addPhotos',   'sd-phone:server:albums:addPhotos')
proxyCallback('sd-phone:albums:removePhoto', 'sd-phone:server:albums:removePhoto')
proxyCallback('sd-phone:albums:photos',      'sd-phone:server:albums:photos')

---Server push: a photo finished saving (camera shutter or clip upload); relays it to the
---gallery and any app listening for a fresh capture.
---@param photo table photo record from server/photos/init.lua
RegisterNetEvent('sd-phone:client:photos:added', function(photo)
    SendNUIMessage({ action = 'sd-phone:photos:added', data = photo })
end)
