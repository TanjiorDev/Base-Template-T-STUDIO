---@type table Prefs store module; the table returned at end of file.
local store = {}

local util = require 'server.util'
local isTruthy = util.truthy

---Creates the phone_service_prefs table if it doesn't exist and back-fills the job_messages
---column; toggles default to ON.
function store.ensureSchema()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS phone_service_prefs (
            citizenid    VARCHAR(64) NOT NULL,
            job          VARCHAR(64) NOT NULL,
            duty         TINYINT(1)  NOT NULL DEFAULT 1,
            job_calls    TINYINT(1)  NOT NULL DEFAULT 1,
            job_messages TINYINT(1)  NOT NULL DEFAULT 1,
            updated_at   TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (citizenid, job)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]])

    local hasCol = MySQL.scalar.await([[
        SELECT COUNT(*) FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'phone_service_prefs' AND COLUMN_NAME = 'job_messages'
    ]])
    if not hasCol or hasCol == 0 then
        MySQL.query.await('ALTER TABLE phone_service_prefs ADD COLUMN job_messages TINYINT(1) NOT NULL DEFAULT 1 AFTER job_calls')
    end
end

---@type integer How long a cached prefs entry is reused, in ms. A backstop under the explicit
---invalidation below: the rows are also rewritten from outside this module (admin wipe, SIM backup
---restore), and an entry that never expires would stay wrong until the character disconnected.
local PREFS_TTL = 30000
---@type table<string, table<string, { at: number, prefs: table }>> Prefs by citizenid then job.
---Company calls and company messages read one employee's prefs per online player, so an uncached
---read made every fan-out an O(online) burst of blocking queries. Every writer below invalidates;
---a drop clears the character.
local cache = {}

---Drops a character's cached prefs, so the next read reloads them from the row just written.
---@param citizenid string
---@param job string
local function invalidate(citizenid, job)
    local byCid = cache[citizenid]
    if byCid then byCid[job] = nil end
end

util.onCleanup(function(_, citizenid)
    if citizenid then cache[citizenid] = nil end
end)

---Reads a character's prefs for a job; unset (or blank keys) all default to ON. The returned table
---is shared with the cache: callers read it, never mutate it.
---@param citizenid string
---@param job string
---@return { duty: boolean, jobCalls: boolean, jobMessages: boolean }
function store.getPrefs(citizenid, job)
    if not citizenid or citizenid == '' or not job or job == '' then
        return { duty = true, jobCalls = true, jobMessages = true }
    end
    local byCid = cache[citizenid]
    local hit = byCid and byCid[job]
    if hit and (GetGameTimer() - hit.at) < PREFS_TTL then return hit.prefs end

    local row = MySQL.single.await(
        'SELECT duty, job_calls, job_messages FROM phone_service_prefs WHERE citizenid = ? AND job = ?',
        { citizenid, job })
    local prefs = row
        and { duty = isTruthy(row.duty), jobCalls = isTruthy(row.job_calls), jobMessages = isTruthy(row.job_messages) }
        or  { duty = true, jobCalls = true, jobMessages = true }

    if not byCid then byCid = {}; cache[citizenid] = byCid end
    byCid[job] = { at = GetGameTimer(), prefs = prefs }
    return prefs
end

---Persists the Duty toggle for a (character, job), leaving the other toggles intact.
---@param citizenid string
---@param job string
---@param on boolean
function store.setDuty(citizenid, job, on)
    if not citizenid or citizenid == '' or not job or job == '' then return end
    MySQL.update.await([[
        INSERT INTO phone_service_prefs (citizenid, job, duty) VALUES (?, ?, ?)
        ON DUPLICATE KEY UPDATE duty = VALUES(duty)
    ]], { citizenid, job, on and 1 or 0 })
    invalidate(citizenid, job)
end

---Persists the Job-Calls toggle for a (character, job), leaving the other toggles intact.
---@param citizenid string
---@param job string
---@param on boolean
function store.setJobCalls(citizenid, job, on)
    if not citizenid or citizenid == '' or not job or job == '' then return end
    MySQL.update.await([[
        INSERT INTO phone_service_prefs (citizenid, job, job_calls) VALUES (?, ?, ?)
        ON DUPLICATE KEY UPDATE job_calls = VALUES(job_calls)
    ]], { citizenid, job, on and 1 or 0 })
    invalidate(citizenid, job)
end

---Persists the Job-Messages toggle for a (character, job), leaving the other toggles intact.
---@param citizenid string
---@param job string
---@param on boolean
function store.setJobMessages(citizenid, job, on)
    if not citizenid or citizenid == '' or not job or job == '' then return end
    MySQL.update.await([[
        INSERT INTO phone_service_prefs (citizenid, job, job_messages) VALUES (?, ?, ?)
        ON DUPLICATE KEY UPDATE job_messages = VALUES(job_messages)
    ]], { citizenid, job, on and 1 or 0 })
    invalidate(citizenid, job)
end

---Forgets a character's per-job preferences (duty, company calls, company messages) across every
---job, dropping the cached copies with them so the next read reloads the defaults.
---@param citizenid string framework per-character id
function store.resetFor(citizenid)
    if not citizenid or citizenid == '' then return end
    cache[citizenid] = nil
    MySQL.update.await('DELETE FROM phone_service_prefs WHERE citizenid = ?', { citizenid })
end
return store
