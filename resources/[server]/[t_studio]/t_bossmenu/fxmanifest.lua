fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'seigneuratoshit / conversion RageUI V2 TanjiroDev'
description 'Boss menu ESX Legacy converti en RageUI V2'
version '2.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    'shared/*.lua'
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

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

files {
    'locales/*.json'
}

dependencies {
    'es_extended',
    'oxmysql',
    'ox_lib',
    'ox_target',
    'esx_addonaccount'
}
