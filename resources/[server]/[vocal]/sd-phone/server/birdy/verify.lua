---@type table<string, true> Badge types the React VerifiedBadge can draw. Kept here rather than
---in configs/birdy.lua because it is not a preference: adding a name the component cannot render
---would store fine and then fall back to the blue check, handing out the paid badge by accident.
local TYPES = { blue = true, gold = true, grey = true }

local verify = { TYPES = TYPES }

---Turns admin or command input into a storable badge type.
---@param raw any handle-supplied value; 'none'/''/nil all mean "clear the badge"
---@return string|nil vtype badge type, or nil to unverify
---@return boolean ok false when raw named a type outside TYPES
function verify.parse(raw)
    if raw == nil or raw == false then return nil, true end
    if raw == true then return 'blue', true end
    if type(raw) ~= 'string' then return nil, false end

    local v = raw:lower():gsub('%s', '')
    -- Both spellings reach the same badge: 'gray' is a plausible enough typo that failing on it
    -- would read as the command being broken.
    if v == 'gray' then v = 'grey' end
    if v == '' or v == 'none' or v == 'off' or v == 'remove' then return nil, true end
    if not TYPES[v] then return nil, false end
    return v, true
end

---Comma-joined type list for error messages, so the vocabulary is never written out twice.
---@return string
function verify.list()
    local out = {}
    for k in pairs(TYPES) do out[#out + 1] = k end
    table.sort(out)
    return table.concat(out, ', ')
end

return verify
