---@type table Shared server helpers (server.util): the { success, message?, data? } envelope.
local util   = require 'server.util'
---@type table MDT permissions (server.mdt.access): the read gate and the caller's domain.
local access = require 'server.mdt.access'
---@type table[] Standing orders (configs/sops.lua): a static catalogue, not a table.
local SOPS   = require 'configs.sops'

---@type table SOPs module; the table returned at end of file. Read-only by design: a standing
---order is policy a department publishes, not a record it accumulates, so there is nothing here
---but a filtered read of the config.
local sops = {}

---@type table<string, boolean> Terminals an order may be published to.
local TERMINALS = { leo = true, ems = true }

---@type table|nil Catalogue built once from the config, keyed by terminal.
local cache

---Builds the catalogue. An order with no code is skipped rather than shown blank, and one naming
---an unknown terminal is skipped rather than quietly published to everybody.
---@return table<string, table[]> byTerminal
local function load()
    if cache then return cache end

    local out = { leo = {}, ems = {} }
    local seen = {}

    for i = 1, #SOPS do
        local entry = SOPS[i]
        local code  = type(entry) == 'table' and type(entry.code) == 'string' and entry.code or nil
        local where = entry and entry.terminal

        if not code then
            print(('^3[sd-phone:mdt]^0 SOP entry %d has no code and was skipped'):format(i))
        elseif where ~= nil and not TERMINALS[where] then
            print(('^3[sd-phone:mdt]^0 SOP %s names unknown terminal %s and was skipped'):format(code, tostring(where)))
        elseif seen[code] then
            print(('^3[sd-phone:mdt]^0 SOP %s is listed twice; the first wins'):format(code))
        else
            seen[code] = true

            local jobs
            if type(entry.jobs) == 'table' then
                jobs = {}
                for n = 1, #entry.jobs do
                    if type(entry.jobs[n]) == 'string' then jobs[entry.jobs[n]] = true end
                end
            end

            local order = {
                code     = code,
                title    = type(entry.title) == 'string' and entry.title or code,
                category = type(entry.category) == 'string' and entry.category or 'General',
                summary  = type(entry.summary) == 'string' and entry.summary or '',
                revised  = type(entry.revised) == 'string' and entry.revised or '',
                body     = type(entry.body) == 'string' and entry.body or '',
                jobs     = jobs,
            }

            -- No terminal means both, which is how a joint order is published once.
            if where == nil or where == 'leo' then out.leo[#out.leo + 1] = order end
            if where == nil or where == 'ems' then out.ems[#out.ems + 1] = order end
        end
    end

    cache = out
    return cache
end

---The standing orders one caller may read: their terminal's set, minus anything scoped to other
---departments. Job scoping is applied here rather than on the client, so an order restricted to
---one force is not merely hidden from another, it is never sent.
sops.list = access.gated('sops.view', function(_, _, me)
    local domain = access.domain(me)
    local rows = load()[domain == 'ems' and 'ems' or 'leo'] or {}

    local out = {}
    for i = 1, #rows do
        local order = rows[i]
        if not order.jobs or order.jobs[me.job] then
            out[#out + 1] = {
                code     = order.code,
                title    = order.title,
                category = order.category,
                summary  = order.summary,
                revised  = order.revised,
                body     = order.body,
            }
        end
    end

    return util.ok({ rows = out })
end)

return sops
