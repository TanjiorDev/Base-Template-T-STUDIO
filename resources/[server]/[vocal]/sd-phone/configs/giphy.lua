-- GIFs (GIPHY). The Messages GIF picker pulls from GIPHY's API. (Tenor's API
-- stopped accepting new clients in Jan 2026 and shut down, so we use GIPHY.)
-- The API KEY is NOT here: this file, like every configs/*.lua, ships to connected
-- clients via fxmanifest files{}, so anything in it is readable by a determined
-- player. Put the key in configs/server/apikeys.lua (server-only, never shipped)
-- instead. Only the two display tunables below ship to clients.
return {
    Limit  = 24,          -- GIFs fetched per search / trending request
    Rating = 'pg-13',     -- content rating filter: g, pg, pg-13, or r
}
