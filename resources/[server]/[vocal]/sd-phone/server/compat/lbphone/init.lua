-- Server half of the lb-phone compatibility shim: when enabled, and the real lb-phone is not
-- running, the domain files below register lb-phone's server export names against sd-phone's modules.

local compatConvar = GetConvar('sd_phone_lbcompat', 'true')
if compatConvar == 'false' or compatConvar == '0' then return end

---Whether a started resource named lb-phone is the sd-phone name-holder shim rather than the
---real product.
---@return boolean
local function isShimLbPhone()
    return GetResourceMetadata('lb-phone', 'sd_phone_shim', 0) == 'yes'
end

---Whether a REAL resource named `name` exists on this server. The sd-phone shim holds the
---lb-phone name and is deliberately ignored.
---@param name string
---@return boolean
local function hasRealResource(name)
    for i = 0, GetNumResources() - 1 do
        if GetResourceByFindIndex(i) == name then
            return name ~= 'lb-phone' or not isShimLbPhone()
        end
    end
    return false
end

if hasRealResource('lb-phone') then
    local state = GetResourceState('lb-phone')
    if state == 'started' or state == 'starting' then
        print('^3[sd-phone]^0 lb-phone compat: the real lb-phone resource is running, so the compat layer is NOT registering its exports. Stop or remove lb-phone to let sd-phone answer for it.')
        return
    end
end

---@type table Shared shim helpers (server.compat.lbphone.shared): mid-session deregistration.
local shim = require 'server.compat.lbphone.shared'

---Deregisters the shim's export handlers when the real lb-phone starts mid-session.
AddEventHandler('onResourceStart', function(resource)
    if resource ~= 'lb-phone' or isShimLbPhone() then return end
    shim.deregisterAll()
    print('^3[sd-phone]^0 lb-phone compat: the REAL lb-phone resource just started, so the compat layer deregistered its export handlers and new lookups now resolve to lb-phone. Only already-cached callers keep the shim\'s functions until lb-phone next stops.')
end)

-- Loaded for side effects: each domain file registers its slice of lb-phone's server export
-- surface on require.
require 'server.compat.lbphone.phone'
require 'server.compat.lbphone.messages'
require 'server.compat.lbphone.mail'
require 'server.compat.lbphone.notifications'
require 'server.compat.lbphone.contacts'
require 'server.compat.lbphone.calls'
require 'server.compat.lbphone.misc'
-- events.lua mirrors sd-phone's first-party server lifecycle events under lb-phone's event names.
require 'server.compat.lbphone.events'
