-- Maps app settings. Pin storage caps, the Set-GPS behaviour toggle, and
-- the live "you are here" location dot.
return {
    -- Maximum pins persisted per character. Extra pins in a save payload
    -- are dropped server-side (the array is kept in the UI's order, which
    -- is newest-first).
    MaxMarkers = 50,

    -- Maximum characters kept from a pin label.
    MaxLabel = 40,

    -- Close the phone when "Set GPS" is tapped, so the player immediately
    -- sees the route on the minimap. Set false to keep the phone open (the
    -- Maps app draws the same road-following route line itself).
    CloseOnWaypoint = false,

    -- The People tab (live location sharing between players). false removes
    -- the tab from Maps entirely AND strips the live-share options from the
    -- chat location button, leaving only the one-time "share my current spot"
    -- confirm.
    People = true,

    -- Directions / ETA card (Apple-Maps style). Tapping a pin's navigate arrow
    -- shows distance + estimated time, then GO sets the minimap route.
    Navigation = {
        -- Assumed average speeds (metres/second) used to estimate arrival time.
        -- These are steady cruising figures (not the player's instantaneous
        -- speed) so the ETA doesn't jump around at red lights. ~16 m/s ≈ 36 mph
        -- average city driving; 1.7 m/s is a brisk walk.
        DriveSpeed = 16.0,
        WalkSpeed  = 1.7,

        -- 'metric'  → metres / kilometres.
        -- 'imperial'→ feet / miles.
        Units = 'metric',

        -- How often (ms) the open ETA card refreshes its distance/time while you
        -- move. The card polls the client for a fresh road-distance reading.
        RefreshInterval = 2500,
    },

    -- Live "you are here" dot (Apple-Maps style) shown on the Maps app.
    LiveLocation = {
        -- Master switch. false = no dot, and the client never starts the
        -- position-streaming thread.
        Enabled = true,

        -- Milliseconds between position pushes while the Maps app is open.
        -- 300ms is smooth without being chatty; the stream only runs while
        -- the Maps app is actually on screen.
        Interval = 300,
    },
}
