-- Birdy app - the in-game microblog (posts, likes, follows, DMs, alerts).
-- Content is per-character, stored in the phone_birdy_* tables created on
-- resource start.
return {
    -- New profiles start unverified. Flip to true to hand everyone the blue
    -- check, or set a badge per-account with /birdyverify <handle> <type>.
    DefaultVerified = false,

    -- Buying the blue check from inside the app (Profile > Edit profile).
    -- Only blue is ever purchasable: the gold business and grey government
    -- badges assert who someone is, so they stay staff-granted through the
    -- admin panel or /birdyverify. Set Enabled = false to hide the row.
    Verification = {
        Enabled = true,
        Price   = 25000,
        Account = 'bank',
    },

    -- Max length of a post / reply body. Mirrors the React composer's
    -- maxLength so client and server agree.
    MaxPostLength = 280,

    -- Max length of a direct message.
    MaxDmLength = 500,

    -- Posts returned per feed load (newest first).
    FeedLimit = 50,

    -- Days of post history the Search tab's trending-hashtag counts look at.
    TrendingWindowDays = 7,

    -- Notifications returned per alerts-tab load.
    NotificationLimit = 50,

    -- Account field bounds, mirrored by the React register/login forms.
    MaxNameLength     = 32,
    MinHandleLength   = 2,
    MaxHandleLength   = 15,
    MinPasswordLength = 4,
    MaxPasswordLength = 64,
    MaxBioLength      = 160,
}
