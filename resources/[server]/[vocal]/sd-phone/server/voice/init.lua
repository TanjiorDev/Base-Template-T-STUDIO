---@type table sd-phone config root (configs/config.lua).
local config = require 'configs.config'
---@type table Player bridge (bridge.server.player): citizenid/name/phone-number lookups.
local player = require 'bridge.server.player'
---@type table Shared server helpers (server.util): rate limiting + client-payload validation.
local util   = require 'server.util'

---@type table Voice config (configs/voice.lua): nearby-capture switches + TURN provisioning.
local CFG   = config.Voice or {}
---@type number Capture radius in metres - how close another player must be to be recordable.
local RANGE = tonumber(CFG.NearbyRange) or 12.0
---@type integer Cap on simultaneous nearby voices mixed into one recording (bandwidth/CPU guard).
local MAXN  = tonumber(CFG.MaxNearbyVoices) or 6
---@type table Public STUN server URLs, always offered to every peer connection.
local STUN  = CFG.StunServers or { 'stun:stun.l.google.com:19302' }
---@type table TURN provisioning config (CFG.Turn): Provider + TtlSeconds.
local TURN  = CFG.Turn or {}

---@return boolean true when nearby-voice capture is switched on (config.Voice.RecordNearbyVoices)
local function enabled() return CFG.RecordNearbyVoices == true end

-- ICE provisioning for the client-to-client WebRTC mesh that captures nearby players' voices.
-- The Cloudflare credentials are issued per TTL, not per player, so one entry serves the whole
-- server; a per-src cache let every concurrent caller miss during the first request's yield and
-- issue its own, so one client could fan a burst of outbound HTTPS calls at Cloudflare.
---@type { servers: table, expires: number }|nil Shared ICE server list.
local iceCache = nil
---@type table|nil In-flight provisioning promise; concurrent callers await it instead of refetching.
local icePending = nil

