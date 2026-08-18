---@class FrameworkInfo
---@field name 'qbx'|'qb'|'esx' Detected framework identifier.
---@field qb boolean True for both QBox and QBCore, whose player objects share a shape.
---@field core any Live core object (QBCore's, or the ESX shared object). Nil on QBox, which has
---no core object: everything it needs is a discrete qbx_core export.

---Detects the running player framework and returns a populated FrameworkInfo, or nil when no
---supported framework is started. QBox is checked first so it is driven through its own exports
---rather than through the qb-core compatibility layer it provides.
---@return FrameworkInfo|nil
local function detect()
    if GetResourceState('qbx_core') == 'started' then
        return { name = 'qbx', qb = true }
    end
    if GetResourceState('qb-core') == 'started' then
        return { name = 'qb', qb = true, core = exports['qb-core']:GetCoreObject() }
    end
    if GetResourceState('es_extended') == 'started' then
        return { name = 'esx', qb = false, core = exports['es_extended']:getSharedObject() }
    end
    return nil
end

---@type FrameworkInfo|nil Detection result; nil aborts the resource load below.
local info = detect()

if not info then
    error([[
        ^1CRITICAL ERROR: No supported framework detected!^0
        ^3This resource requires one of the following frameworks:^0
        - QBox (qbx_core)
        - QBCore (qb-core)
        - ESX (es_extended)

        Please ensure your framework is started before this resource.
    ]])
end

print(('^2[SD-PHONE]^0 Framework detected: ^3%s^0'):format(info.name))

return info
