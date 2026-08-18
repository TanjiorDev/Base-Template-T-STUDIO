-- Weather app - pulls live in-game weather + world time from whichever
-- weathersync is running, so the Los Santos forecast reflects the real server
-- state and the day/night background follows the GTA clock. Supported syncs are
-- auto-detected; weather + time still work (off game natives) even with none.
--
-- Note: neither supported sync models a real temperature / humidity / UV /
-- multi-day forecast - GTA has no such concept - so those stay derived in the
-- app from the live weather + each city's climate profile.
return {
    Enabled = true,

    -- 'auto' picks the first started resource from the list below. Set an exact
    -- name to force one. The native fallback means weather/time work regardless.
    System = 'auto',

    -- Checked in order when System = 'auto'. Add a custom/renamed sync here.
    Resources = { 'Renewed-Weathersync', 'qb-weathersync' },
}
