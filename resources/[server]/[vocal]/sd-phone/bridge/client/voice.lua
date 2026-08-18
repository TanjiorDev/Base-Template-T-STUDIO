---@type table Detected voice backend (bridge.shared.voice): resource name + API dialect.
local backend = require 'bridge.shared.voice'

---@type string|nil Resource exports are invoked on.
local RESOURCE = backend.resource
---@type string|nil API dialect: 'pma-voice' or 'saltychat'.
local PROVIDER = backend.provider

---@type number SaltyChat's radio volume ceiling. Its SetRadioVolume clamps to 0.0-1.6 where
---pma-voice takes the phone's own 0-100, so the two cannot share a number.
local SALTY_VOLUME_MAX <const> = 1.6

---@type table Module table; the table returned at end of file. One API over the supported voice
---scripts, so no app module has to know which one is running.
local voice = {}

---@type boolean Local transmit state, tracked from SaltyChat's own event because it has no
---native to poll. Mumble backends read the native instead and never touch this.
local saltyTalking = false

if PROVIDER == 'saltychat' then
    AddEventHandler('SaltyChat_TalkStateChanged', function(isTalking)
        saltyTalking = isTalking == true
    end)
end

---Detected voice resource name, or nil when none is running. Read-only.
---@return string|nil
function voice.resource() return RESOURCE end

---Detected API dialect ('pma-voice' | 'saltychat'), or nil. Read-only.
---@return string|nil
function voice.provider() return PROVIDER end

---What this backend can actually do, for callers that must not offer a control the running voice
---script cannot honour.
---
---`mute` is the one that matters: SaltyChat is TeamSpeak-based, so every Mumble native the phone
---would mute with is a silent no-op there, and SaltyChat exposes its mic state as READ-ONLY with
---no setter at any scope. A Mute button on that backend would look like it worked and do nothing,
---so the call UI drops it instead.
---@return { mute: boolean, callVolume: boolean, transmitState: boolean, radio: boolean }
function voice.capabilities()
    return {
        mute          = PROVIDER == 'pma-voice',
        callVolume    = PROVIDER == 'pma-voice',
        transmitState = PROVIDER ~= nil,
        radio         = PROVIDER ~= nil,
    }
end

---Mutes or unmutes the local mic for call AND proximity.
---
---Switching the voice target to 0 (the default, which carries no call channels) keeps audio off
---the call channel; zeroing the input distance silences proximity too.
---@param on boolean true to mute
---@return boolean handled false when the backend has no way to mute
function voice.setMuted(on)
    if PROVIDER ~= 'pma-voice' then return false end
    if on then
        MumbleSetVoiceTarget(0)
        MumbleSetAudioInputDistance(0.0)
    else
        MumbleSetVoiceTarget(1)
        MumbleSetAudioInputDistance(9999.0)
    end
    return true
end

---How loud the other party sounds, 0-100.
---@param volume number 0-100
---@return boolean handled
function voice.setCallVolume(volume)
    if PROVIDER ~= 'pma-voice' or not RESOURCE then return false end
    return pcall(function() exports[RESOURCE]:setCallVolume(volume) end)
end

---Joins or leaves a radio channel. Channel 0 means leave.
---
---The channel arrives as the integer the Radio app derives from the frequency; SaltyChat names
---channels with STRINGS, so the same 125 has to go over as '125' or it joins nothing.
---@param channel integer 0 to leave
---@return boolean handled
function voice.setRadioChannel(channel)
    if not RESOURCE then return false end
    channel = math.floor(tonumber(channel) or 0)

    if PROVIDER == 'saltychat' then
        if channel <= 0 then
            return pcall(function() exports[RESOURCE]:SetRadioChannel(nil, true) end)
        end
        return pcall(function() exports[RESOURCE]:SetRadioChannel(tostring(channel), true) end)
    end

    return pcall(function() exports[RESOURCE]:setRadioChannel(channel) end)
end

---Radio loudness on the phone's own 0-100 scale.
---@param volume number 0-100
---@return boolean handled
function voice.setRadioVolume(volume)
    if not RESOURCE then return false end
    volume = tonumber(volume) or 0
    if volume < 0 then volume = 0 elseif volume > 100 then volume = 100 end

    if PROVIDER == 'saltychat' then
        local level = volume / 100.0 * SALTY_VOLUME_MAX
        return pcall(function() exports[RESOURCE]:SetRadioVolume(level) end)
    end

    return pcall(function() exports[RESOURCE]:setRadioVolume(volume) end)
end

---Subscribes to "am I transmitting on the radio right now", for the on-air indicator.
---
---The two backends announce it differently: pma-voice fires a single boolean, SaltyChat reports
---all four traffic directions and only the two TRANSMIT halves mean the local player is keying up
---- passing its receive flags through would light the indicator whenever anyone else spoke.
---@param handler fun(active: boolean)
function voice.onRadioTransmit(handler)
    if PROVIDER == 'saltychat' then
        AddEventHandler('SaltyChat_RadioTrafficStateChanged', function(_, primaryTransmit, _, secondaryTransmit)
            handler(primaryTransmit == true or secondaryTransmit == true)
        end)
        return
    end

    AddEventHandler('pma-voice:radioActive', function(active)
        handler(active == true)
    end)
end

---Whether the local player is transmitting voice in-game. Fails OPEN (reported as talking) when
---the backend cannot say, so a recording never silently captures nothing.
---@return boolean transmitting
function voice.isTransmitting()
    if PROVIDER == 'saltychat' then return saltyTalking end

    local ok, talking = pcall(MumbleIsPlayerTalking, cache.playerId)
    if not ok then return true end
    return talking == true or talking == 1
end

return voice
