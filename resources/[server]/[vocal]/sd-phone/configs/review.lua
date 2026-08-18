-- Review app - a Yelp-style business reviews directory. The business list is curated here
-- (server-authoritative); players can only browse and review the entries below, never add their
-- own. Reviews are persisted per-character and aggregated into a star rating. One review per
-- character per business - posting again updates the existing one.
return {
    ReviewsPerBusiness = 100,   -- most-recent reviews returned per business
    MinBodyLength      = 1,
    MaxBodyLength      = 600,
    MaxImageUrlLength  = 512,

    -- ESX-only boss threshold: a player on a business's `job` at grade >= this is
    -- treated as its boss. QBCore/QBox ignore this and use the job's `isboss`
    -- flag instead.
    BossGrade          = 4,
    -- Hard caps for boss-edited fields.
    MaxHoursLength     = 40,
    MaxBlurbLength     = 140,

    -- Filter chips, shown in this order. A business `category` must match one of
    -- these exactly, or it won't be reachable from any chip (still searchable).
    Categories = { 'Food', 'Auto', 'Nightlife', 'Shopping', 'Services', 'Health', 'Hotels' },

    -- Each business:
    --   id        unique key (also the review foreign key - keep stable once live)
    --   name      display name
    --   category  must match one of `Categories` above (drives the filter chips)
    --   address   free-text location shown under the name
    --   hours     free-text opening hours
    --   phone     contact number (raw digits) - blank hides the call/message buttons
    --   blurb     one-line description on the detail header
    --   logo      a hex colour; the UI draws a tinted tile with the name's initial
    --   job       (optional) framework job name that owns this business. A player who
    --             is currently on this job AND flagged as its boss (QBCore `isboss`;
    --             ESX uses `BossGrade` above) can edit the hours / blurb / logo from
    --             the app. Bosses CANNOT delete reviews. Omit `job` to lock a
    --             business's details to whatever is configured here.
    Businesses = {
        { id = 'beanmachine', name = 'Bean Machine Coffee',     category = 'Food',      address = 'Alta St, Downtown',           hours = '6am – 8pm',     phone = '',           blurb = 'Artisan roasts and fresh pastries in the heart of the city.', logo = '#6F4E37' },
        { id = 'cluckinbell', name = "Cluckin' Bell",           category = 'Food',      address = 'Route 68, Grand Senora',      hours = '10am – 2am',    phone = '',           blurb = 'Fried chicken done the only way that matters.',               logo = '#E03131' },
        { id = 'upnatom',     name = 'Up-n-Atom Burger',        category = 'Food',      address = 'Vinewood Blvd',               hours = '11am – 11pm',   phone = '',           blurb = 'Classic burgers, shakes and atomic fries.',                  logo = '#F08C00' },
        { id = 'lscustoms',   name = 'Los Santos Customs',      category = 'Auto',      address = 'Greenwich Pkwy, La Mesa',     hours = '24 hours',      phone = '',           blurb = 'Repairs, resprays and full custom builds.',                  logo = '#1C7ED6', job = 'mechanic' },
        { id = 'pdm',         name = 'Premium Deluxe Motorsport', category = 'Auto',    address = 'Adams Apple Blvd',            hours = '9am – 6pm',     phone = '',           blurb = 'The finest pre-owned vehicles in Los Santos.',               logo = '#212529', job = 'cardealer' },
        { id = 'bahamamamas', name = 'Bahama Mamas',            category = 'Nightlife', address = 'San Andreas Ave, Downtown',   hours = '9pm – 4am',     phone = '',           blurb = 'Upscale club, bottle service and a packed dance floor.',     logo = '#9C36B5' },
        { id = 'tequilala',   name = 'Tequi-la-la',             category = 'Nightlife', address = 'Western, West Vinewood',      hours = '8pm – 3am',     phone = '',           blurb = 'Live music, strong cocktails, late nights.',                 logo = '#0CA678' },
        { id = 'ponsonbys',   name = "Ponsonbys",               category = 'Shopping',  address = 'Portola Dr, Rockford Hills',  hours = '10am – 7pm',    phone = '',           blurb = 'High-end fashion for those who can afford it.',              logo = '#495057' },
        { id = 'discount247', name = '24/7 Supermarket',        category = 'Shopping',  address = 'Various locations',           hours = '24 hours',      phone = '',           blurb = 'Snacks, drinks and essentials around the clock.',            logo = '#2F9E44' },
        { id = 'morsmutual',  name = 'Mors Mutual Insurance',   category = 'Services',  address = 'Power St, Downtown',          hours = '8am – 6pm',     phone = '',           blurb = 'Vehicle insurance and recovery. Death not covered.',         logo = '#364FC7' },
        { id = 'pillbox',     name = 'Pillbox Medical Center',  category = 'Health',    address = 'Strawberry Ave',              hours = '24 hours',      phone = '',           blurb = 'Emergency care and check-ups, day or night.',                logo = '#E64980', job = 'ambulance' },
        { id = 'voncrasten',  name = 'The Von Crastenburg',     category = 'Hotels',    address = 'Las Lagunas Blvd',            hours = '24 hours',      phone = '',           blurb = 'Five-star luxury stays in Downtown Los Santos.',             logo = '#C2255C' },
    },
}
