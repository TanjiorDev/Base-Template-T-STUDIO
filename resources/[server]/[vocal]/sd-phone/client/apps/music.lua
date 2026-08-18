---AirShare a song or playlist to a nearby phone. Thin forward into server/music.
RegisterNUICallback('sd-phone:music:share', function(payload, cb)
    cb(lib.callback.await('sd-phone:server:music:share', false, payload) or { success = false, message = 'No response from server' })
end)

---Server push: a song / playlist shared to us was accepted server-side. Hands it to the NUI
---and surfaces a notification.
---@param data table { kind: 'track'|'playlist', ... } from server/music/init.lua
RegisterNetEvent('sd-phone:client:music:receive', function(data)
    SendNUIMessage({ action = 'sd-phone:music:receive', data = data })
    SendNUIMessage({ action = 'sd-phone:notification', data = {
        app   = 'music',
        title = 'Music',
        body  = (data and data.kind == 'playlist')
            and 'A playlist was added to your library.'
            or  'A song was added to your library.',
    } })
end)
