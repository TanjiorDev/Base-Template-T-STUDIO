---@type table Shared server helpers (server.util): the { success, message?, data? } envelope.
local util      = require 'server.util'
---@type table MDT persistence (server.mdt.store): profiles, shift sessions, the penal-code read.
local store     = require 'server.mdt.store'
---@type table MDT permissions (server.mdt.access): identity, grants and the handler wrappers.
local access    = require 'server.mdt.access'
---@type table Reports and cases (server.mdt.paperwork): the recent-report column on Home.
local paperwork = require 'server.mdt.paperwork'
---@type table Bulletin board (server.mdt.bulletins): the middle column on Home.
local bulletins = require 'server.mdt.bulletins'
---@type table CAD (server.mdt.dispatch): the live unit list on Home.
local dispatch  = require 'server.mdt.dispatch'
---@type table Treatment protocols (server.mdt.protocols): the medical terminal's reference catalog.
local protocols = require 'server.mdt.protocols'
---@type table Penal code (server.mdt.offences): the police terminal's reference catalog.
local offences  = require 'server.mdt.offences'

---@type table Actions module; the table returned at end of file. Shell-level handlers only: the
---bootstrap every pane reads its session from, and the Home dashboard's single read. Both are
---exported already wrapped, so server/mdt/init.lua stays pure wiring.
local actions = {}

---@type integer Reports shown in the Recent Reports column.
local HOME_REPORTS = 12
---@type integer Bulletins shown in the Bulletin Board column.
local HOME_BULLETINS = 12

---The `data` table of an envelope, or an empty table when the call was refused. A column the
---caller has no permission for comes back empty rather than failing the whole dashboard.
---@param res any envelope returned by a domain handler
---@return table
local function dataOf(res)
    if type(res) ~= 'table' or res.success ~= true or type(res.data) ~= 'table' then return {} end
    return res.data
end

---Copies at most `limit` entries off the front of a list.
---@param rows any
---@param limit integer
---@return table[]
local function head(rows, limit)
    local out = {}
    if type(rows) ~= 'table' then return out end
    for i = 1, math.min(#rows, limit) do out[i] = rows[i] end
    return out
end

---The session every pane reads from: who the officer is, which department's terminal this is, the
---permission keys they actually hold, and the penal code the charge picker and every total are
---computed against. Opening the terminal also opens the shift row hours-on-shift sums.
---@param src integer player server id
---@param _payload table normalised payload, unused
---@param me table caller identity from access.identity
---@return table envelope with { me, department, grants, offences }
local function bootstrap(src, _payload, me)
    store.openSession(me.citizenid)

    local dept = me.department
    return util.ok({
        me = {
            citizenid  = me.citizenid,
            name       = me.name,
            callsign   = me.callsign,
            badge      = me.badge,
            radio      = me.radio,
            rank       = me.rank,
            gradeLevel = me.grade,
            avatar     = me.avatar,
            duty       = me.duty,
        },
        department = {
            job    = dept.job,
            label  = dept.label or dept.job,
            short  = dept.short or dept.job,
            type   = dept.type or 'leo',
            seal   = dept.seal or 'shield',
            accent = dept.accent or '#1D4ED8',
            bench  = dept.bench == true,
        },
        grants = access.grants(src),
        -- Each terminal is handed its own reference catalog and not the other's: the penal code is
        -- what a police charge picker resolves against, the protocol set is what a medical report
        -- attaches. Sending both would put the penal code in a medic's bundle for nothing.
        offences  = access.isMedical(me) and {} or offences.all(),
        protocols = access.isMedical(me) and protocols.all() or {},
    })
end

---The Home dashboard in one read: the newest reports the caller may see, the bulletin board, and
---the live unit list. Each column is composed from the same handler the section itself uses, so a
---column the caller has no permission for is simply empty and the dashboard still renders.
---@param src integer player server id
---@param _payload table normalised payload, unused
---@param _me table caller identity from access.identity
---@return table envelope with { recentReports, bulletins, units }
local function home(src, _payload, _me)
    local reports = dataOf(paperwork.reportsList(src, { page = 1 }))
    local board   = dataOf(bulletins.list(src, {}))
    local cad     = dataOf(dispatch.state(src, {}))

    return util.ok({
        recentReports = head(reports.rows, HOME_REPORTS),
        bulletins     = head(board.rows, HOME_BULLETINS),
        units         = type(cad.units) == 'table' and cad.units or {},
    })
end

---@type fun(src: integer, payload: any): table Bootstrap, gated on holding a terminal at all.
actions.bootstrap = access.open(bootstrap)

---@type fun(src: integer, payload: any): table Home dashboard, gated on holding a terminal at all.
actions.home = access.open(home)

return actions
