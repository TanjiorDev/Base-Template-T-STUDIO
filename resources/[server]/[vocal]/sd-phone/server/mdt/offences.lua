---@type table sd-phone config root (configs/config.lua); read for the charge-line cap.
local config = require 'configs.config'
---@type table Shared server helpers (server.util): envelopes, clamping, string caps.
local util   = require 'server.util'
---@type table MDT permissions (server.mdt.access): the read gate.
local access = require 'server.mdt.access'
---@type table[] The penal code (configs/penalcode.lua): a static catalogue, not a table.
local PENAL  = require 'configs.penalcode'

---@type table Offences module; the table returned at end of file. The penal code, and the single
---place a sentence or a fine is ever calculated.
local offences = {}

---@type table<string, boolean> Valid charge classes; mirrors the ChargeClass union.
local CLASSES = { felony = true, misdemeanor = true, infraction = true }

---@type integer Highest count one charge line may carry.
local MAX_COUNT = 99

---@type integer Charge lines one record may carry.
local MAX_LINES = math.floor(tonumber(((config.Mdt or {}).Limits or {}).Charges) or 40)

---@type table<string, integer> Class sort order: felonies read first, then down.
local CLASS_ORDER = { felony = 1, misdemeanor = 2, infraction = 3 }

---@type table|nil Catalog built once from the config: { rows = Offence[], byCode = ... }.
local cache

---Builds the catalog from the config file. A malformed entry is skipped with a console line rather
---than taken on trust: a charge with no class would otherwise sentence at zero months forever.
---@return table catalog { rows: table[], byCode: table<string, table> }
local function load()
    if cache then return cache end

    local rows, byCode = {}, {}
    for i = 1, #PENAL do
        local entry = PENAL[i]
        local code  = type(entry) == 'table' and type(entry.code) == 'string' and entry.code or nil
        if not code or not CLASSES[entry.class] then
            print(('^3[sd-phone:mdt]^0 penal code entry %d is malformed and was skipped'):format(i))
        elseif byCode[code] then
            print(('^3[sd-phone:mdt]^0 penal code %s is listed twice; the first wins'):format(code))
        else
            local row = {
                code        = code,
                label       = type(entry.label) == 'string' and entry.label or code,
                class       = entry.class,
                months      = math.max(0, math.floor(tonumber(entry.months) or 0)),
                fine        = math.max(0, math.floor(tonumber(entry.fine) or 0)),
                description = type(entry.description) == 'string' and entry.description or '',
            }
            rows[#rows + 1] = row
            byCode[code] = row
        end
    end

    table.sort(rows, function(a, b)
        local ca, cb = CLASS_ORDER[a.class] or 9, CLASS_ORDER[b.class] or 9
        if ca ~= cb then return ca < cb end
        return a.code < b.code
    end)

    cache = { rows = rows, byCode = byCode }
    return cache
end

---Every offence, felonies first then by code.
---@return table[] rows
function offences.all()
    return load().rows
end

---One offence by code, or nil when it is not in the catalog.
---@param code any
---@return table|nil offence
function offences.byCode(code)
    if type(code) ~= 'string' then return nil end
    return load().byCode[code]
end

---Resolves charge lines against the catalog and totals them. Months and fine are ALWAYS looked up
---here, never taken from the caller, so every screen quotes the same sentence. Line figures stay
---per unit; the totals are what multiply by count.
---@param charges any list of { code: string, count?: number, citizenid?: string }
---@return table[] lines resolved lines { code, label, class, citizenid, count, months, fine }
---@return integer months total months across every line
---@return integer fine total fine across every line
function offences.totalFor(charges)
    local lines, months, fine = {}, 0, 0
    if type(charges) ~= 'table' then return lines, 0, 0 end

    local byCode = load().byCode
    for i = 1, #charges do
        local c = charges[i]
        if type(c) == 'table' and #lines < MAX_LINES then
            local offence = byCode[type(c.code) == 'string' and c.code or '']
            if offence then
                local count = math.floor(tonumber(c.count) or 1)
                if count < 1 then count = 1 end
                if count > MAX_COUNT then count = MAX_COUNT end

                lines[#lines + 1] = {
                    code      = offence.code,
                    label     = offence.label,
                    class     = offence.class,
                    citizenid = (type(c.citizenid) == 'string' and c.citizenid ~= '') and c.citizenid or nil,
                    count     = count,
                    months    = offence.months,
                    fine      = offence.fine,
                }
                months = months + (offence.months * count)
                fine   = fine + (offence.fine * count)
            end
        end
    end

    return lines, months, fine
end

---Class counters for a resolved charge list, as a warrant row stores them.
---@param lines table[] resolved charge lines
---@return integer felonies
---@return integer misdemeanors
---@return integer infractions
function offences.countByClass(lines)
    local felonies, misdemeanors, infractions = 0, 0, 0
    for i = 1, #lines do
        local line = lines[i]
        if line.class == 'felony' then felonies = felonies + line.count
        elseif line.class == 'misdemeanor' then misdemeanors = misdemeanors + line.count
        else infractions = infractions + line.count end
    end
    return felonies, misdemeanors, infractions
end

---The whole penal code. Read by the charge picker, every report total and the jail quote.
offences.list = access.gated('offences.view', function()
    return util.ok({ rows = offences.all() })
end)

return offences
