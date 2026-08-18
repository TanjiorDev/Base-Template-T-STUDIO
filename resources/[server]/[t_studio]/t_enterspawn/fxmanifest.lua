fx_version 'cerulean'
game 'gta5'

author 'W-Dev'
description 'Interface de connexion / entrée serveur'
version '1.1.0'

ui_page 'ui/connexion.html'

files {
    'ui/connexion.html',
    'ui/style.css',
    'ui/script.js',
    'ui/img/*'
}

client_script 'client.lua'

dependencies {
    'es_extended',
    'illenium-appearance'
}
