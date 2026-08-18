fx_version 'cerulean'
game 'gta5'
author 'pScripts [tebex.pscripts.store]'
lua54 'yes'
description 'pScripts Inventory Clothing Items - ox_inventory'
version '1.0.3'

client_scripts {
    'client/*.lua',
    'client/appearance/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

ox_libs {
    'locale',
    'table',
}

escrow_ignore {
    'config.lua',
    'server/editable.lua'
}

dependencies {
    'ox_lib',
    'ox_inventory',
    'p_bridge',
    'illenium-appearance',
}

exports {
    'togglePed',
    'updatePed',
    'getClothingSlots',
    'trackClothing',
    'syncClothingItems',
}

files {'locales/*.json'}