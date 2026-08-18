---@type table Shared server helpers (server.util): index, column and constraint bootstrap.
local util = require 'server.util'

---@type table Store module; the table returned at end of file.
local store = {}

---Create the review tables if they don't exist. Run once at boot. Three tables: reviews, a
---helpful-vote join table, and boss-edited display overrides.
function store.ensureSchema()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `phone_review_reviews` (
            `id`          INT AUTO_INCREMENT PRIMARY KEY,
            `business_id` VARCHAR(60)  NOT NULL,
            `citizenid`   VARCHAR(60)  NOT NULL,
            `author`      VARCHAR(80)  NOT NULL,
            `rating`      TINYINT      NOT NULL,
            `body`        TEXT         NOT NULL,
            `image`       VARCHAR(512) NULL,
            `created_at`  BIGINT       NOT NULL,
            UNIQUE KEY `uniq_biz_cid` (`business_id`, `citizenid`),
            KEY `business_id` (`business_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `phone_review_helpful` (
            `review_id`  INT         NOT NULL,
            `citizenid`  VARCHAR(60) NOT NULL,
            `created_at` BIGINT      NOT NULL,
            PRIMARY KEY (`review_id`, `citizenid`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS `phone_review_business_meta` (
            `business_id` VARCHAR(60)  NOT NULL PRIMARY KEY,
            `hours`       VARCHAR(64)  NULL,
            `blurb`       VARCHAR(200) NULL,
            `logo`        VARCHAR(16)  NULL,
            `updated_by`  VARCHAR(60)  NULL,
            `updated_at`  BIGINT       NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]])

    -- Referential integrity, added on boot so existing installs migrate with no manual SQL.
    -- Each is a no-op once present; orphaned children are cleared first (they point at a
    -- parent that is already gone) and a type or collation mismatch is skipped, never fatal.
    util.ensureForeignKey('phone_review_helpful', 'review_id', 'phone_review_reviews', 'id', 'fk_review_helpful_review')
end

---Every saved boss override, one { business_id, hours, blurb, logo } row each. Read-only.
---@return table rows override rows (possibly empty)
function store.overrides()
    return MySQL.query.await('SELECT business_id, hours, blurb, logo FROM `phone_review_business_meta`') or {}
end

---Insert or replace a business's overridden display fields (upsert). Nil fields store as NULL.
---`cid`/`ts` record who last edited and when.
---@param businessId string config business id
---@param hours string|nil override opening hours
---@param blurb string|nil override one-line description
---@param logo string|nil override #RRGGBB tile colour
---@param cid string editor's citizenid
---@param ts integer unix seconds of the edit
function store.setOverride(businessId, hours, blurb, logo, cid, ts)
    MySQL.query.await([[
        INSERT INTO `phone_review_business_meta` (business_id, hours, blurb, logo, updated_by, updated_at)
        VALUES (?, ?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE hours = VALUES(hours), blurb = VALUES(blurb), logo = VALUES(logo),
                                updated_by = VALUES(updated_by), updated_at = VALUES(updated_at)
    ]], { businessId, hours, blurb, logo, cid, ts })
end

---The caller's existing review id for a business, or nil.
---@param businessId string config business id
---@param citizenid string author's citizenid
---@return integer|nil id existing review id, nil when they haven't reviewed it
function store.reviewIdFor(businessId, citizenid)
    return MySQL.scalar.await(
        'SELECT id FROM `phone_review_reviews` WHERE business_id = ? AND citizenid = ?',
        { businessId, citizenid })
end

---Insert a new review.
---@param businessId string config business id
---@param citizenid string author's citizenid (server-stamped)
---@param author string author display name (server-stamped)
---@param rating integer star rating 1-5 (validated by the caller)
---@param body string review text, capped to the column width by the caller
---@param image string|nil optional image url, capped to the column width by the caller
---@param ts integer unix seconds the review was created (server-stamped)
---@return integer reviewId
function store.insert(businessId, citizenid, author, rating, body, image, ts)
    return MySQL.insert.await(
        'INSERT INTO `phone_review_reviews` (business_id, citizenid, author, rating, body, image, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)',
        { businessId, citizenid, author, rating, body, image, ts })
end

---Most-recent reviews for one business, newest-first, capped at `limit`. Read-only.
---@param businessId string config business id
---@param limit integer max rows (config.Review.ReviewsPerBusiness)
---@return table rows review rows (possibly empty)
function store.reviewsFor(businessId, limit)
    return MySQL.query.await(
        'SELECT * FROM `phone_review_reviews` WHERE business_id = ? ORDER BY created_at DESC LIMIT ?',
        { businessId, limit }) or {}
end

---Per-business { business_id, cnt, avg } across every review. Read-only.
---@return table rows aggregate rows (possibly empty)
function store.aggregate()
    return MySQL.query.await(
        'SELECT business_id, COUNT(*) AS cnt, AVG(rating) AS avg FROM `phone_review_reviews` GROUP BY business_id') or {}
end

---{ business_id, rating } rows for the caller's own reviews. Read-only.
---@param citizenid string caller's citizenid
---@return table rows (possibly empty)
function store.myRatings(citizenid)
    return MySQL.query.await(
        'SELECT business_id, rating FROM `phone_review_reviews` WHERE citizenid = ?', { citizenid }) or {}
end

---The citizenid that authored a review (nil when the review doesn't exist). Read-only.
---@param id integer review id
---@return string|nil citizenid
function store.ownerOf(id)
    return MySQL.scalar.await('SELECT citizenid FROM `phone_review_reviews` WHERE id = ?', { id })
end

---Remove a review and its helpful votes.
---@param id integer review id (ownership already verified by the caller)
function store.delete(id)
    MySQL.query.await('DELETE FROM `phone_review_reviews` WHERE id = ?', { id })
    MySQL.query.await('DELETE FROM `phone_review_helpful` WHERE review_id = ?', { id })
end

---{ review_id, cnt } helpful-vote counts for one business's reviews. Read-only.
---@param businessId string config business id
---@return table rows (possibly empty)
function store.helpfulMapForBusiness(businessId)
    return MySQL.query.await([[
        SELECT h.review_id AS review_id, COUNT(*) AS cnt
        FROM `phone_review_helpful` h
        JOIN `phone_review_reviews` r ON r.id = h.review_id
        WHERE r.business_id = ?
        GROUP BY h.review_id
    ]], { businessId }) or {}
end

---Review ids within one business the caller has marked helpful. Read-only.
---@param businessId string config business id
---@param citizenid string caller's citizenid
---@return table rows { review_id } rows (possibly empty)
function store.myHelpedForBusiness(businessId, citizenid)
    return MySQL.query.await([[
        SELECT h.review_id AS review_id
        FROM `phone_review_helpful` h
        JOIN `phone_review_reviews` r ON r.id = h.review_id
        WHERE r.business_id = ? AND h.citizenid = ?
    ]], { businessId, citizenid }) or {}
end

---Current helpful-vote count for one review. Read-only.
---@param reviewId integer review id
---@return integer count
function store.helpfulCount(reviewId)
    return MySQL.scalar.await('SELECT COUNT(*) FROM `phone_review_helpful` WHERE review_id = ?', { reviewId }) or 0
end

---Toggle the caller's helpful vote on a review: delete the vote if it exists, insert it if not.
---@param reviewId integer review id
---@param citizenid string voter's citizenid
---@param ts integer unix seconds of the vote
---@return boolean helped true if the vote now exists, false if it was removed
function store.toggleHelpful(reviewId, citizenid, ts)
    local exists = MySQL.scalar.await(
        'SELECT 1 FROM `phone_review_helpful` WHERE review_id = ? AND citizenid = ?', { reviewId, citizenid })
    if exists then
        MySQL.query.await('DELETE FROM `phone_review_helpful` WHERE review_id = ? AND citizenid = ?', { reviewId, citizenid })
        return false
    end
    MySQL.insert.await(
        'INSERT INTO `phone_review_helpful` (review_id, citizenid, created_at) VALUES (?, ?, ?)',
        { reviewId, citizenid, ts })
    return true
end

return store
