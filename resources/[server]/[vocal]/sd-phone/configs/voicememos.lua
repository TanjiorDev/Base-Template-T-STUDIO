-- Voice Memos app. Recordings are captured in the phone UI, uploaded to
-- Fivemanage (same media key as Photos - configs/server/apikeys.lua FivemanageMedia) and the
-- hosted URL is persisted per character.
return {
    ListLimit     = 100,            -- most-recent memos returned to the app
    MaxPerPlayer  = 200,
    MaxNameLength = 80,
    MaxAudioBytes = 12 * 1024 * 1024, -- ~12 MB base64 (a few minutes of audio)
}
