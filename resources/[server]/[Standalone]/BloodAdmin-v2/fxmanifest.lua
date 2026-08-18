fx_version 'cerulean'
game 'gta5'

name        'bl_admin'
description 'BloodAdmin — Menu admin NUI pour serveur ESX'
author      'BloodLeak'
version     '1.5.2'

-- Interface NUI
ui_page 'html/index.html'

-- Fichiers HTML
files {
    'html/index.html',
    'html/style.css',
    'html/js/notifications.js',
    'html/js/state_v3.js',
    'html/js/renders_v3.js',
    'html/js/app_v3.js',
}

-- Scripts client
client_scripts {
    'config.lua',
    'client/modules/utils.lua',
    'client/modules/noclip.lua',
    'client/modules/actions.lua',
    'client/modules/events.lua',
    'client/main.lua',
}

-- Scripts serveur
server_scripts {
    'config.lua',
    'server/modules/utils.lua',
    'server/modules/players.lua',
    'server/modules/staff.lua',
    'server/modules/bans.lua',
    'server/modules/resources.lua',
    'server/modules/world.lua',
    'server/modules/permissions.lua',
    'server/modules/reports.lua',
    'server/modules/vehicles.lua',
    'server/main.lua',
}
