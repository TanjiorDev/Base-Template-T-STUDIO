fx_version 'adamant'

game 'gta5'

ui_page 'web/ui.html'

files {
	'web/*.*',
}

shared_script {
	'@es_extended/imports.lua',
	'config.lua'
}

client_scripts {
	'client.lua',
}

server_scripts {
	'server.lua',
	'commands.lua',
}