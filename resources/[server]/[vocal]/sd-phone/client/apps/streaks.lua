---@type fun(nuiAction: string, serverEvent: string) NUI->server pass-through registrar (client.nui).
local proxyCallback = require 'client.nui'

---@type string[] NUI action suffixes proxied 1:1 to sd-phone:server:streaks:<action>. 'watch'
---subscribes/unsubscribes this phone to live gallery pushes (post/like) while the app is open.
local ACTIONS = { 'sync', 'post', 'gallery', 'like', 'leaderboard', 'watch' }

-- Thin delegates into server/streaks.
for _, action in ipairs(ACTIONS) do
    proxyCallback('sd-phone:streaks:' .. action, 'sd-phone:server:streaks:' .. action)
end

---Server push (fan-out to every client): another player posted; relays the new post.
---@param data table post record from server/streaks/live.lua
RegisterNetEvent('sd-phone:client:streaks:newPost', function(data)
    SendNUIMessage({ action = 'sd-phone:streaks:newPost', data = data })
end)

---Server push (fan-out to every client): a post's like state changed; relays the patch.
---@param data table post patch from server/streaks/live.lua
RegisterNetEvent('sd-phone:client:streaks:postChanged', function(data)
    SendNUIMessage({ action = 'sd-phone:streaks:postChanged', data = data })
end)

---Server push: an admin command changed our streak server-side; tells the app to re-sync.
RegisterNetEvent('sd-phone:client:streaks:refresh', function()
    SendNUIMessage({ action = 'sd-phone:streaks:refresh' })
end)
