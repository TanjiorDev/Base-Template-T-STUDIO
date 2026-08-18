fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'Fusion t_hud + t_hud-heure + t_speedo'
description 'HUD complet : faim/soif, heure/date/ID et compteur de vitesse'
version '1.0.0'

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/router.js',
    'ui/hud/**/*',
    'ui/hudheure/**/*',
    'ui/speedo/**/*'
}

client_scripts {
    'client/status.lua',
    'client/clock.lua',
    'client/speedometer.lua'
}

dependency 'esx_status'
