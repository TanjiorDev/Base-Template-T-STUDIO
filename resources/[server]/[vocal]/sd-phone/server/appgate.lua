---@type table sd-phone config root (configs/config.lua).
local config = require 'configs.config'
---@type table Job bridge (bridge.server.job): the player's live framework job.
local job    = require 'bridge.server.job'

---@type table App gate; the table returned at end of file. Answers one question for the client:
---which apps must NOT appear on this player's home screen right now.
---
---configs/apps.lua decides which apps a SERVER has. This decides which of them a PLAYER can see,
---and it exists because the answer changes with the job they are holding. The client has no job
---awareness of its own, so it asks on every open and gets the answer for the character that is
---actually loaded.
local appgate = {}

---@type table MDT config (configs/mdt.lua).
local MDT = config.Mdt or {}

---@type boolean Whether the terminal runs on this server at all.
local MDT_ENABLED = MDT.Enabled == true

---@type table<string, string> Framework job name -> terminal domain, built from the departments
---the MDT is already configured with. Deriving it here rather than repeating the job names in
---configs/apps.lua is what keeps a new department from silently having no app: add it to
---Mdt.Departments and its members get the right icon on their next open.
local TERMINAL_JOBS = {}
for _, dept in ipairs(MDT.Departments or {}) do
    if dept.job then
        local kind = dept.type
        TERMINAL_JOBS[dept.job] = (kind == 'ems' or kind == 'doj') and kind or 'leo'
    end
end

---@type table<string, string> App id -> the domain that may see it.
local TERMINAL_APPS = {
    mdt    = 'leo',
    emsmdt = 'ems',
    dojmdt = 'doj',
}

---Every app id this player must not be shown.
---@param src integer player server id
---@return string[] ids
function appgate.hidden(src)
    local out = {}

    -- With no terminal on the server, or no terminal job, every terminal app is hidden. A player
    -- who is neither police nor a medic sees neither icon rather than one that refuses them.
    local domain = MDT_ENABLED and TERMINAL_JOBS[job.getName(src) or ''] or nil
    for id, needs in pairs(TERMINAL_APPS) do
        if needs ~= domain then out[#out + 1] = id end
    end

    table.sort(out)
    return out
end

---The client asks on every open, so a job change between opens is picked up with no event to miss.
---Deliberately ungated: a civilian is a valid caller and gets the full hidden list back.
lib.callback.register('sd-phone:server:apps:hidden', function(src)
    return appgate.hidden(src)
end)

return appgate
