fx_version 'cerulean'
game 'gta5'

author 'Trowe'
description 'Marketi'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua',
    '@ox_lib/init.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

locales 'en'

ui_page 'nui/index.html'

files {
    'nui/index.html',
    'nui/style.css',
    'nui/app.js',
    'locales/en.json',
    'locales/sr.json'
}

dependencies {
    'es_extended',
    'ox_target',
    'ox_lib',
    'oxmysql'
}