---The always-available STUN portion of an iceServers list, built fresh so callers can append.
---@return table servers array of { urls = string }
local function baseStun()
    local servers = {}
    for _, url in ipairs(STUN) do servers[#servers + 1] = { urls = url } end
    return servers
end

---Provisions a Cloudflare Realtime TURN credential set from the sd_cf_turn_* convars. Returns
---nil when unconfigured or on any transport/decode failure.
---@return table|nil iceServers Cloudflare's iceServers object, nil on failure
local function fetchCloudflareTurn()
    local tokenId  = GetConvar('sd_cf_turn_token_id', '')
    local apiToken = GetConvar('sd_cf_turn_api_token', '')
    if tokenId == '' or apiToken == '' then return nil end

    local ttl = tonumber(TURN.TtlSeconds) or 86400
    local p = promise.new()
    PerformHttpRequest(
        ('https://rtc.live.cloudflare.com/v1/turn/keys/%s/credentials/generate-ice-servers'):format(tokenId),
        function(status, body)
            if status ~= 201 or not body then return p:resolve(nil) end
            local ok, decoded = pcall(json.decode, body)
            p:resolve(ok and decoded and decoded.iceServers or nil)
        end,
        'POST',
        json.encode({ ttl = ttl }),
        {
            ['Authorization'] = 'Bearer ' .. apiToken,
            ['Content-Type']  = 'application/json',
            ['Accept']        = 'application/json',
        }
    )
    return Citizen.Await(p)
end

---@type integer Seconds a failed TURN provisioning is cached for. Short enough that a transient
---Cloudflare outage heals on its own, long enough that it can never become a request loop.
local ICE_FAILURE_TTL = 60

---ICE servers: STUN always, TURN appended when the Cloudflare provider is configured. Cached
---server-wide until a minute before the provisioned credential lapses, with one shared flight.
---@return table servers iceServers array for RTCPeerConnection
local function iceServers()
    if iceCache and iceCache.expires > os.time() then return iceCache.servers end
    if icePending then return Citizen.Await(icePending) end

    local p = promise.new()
    icePending = p

    local servers = baseStun()
    local provisioned = true
    if TURN.Provider == 'cloudflare' then
        local ok, turn = pcall(fetchCloudflareTurn)
        if ok and turn then servers[#servers + 1] = turn else provisioned = false end
    end

    local ttl = provisioned and ((tonumber(TURN.TtlSeconds) or 86400) - 60) or ICE_FAILURE_TTL
    iceCache = { servers = servers, expires = os.time() + ttl }
    -- Cleared before the resolve so anyone woken by it reads the fresh cache, never a stale flight.
    icePending = nil
    p:resolve(servers)
    return servers
end

---Live ped coords for a player, nil when they have no ped (disconnecting / not spawned).
---@param src number player server id
---@return vector3|nil coords
local function coordsOf(src)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return nil end
    return GetEntityCoords(ped)
end

---True if `a` and `b` are within `range` metres of each other, from live server-side coords;
---false when either has no ped.
---@param a number player server id
---@param b number player server id
---@param range number metres
---@return boolean within
local function withinRange(a, b, range)
    local ca, cb = coordsOf(a), coordsOf(b)
    if not ca or not cb then return false end
    return #(ca - cb) <= range
end

---Players (other than `src`) within RANGE metres, nearest first, capped to MAXN. Positions are
---read server-side at query time; the trimmed result carries only id + display name.
---@param src number recorder server id
---@return { id: number, name: string }[] targets
local function nearbyTargets(src)
    local origin = coordsOf(src)
    if not origin then return {} end

    local found = {}
    for _, pid in ipairs(GetPlayers()) do
        local tgt = tonumber(pid)
        if tgt and tgt ~= src then
            local c = coordsOf(tgt)
            if c then
                local dist = #(origin - c)
                if dist <= RANGE then
                    found[#found + 1] = { id = tgt, name = player.getName(tgt), dist = dist }
                end
            end
        end
    end

    table.sort(found, function(a, b) return a.dist < b.dist end)
    local out = {}
    for i = 1, math.min(#found, MAXN) do
        out[#out + 1] = { id = found[i].id, name = found[i].name }
    end
    return out
end

---ICE servers for this client's peer connections. Read-only; served from the shared cache.
lib.callback.register('sd-phone:server:voice:ice', function()
    return { success = true, data = { iceServers = iceServers() } }
end)

---@type integer Nearby-lookup budget window in ms.
local NEARBY_WINDOW = 60000
---@type integer Lookups allowed per window. The client asks once when a recording starts, so this
---is far above any human, and it bounds the GetPlayers coord scan the callback pays for.
local NEARBY_PER_WINDOW = 30

---Who the recorder can capture right now (+ its ICE servers). Proximity is computed server-side;
---empty when the feature is disabled or the caller is over budget.
lib.callback.register('sd-phone:server:voice:nearby', function(src)
    if not enabled() or not util.rateLimit(player.getIdentifier(src), 'voice:nearby', NEARBY_WINDOW, NEARBY_PER_WINDOW) then
        return { success = true, data = { targets = {}, iceServers = iceServers() } }
    end
    return { success = true, data = { targets = nearbyTargets(src), iceServers = iceServers() } }
end)

---@type table<string, boolean> Signal kinds the mesh actually sends (web/src/media/nearbyVoice.ts).
local SIGNAL_KINDS = { offer = true, answer = true, ice = true }
---@type integer Byte ceiling on one SDP description. The mesh is audio-only, so a real offer runs
---about 2 KB; this is more than ten times that.
local SDP_BYTES = 32768
---@type integer Byte ceiling on one trickled ICE candidate (~200 bytes in practice).
local CANDIDATE_BYTES = 2048
---@type integer Signal-relay budget window in ms.
local SIGNAL_WINDOW = 10000
---@type integer Candidates allowed per window. Negotiating a full MAXN mesh trickles roughly a
---hundred, so this leaves several times the worst legitimate burst.
local CANDIDATES_PER_WINDOW = 400
---@type integer Descriptions allowed per window. A full MAXN mesh needs about a dozen, and the
---client only negotiates when a recording starts.
local SDP_PER_WINDOW = 60

---Relays one WebRTC signaling message (offer/answer/ICE candidate) to another player. Proximity
---is re-checked on every hop (1.5x RANGE) and `from` is stamped from the trusted source. Shape
---and size are validated before the coord lookups so an oversized blob is dropped for free.
---@param payload table { to: number, sid?: any, kind?: any, data?: any }
RegisterNetEvent('sd-phone:server:voice:signal', function(payload)
    local src = source
    if type(payload) ~= 'table' then return end
    local to = tonumber(payload.to)
    if not to or not enabled() then return end

    -- Bounded but never rewritten: both peers key their session map on this exact string, so a
    -- trim here would silently break the reply hop.
    local sid = payload.sid
    if type(sid) ~= 'string' or sid == '' or #sid > 64 then return end
    if not SIGNAL_KINDS[payload.kind] then return end
    -- Descriptions and candidates differ by two orders of magnitude in both size and count, so
    -- they get their own budget; one shared limit would have to be loose enough for the worst of both.
    local ice = payload.kind == 'ice'
    -- The mesh sends objects here ({ type, sdp } or a candidate), never bare strings.
    local data = util.smallTable(payload.data, 16, ice and CANDIDATE_BYTES or SDP_BYTES)
    if not data then return end
    local cid = player.getIdentifier(src)
    if ice then
        if not util.rateLimit(cid, 'voice:signal:ice', SIGNAL_WINDOW, CANDIDATES_PER_WINDOW) then return end
    elseif not util.rateLimit(cid, 'voice:signal:sdp', SIGNAL_WINDOW, SDP_PER_WINDOW) then
        return
    end
    if not withinRange(src, to, RANGE * 1.5) then return end

    TriggerClientEvent('sd-phone:client:voice:signal', to, {
        from = src,
        sid  = sid,
        kind = payload.kind,
        data = data,
    })
end)
