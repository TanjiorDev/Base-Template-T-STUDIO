Config = {}

---@param Config.PlayerPed: boolean [true/false] - Show player ped in middle of inventory?
Config.PlayerPed = true

---@param Config.PauseMenuPedSlot: number [1 = center, 2 = right] - Pause menu ped position
Config.PauseMenuPedSlot = 1

---@param Config.SaveClothing: boolean [true = Script will move old clothes items to inventory when changing clothes]
Config.SaveClothing = false

---@param Config.WaitForLoad: boolean [true = Script will use function to check if player is loaded, can be fix for spawning without clothes]
Config.WaitForLoad = false

---@param Config.DisableItemsOverrideOnSpawn: boolean [true = Script will disable items override when player spawns (Use if you have issues with clothing items being overridden with default on spawn)]
Config.DisableItemsOverrideOnSpawn = false 

---@param Config.DisableResourceCheck: boolean [true = Script will not print info about not started appearance resource]
Config.DisableResourceCheck = false 

---@class Config.Appearance: string - The appearance system you are using
--- IMPORTANT: Set 'illenium-appearance' for 17Mov Character System!!
--- IMPORTANT: Set 'esx_skin' for p_appearance!
Config.Appearance = 'illenium-appearance'
Config['17MovAppearance'] = false -- Set to true if you are using 17Mov Character System with their appearance, false if you use different appearance
--[[
    'esx_skin' - ESX Skin
    'qb-clothing' - QB Clothing
    'illenium-appearance' - Illenium Appearance
    'rcore_clothing' - RCore Clothing
    'crm-appearance' - CRM Appearance
    'qs-appearance' - QS Appearance
    '4bit_appearance' - 4Bit Appearance
    '0r-clothing' - 0r Clothing
    'qf_skin' - QF Skin
    'codem-appearance' - Codem Appearance
]]

---@class Config.BlacklistedItems: table <itemName: {inventoryType: {giveTo: boolean, takeFrom: boolean}}>
---@field inventoryType ["player", "otherplayer", "drop", "stash", "trunk", "glovebox"]
Config.BlacklistedItems = {
    ['WEAPON_PISTOL'] = { -- WEAPON_PISTOL item
        ['player'] = { -- Blacklist for inventory type "drop"
            ['giveTo'] = true, -- Block giving this item to this inventory type
            ['takeFrom'] = true, -- Block taking this item from this inventory type
        },
        ['drop'] = { -- Blacklist for inventory type "drop"
            ['giveTo'] = true, -- Block giving this item to this inventory type
            ['takeFrom'] = true, -- Block taking this item from this inventory type
        },
    }
}
    
---@class Config.ToggleHair: table - The hair styles to toggle to when using the toggle hair function
Config.ToggleHair = {
    ['male'] = {37, 0}, -- hair and texture
    ['female'] = {0, 0} -- hair and texture
}

---@class Config.ClothingSlots: table: {slotNumber: {itemName: string, skin: table}} - The clothing slots and their default clothing items
Config.ClothingSlots = {
    -- DONT TOUCH IT! SCRIPT WILL ASSIGN AUTOMATICALLY SLOTS IF YOU ARE USING DIFFERENT AMOUNT OF SLOTS!
    [1] = {
        itemName = 'clothes_hat',
        skin = {
            ['male'] = {['helmet_1'] = -1, ['helmet_2'] = -1},
            ['female'] = {['helmet_1'] = -1, ['helmet_2'] = -1}
        }
    },
    [2] = {
        itemName = 'clothes_ears',
        skin = {
            ['male'] = {['ears_1'] = -1, ['ears_2'] = 0},
            ['female'] = {['ears_1'] = -1, ['ears_2'] = 0}
        }
    },
    [3] = {
        itemName = 'clothes_tshirt',
        skin = {
            ['male'] = {['tshirt_1'] = 15, ['tshirt_2'] = 0},
            ['female'] = {['tshirt_1'] = 15, ['tshirt_2'] = 0}
        }
    },
    [4] = {
        itemName = 'clothes_torso',
        skin = {
            ['male'] = {['torso_1'] = 15, ['torso_2'] = 0},
            ['female'] = {['torso_1'] = 15, ['torso_2'] = 0}
        }
    },
    [5] = {
        itemName = 'clothes_arms',
        skin = {
            ['male'] = {['arms'] = 15, ['arms_2'] = 0},
            ['female'] = {['arms'] = 15, ['arms_2'] = 0}
        }
    },
    [6] = {
        itemName = 'clothes_pants',
        skin = {
            ['male'] = {['pants_1'] = 14, ['pants_2'] = 0},
            ['female'] = {['pants_1'] = 14, ['pants_2'] = 0}
        }
    },
    [7] = {
        itemName = 'clothes_shoes',
        skin = {
            ['male'] = {['shoes_1'] = 34, ['shoes_2'] = 0},
            ['female'] = {['shoes_1'] = 34, ['shoes_2'] = 0}
        }
    },
    [8] = {
        itemName = 'clothes_mask',
        skin = {
            ['male'] = {['mask_1'] = 0, ['mask_2'] = 0},
            ['female'] = {['mask_1'] = 0, ['mask_2'] = 0}
        }
    },
    [9] = {
        itemName = 'clothes_glasses',
        skin = {
            ['male'] = {['glasses_1'] = -1, ['glasses_2'] = 0},
            ['female'] = {['glasses_1'] = -1, ['glasses_2'] = 0}
        }
    },
    [10] = {
        itemName = 'clothes_vest',
        skin = {
            ['male'] = {['bproof_1'] = 0, ['bproof_2'] = 0},
            ['female'] = {['bproof_1'] = 0, ['bproof_2'] = 0}
        }
    },
    [11] = {
        itemName = 'clothes_bag',
        skin = {
            ['male'] = {['bags_1'] = 0, ['bags_2'] = 0},
            ['female'] = {['bags_1'] = 0, ['bags_2'] = 0}
        }
    },
    [12] = {
        itemName = 'clothes_watch',
        skin = {
            ['male'] = {['watches_1'] = -1, ['watches_2'] = 0},
            ['female'] = {['watches_1'] = -1, ['watches_2'] = 0}
        }
    },
    [13] = {
        itemName = 'clothes_chain',
        skin = {
            ['male'] = {['chain_1'] = 0, ['chain_2'] = 0},
            ['female'] = {['chain_1'] = 0, ['chain_2'] = 0}
        }
    },
    [14] = {
        itemName = 'clothes_bracelet',
        skin = {
            ['male'] = {['bracelets_1'] = -1, ['bracelets_2'] = 0},
            ['female'] = {['bracelets_1'] = -1, ['bracelets_2'] = 0}
        }
    },
}