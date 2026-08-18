-- Groups app - persistent player-formed groups (crews, posses, squads).
-- Backed by three oxmysql tables (see `server/groups/store.lua`). Online-only
-- invites in v0.1 - the target must be connected when invited (the invite row
-- itself survives until accepted/declined).
return {
    -- Per-leader cap on simultaneously-led groups. Prevents one player
    -- spamming dozens of dead groups.
    MaxOwnedPerPlayer = 5,

    -- Hard cap on members per group, including the leader. iOS Messages caps
    -- groups at 32; we go a touch tighter.
    MaxMembersPerGroup = 16,

    -- Outgoing-invite cap, per group. Resets as invites are accepted/declined.
    MaxPendingInvitesPerGroup = 20,

    -- Group name validation. Min keeps lists readable; max matches the React
    -- `<input maxLength={40} />`.
    MinNameLength = 2,
    MaxNameLength = 40,
}
