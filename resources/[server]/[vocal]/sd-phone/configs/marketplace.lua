-- Marketplace app - player-to-player classifieds. Listings are server-wide and
-- persist; the feed shows everyone's, "Your Posts" shows the caller's own. A
-- blank contact number on a new listing falls back to the poster's number.
return {
    ListLimit            = 100,  -- most-recent listings returned to the feed
    MaxListingsPerPlayer = 15,
    MinTitleLength       = 1,
    MaxTitleLength       = 60,
    MinBodyLength        = 1,
    MaxBodyLength        = 500,
    MaxPrice             = 999999999,  -- price cap; no price = a "wanted" post
    MaxImageUrlLength    = 512,
    MaxImages            = 3,    -- photos attachable to a listing
    MaxContactLength     = 20,
}
