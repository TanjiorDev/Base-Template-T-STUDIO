-- Pages app - the "yellow pages" classifieds board. Posts are server-wide and
-- persist; the feed shows everyone's, "Your Posts" shows the caller's own. A
-- blank contact number on a new post falls back to the poster's number.
return {
    ListLimit            = 100,  -- most-recent posts returned to the feed
    MaxPostsPerPlayer    = 15,
    MinTitleLength       = 1,
    MaxTitleLength       = 60,
    MinBodyLength        = 1,
    MaxBodyLength        = 500,
    MaxPrice             = 999999999,  -- price cap; no price = a "wanted" post
    MaxImageUrlLength    = 512,
    MaxImages            = 3,    -- photos attachable to a post
    MaxContactLength     = 20,
}
