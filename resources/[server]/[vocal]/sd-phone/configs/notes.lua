-- Notes app - private per-character notes. Body text + inline sketches (PNG
-- data URLs) persist server-side, keyed by citizenid, so they follow the
-- character across sessions and devices.
return {
    MaxNotesPerPlayer = 200,
    MaxBodyLength     = 20000,  -- characters of text per note
    MaxSketches       = 12,     -- inline drawings per note
    MaxImages         = 20,     -- attached photo URLs per note
}
