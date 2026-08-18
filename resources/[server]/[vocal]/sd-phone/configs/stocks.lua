-- Stocks app - a shared, server-simulated market the whole server sees the same
-- prices on. Players move money from their bank into a separate brokerage wallet,
-- then buy/sell. Holdings, wallet cash, and prices persist in the DB.

return {
    TickSeconds   = 5,      -- how often every price moves
    HistoryPoints = 48,     -- price points kept per asset (drives the sparkline + % change)
    SaveSeconds   = 30,     -- batched DB write of prices + wallets
    Commission    = 0.005,  -- trade fee as a fraction, charged on buys AND sells (0.005 = 0.5%)
    StartingCash  = 0,      -- brokerage wallet starts empty; players deposit from their bank
    MinTrade      = 1,      -- smallest dollar value of a buy/sell/deposit/withdraw
    MaxTrade      = 1e9,    -- safety clamp on a single order's dollar value

    -- Global magnitude knobs. A move happens every TickSeconds, so the per-asset
    -- numbers below are scaled DOWN by these before each tick - that's what keeps
    -- the market drifting realistically (a percent or two over many minutes)
    -- instead of swinging double digits in a couple of minutes. Raise these to
    -- make the whole market livelier, lower them to calm it further.
    VolatilityScale = 0.06,   -- multiplies every asset's `volatility`
    DriftScale      = 0.012,  -- multiplies every asset's `trend`

    -- Market impact - big trades move the SHARED price. Buying pumps it, selling
    -- dumps it:  move% = ImpactScale * orderValue / liquidity  (capped at
    -- MaxImpact), applied on every buy/sell. Lower liquidity = easier to move.
    -- Any asset may override the depth with its own `liquidity = <dollars>`.
    ImpactScale = 0.5,        -- 0.5 ⇒ a $1M order at the default depth moves price ~25%
    Liquidity   = 2000000,    -- default market depth (dollars) per asset
    MaxImpact   = 0.5,        -- hard cap on one order's price move (fraction)

    -- Ownership / shares outstanding. Each asset has a fixed total supply of
    -- shares = MarketCap / basePrice, almost all of it held by "the market" (the
    -- institutional float). A player's stake is units / total supply, so buying a
    -- little shows as a tiny %, not 100%. A holder's % of supply ≈ their dollars
    -- invested / MarketCap. Bigger MarketCap = harder to corner; an asset may
    -- override with its own `marketCap = <dollars>`.
    MarketCap      = 50000000,  -- default valuation (sets the share count)
    WhaleThreshold = 0.1,       -- flag a holder as a "whale" at this share of supply

    -- Each tick every asset moves by:
    --   movePct = trend*DriftScale + volatility*VolatilityScale * gaussian()
    -- then the new price is clamped to [min, max]. Per asset you tune the
    -- RELATIVE aggressiveness; the *Scale values above set the overall magnitude:
    --   trend       directional bias  (+ = upward, - = downward, 0 = flat)
    --   volatility  jumpiness - relative std-dev of the move (crypto > stocks)
    --   min / max   hard price floor & ceiling
    --   basePrice   seed price on first ever boot (after that the live price persists)
    --   kind        'stock' or 'crypto' - routes the asset to the matching tab
    --   color       brand colour for the round token + sparkline accent
    Assets = {
        -- Stocks (GTA brands)
        { symbol = 'MZB', name = 'Maze Bank',      kind = 'stock', color = '#C0392B', basePrice = 215.40, volatility = 0.012, trend =  0.0008, min = 40,  max = 600,  marketCap = 250000000 },
        { symbol = 'TNK', name = 'Tinkle',         kind = 'stock', color = '#00B7EB', basePrice =  88.10, volatility = 0.018, trend =  0.0015, min = 10,  max = 400  },
        { symbol = 'VAP', name = 'Vapid',          kind = 'stock', color = '#2C3E50', basePrice = 142.75, volatility = 0.014, trend =  0.0004, min = 30,  max = 400  },
        { symbol = 'ECL', name = 'eCola',          kind = 'stock', color = '#E2231A', basePrice =  53.20, volatility = 0.013, trend = -0.0006, min = 10,  max = 200  },
        { symbol = 'SPK', name = 'Sprunk',         kind = 'stock', color = '#2ECC71', basePrice =  31.65, volatility = 0.020, trend =  0.0010, min = 5,   max = 150  },
        { symbol = 'CLK', name = "Cluckin' Bell",  kind = 'stock', color = '#F4C20D', basePrice =  24.90, volatility = 0.017, trend = -0.0012, min = 4,   max = 120  },
        { symbol = 'BSH', name = 'Burger Shot',    kind = 'stock', color = '#E4002B', basePrice =  19.30, volatility = 0.019, trend =  0.0006, min = 3,   max = 100  },
        { symbol = 'LFI', name = 'Lifeinvader',    kind = 'stock', color = '#2D6CDF', basePrice =  96.55, volatility = 0.025, trend = -0.0020, min = 8,   max = 400  },
        { symbol = 'MAI', name = 'Maibatsu',       kind = 'stock', color = '#8E8E93', basePrice =  64.20, volatility = 0.015, trend =  0.0009, min = 12,  max = 250  },
        { symbol = 'FLY', name = 'FlyUS',          kind = 'stock', color = '#1E66D0', basePrice =  12.45, volatility = 0.022, trend = -0.0008, min = 2,   max = 80   },
        { symbol = 'AMU', name = 'Ammu-Nation',    kind = 'stock', color = '#6B8E23', basePrice = 178.00, volatility = 0.016, trend =  0.0014, min = 40,  max = 500  },
        { symbol = 'RWD', name = 'Redwood',        kind = 'stock', color = '#8B0000', basePrice =  41.10, volatility = 0.012, trend = -0.0015, min = 8,   max = 150  },
        { symbol = 'RON', name = 'RON Oil',        kind = 'stock', color = '#ED1C24', basePrice = 134.60, volatility = 0.018, trend =  0.0010, min = 25,  max = 500  },
        { symbol = 'GPO', name = 'GoPostal',       kind = 'stock', color = '#1B5E20', basePrice =  47.80, volatility = 0.012, trend =  0.0003, min = 8,   max = 200  },
        { symbol = 'BIL', name = 'Bilkinton',      kind = 'stock', color = '#16A085', basePrice = 162.30, volatility = 0.020, trend =  0.0018, min = 30,  max = 500  },
        { symbol = 'FRT', name = 'Fruit',          kind = 'stock', color = '#9AA0A6', basePrice = 305.10, volatility = 0.016, trend =  0.0020, min = 60,  max = 900  },
        { symbol = 'VAN', name = 'Vangelico',      kind = 'stock', color = '#D4AF37', basePrice =  71.40, volatility = 0.014, trend =  0.0005, min = 15,  max = 250  },
        { symbol = 'WIZ', name = 'Whiz Wireless',  kind = 'stock', color = '#7B2FF7', basePrice =  58.90, volatility = 0.020, trend =  0.0012, min = 12,  max = 250  },
        { symbol = 'DY8', name = 'Dynasty 8',      kind = 'stock', color = '#B8860B', basePrice = 210.75, volatility = 0.015, trend =  0.0016, min = 40,  max = 600  },
        { symbol = 'PIS', name = 'Pisswasser',     kind = 'stock', color = '#C9A227', basePrice =  27.85, volatility = 0.018, trend = -0.0004, min = 5,   max = 120  },

        -- Crypto (GTA-flavoured)
        { symbol = 'SDC', name = 'SD Coin',        kind = 'crypto', color = '#2A7DE1', basePrice =   88.00, volatility = 0.040, trend =  0.0030, min = 5,    max = 5000,   marketCap = 35000000 },
        { symbol = 'BTL', name = 'BitLos',         kind = 'crypto', color = '#F7931A', basePrice = 38250.0, volatility = 0.030, trend =  0.0020, min = 5000, max = 150000 },
        { symbol = 'ETD', name = 'Etheriad',       kind = 'crypto', color = '#627EEA', basePrice = 2410.0,  volatility = 0.035, trend =  0.0025, min = 300,  max = 12000  },
        { symbol = 'SPC', name = 'SprunkCoin',     kind = 'crypto', color = '#FF7A00', basePrice =    4.82, volatility = 0.060, trend =  0.0010, min = 0.2,  max = 60,     marketCap = 6000000 },
        { symbol = 'MZC', name = 'MazeCoin',       kind = 'crypto', color = '#9B59B6', basePrice =   67.40, volatility = 0.050, trend = -0.0020, min = 5,    max = 500    },
        { symbol = 'FLC', name = 'FleecaCoin',     kind = 'crypto', color = '#00B894', basePrice =    9.42, volatility = 0.050, trend =  0.0020, min = 1,    max = 200    },
        { symbol = 'WZC', name = 'WeazelCoin',     kind = 'crypto', color = '#C8102E', basePrice =    0.85, volatility = 0.070, trend =  0.0010, min = 0.05, max = 25,     marketCap = 4000000 },
        { symbol = 'POG', name = 'PogoCoin',       kind = 'crypto', color = '#F1C40F', basePrice =    2.36, volatility = 0.065, trend = -0.0010, min = 0.1,  max = 40     },
        { symbol = 'VWC', name = 'VinewoodCoin',   kind = 'crypto', color = '#8E44AD', basePrice =  410.00, volatility = 0.040, trend =  0.0030, min = 40,   max = 8000   },
        { symbol = 'KIF', name = 'Kifflom Coin',   kind = 'crypto', color = '#1ABC9C', basePrice =   33.00, volatility = 0.055, trend =  0.0025, min = 3,    max = 800    },
    },
}
