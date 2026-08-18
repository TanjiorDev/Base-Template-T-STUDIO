-- Cookie app (clicker mini-game) - per-character progress (cookies, upgrades,
-- achievements, rain toggle) persists server-side. The leaderboard ranks REAL
-- players by total cookies baked, shown by character name (or a custom alias).
return {
    LeaderboardLimit  = 25,
    MaxValue          = 1e15,  -- clamp saved cookies/earned to keep the board sane
    MaxNicknameLength = 20,

    -- Clients autosave every couple of seconds, but those only update an
    -- in-memory cache server-side. Progress is written to the DB on this
    -- interval (seconds) plus on disconnect / resource stop - so the DB sees
    -- one batched write per player per interval, not one every few seconds.
    SaveInterval      = 60,
}
