---@type table Store module; the table returned at end of file.
local store = {}

---Create the radio tables if they don't exist. `phone_radio` holds one prefs row per character
---(last frequency + volume); `phone_radio_saved` holds their named channels. Run once at boot.
function store.ensureSchema()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `phone_radio` (
            `citizenid` VARCHAR(64)  NOT NULL,
            `frequency` DECIMAL(5,1) NOT NULL DEFAULT 1.0,
            `volume`    INT          NOT NULL DEFAULT 50,
            PRIMARY KEY (`citizenid`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `phone_radio_saved` (
            `id`         INT AUTO_INCREMENT PRIMARY KEY,
            `citizenid`  VARCHAR(64)  NOT NULL,
            `label`      VARCHAR(40)  NOT NULL,
            `frequency`  DECIMAL(5,1) NOT NULL,
            `created_at` BIGINT       NOT NULL,
            KEY `citizenid` (`citizenid`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
end

---Saved radio prefs for a character, or nil when they've never tuned in. Read-only.
---@param citizenid string framework per-character id
---@return table|nil row { frequency, volume }
function store.get(citizenid)
    return MySQL.single.await('SELECT frequency, volume FROM `phone_radio` WHERE citizenid = ?', { citizenid })
end

---Persist a character's last frequency + volume (upsert).
---@param citizenid string framework per-character id
---@param frequency number one-decimal frequency
---@param volume integer volume 0-100
function store.save(citizenid, frequency, volume)
    MySQL.prepare.await(
        'INSERT INTO `phone_radio` (citizenid, frequency, volume) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE frequency = VALUES(frequency), volume = VALUES(volume)',
        { citizenid, frequency, volume })
end

---A character's saved (named) channels, oldest-first. Read-only.
---@param citizenid string framework per-character id
---@return table rows { id, label, frequency }[]
function store.listSaved(citizenid)
    return MySQL.query.await(
        'SELECT id, label, frequency FROM `phone_radio_saved` WHERE citizenid = ? ORDER BY id ASC',
        { citizenid }) or {}
end

---How many saved channels a character has.
---@param citizenid string framework per-character id
---@return integer n
function store.countSaved(citizenid)
    local row = MySQL.single.await('SELECT COUNT(*) AS n FROM `phone_radio_saved` WHERE citizenid = ?', { citizenid })
    return row and tonumber(row.n) or 0
end

---Insert one saved channel and hand back its row id.
---@param citizenid string framework per-character id
---@param label string display name (caller-capped to the column width)
---@param frequency number one-decimal frequency
---@param ts integer unix seconds created stamp
---@return integer insertId
function store.addSaved(citizenid, label, frequency, ts)
    return MySQL.insert.await(
        'INSERT INTO `phone_radio_saved` (citizenid, label, frequency, created_at) VALUES (?, ?, ?, ?)',
        { citizenid, label, frequency, ts })
end

---Update one saved channel. Scoped to the owner (id AND citizenid).
---@param citizenid string framework per-character id
---@param id integer saved-channel row id
---@param label string display name
---@param frequency number one-decimal frequency
function store.updateSaved(citizenid, id, label, frequency)
    MySQL.prepare.await(
        'UPDATE `phone_radio_saved` SET label = ?, frequency = ? WHERE id = ? AND citizenid = ?',
        { label, frequency, id, citizenid })
end

---Delete one saved channel, scoped to the owner like updateSaved.
---@param citizenid string framework per-character id
---@param id integer saved-channel row id
function store.removeSaved(citizenid, id)
    MySQL.prepare.await('DELETE FROM `phone_radio_saved` WHERE id = ? AND citizenid = ?', { id, citizenid })
end

return store
