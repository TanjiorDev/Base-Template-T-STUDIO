fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'TanjiroDev / RageUI k2r'
description 'Menu personnel F5 complet RageUI rouge et blanc - ESX Legacy'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'RageUI/RMenu.lua',
    'RageUI/menu/RageUI.lua',
    'RageUI/menu/Menu.lua',
    'RageUI/menu/MenuController.lua',
    'RageUI/components/*.lua',
    'RageUI/menu/elements/*.lua',
    'RageUI/menu/items/*.lua',
    'RageUI/menu/panels/*.lua',
    'RageUI/menu/windows/*.lua',
    'RageUI/configk2r.lua',
    'clothes/client/utils.lua',
    'clothes/client/client-clothes.lua',
    'client.lua'
}

server_scripts {
    'server.lua',
    'clothes/server/server-clothes.lua'
}

dependencies {
    'es_extended',
    'ox_lib',
    'ox_inventory'
}
