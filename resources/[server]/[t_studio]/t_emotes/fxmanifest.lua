fx_version 'cerulean'
game 'gta5'

author 'KZB'
description 'Menu Animations KZB Custom avec Preview et Laser'
version '2.0.0'

shared_scripts {
    'config.lua',              -- Ta configuration de base
    'AnimationList.lua',       -- Ta liste de 21 000 emotes
    'AnimationListCustom.lua'  -- (Garde cette ligne uniquement si tu as créé ce fichier pour tes autres emotes)
}

client_script 'client/main.lua'
-- server_script 'server/main.lua' -- Enlève les tirets si tu as un fichier côté serveur (pour synchroniser des choses plus tard)

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/eye.png' -- Ton image d'œil obligatoire pour le menu !
}