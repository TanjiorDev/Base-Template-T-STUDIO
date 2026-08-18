fx_version 'cerulean'
game 'gta5'

author 'ESX-Framework / RageUI V2 conversion'
description 'Official Multicharacter System For ESX Legacy - RageUI V2 edition'
version '1.10.1-rageui-v2'
lua54 'yes'

dependencies {
    'es_extended',
    'esx_identity',
    'oxmysql',
    'spawnmanager',
    'skinchanger',
    'esx_skin'
}

shared_scripts {
    '@es_extended/imports.lua',
    '@es_extended/locale.lua',
    'locales/*.lua',
    'config.lua',
    'rageui_config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
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
    'client/*.lua'
}
