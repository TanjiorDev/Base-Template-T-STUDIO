-- Streaks app - one fresh camera photo per real-world day builds a consecutive-day
-- streak. Hitting a milestone pays out cash. Everyone's daily photos land in a
-- shared gallery (with likes) and a leaderboard ranks current streaks.
return {
    -- Map of streak-day threshold -> cash reward. Re-earnable each run: because a
    -- streak only grows by 1 per day, each threshold is hit (and paid) exactly once
    -- per run, then again after a reset.
    Milestones    = {
        [1]  = 100,   [3]  = 250,   [5]  = 500,   [8]  = 900,
        [12] = 1500,  [16] = 2200,  [21] = 3200,  [27] = 4500,
        [34] = 6500,  [42] = 9500,  [50] = 15000,
    },
    RewardAccount = 'bank',   -- where milestone cash is paid: 'bank' or 'cash'

    MaxCaptionLength = 120,   -- hard cap on the optional photo caption
    GalleryPageSize  = 30,    -- posts returned per gallery page (newest first)
    LeaderboardSize  = 25,    -- number of top current streaks shown
}
