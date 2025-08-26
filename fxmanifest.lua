fx_version 'cerulean'
lua54 'yes'
game 'gta5'

name "am-advancedStorages"
description "Storage system for fivem "
author "Amitae"
version "1.0"

shared_scripts {
	'shared/main.lua',
	'shared/locales.lua',
	'@ox_lib/init.lua'
}

client_scripts {
	'client/*.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/discordLog.lua',
	'server/functions.lua',
	'server/main.lua'
}


