-- Find Friends settings - the live location-sharing app (Find My style).
return {
    -- Maximum friends a player can add.
    MaxFriends = 50,

    -- How often (ms) live friend positions are pushed to a player who has the
    -- Find Friends app open. Coordinates are read server-side, so this is the
    -- only thing that controls the on-screen refresh rate. 3s is smooth without
    -- being chatty; raise it if you have a very high player count.
    UpdateInterval = 3000,
}
