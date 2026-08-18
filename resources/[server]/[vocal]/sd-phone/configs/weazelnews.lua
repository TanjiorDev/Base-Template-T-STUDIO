-- Weazel News app - the in-world Los Santos broadcast network. Articles and the
-- red "Breaking" ticker are stored in the database (both start empty) and edited
-- in-app by news staff. Everyone can read; only staff can publish.
return {
    -- Framework job name(s) whose players staff Weazel News: the cogwheel
    -- dashboard, post/edit/delete, and the breaking-headline editor.
    Jobs           = { 'reporter' },

    -- When true, only a boss of a listed job manages (QBCore/QBox `isboss` flag;
    -- ESX uses BossGrade below), optionally widened by ManageMinGrade. When false,
    -- ANYONE on a listed job can manage at any grade - use this when the job has
    -- no boss flag (e.g. a `reporter` job whose top grade isn't flagged `isboss`).
    CheckIsBoss    = false,

    -- ESX-only boss threshold (ESX has no `isboss` flag): grade >= this on a
    -- listed job counts as boss.
    BossGrade      = 0,

    -- Optional grade threshold, only used when CheckIsBoss = true. When set, a
    -- player on a listed job at grade >= this can manage even without the boss
    -- flag - e.g. 3 lets grade-3 "editor" ranks publish. Leave nil for boss only.
    ManageMinGrade = nil,

    -- Hard caps for staff-authored content.
    MaxHeadlineLength = 140,
    MaxDekLength      = 240,
    MaxBodyLength     = 8000,   -- whole article body (all paragraphs)
    MaxImageUrlLength = 512,
    MaxBreakingLines  = 8,      -- ticker headlines kept, in order
    MaxBreakingLength = 200,    -- per ticker line

    -- Most-recent articles returned to the app.
    ArticlesPerFeed   = 60,

    -- Allowed article categories. Must match the web `Category` union in
    -- web/src/apps/weazelnews/data.ts.
    Categories = { 'Local', 'Crime', 'Politics', 'Business', 'Sports', 'Entertainment', 'Tech', 'Weather' },
}
