--[[ FX Information ]] --
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
games { 'gta5', 'rdr3' }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

--[[ Resource Information ]] --
name 'rpx-inventory'
author 'Overextended & Sinatra#0101'
version '1.0.0'
repository 'https://github.com/RPX-RedM/rpx-inventory'
description 'Slot-based inventory with item metadata support converted to RedM RPX Framework by Sinatra#0101'

--[[ Manifest ]] --
dependencies {
	'/server:6116',
	'/onesync',
	'oxmysql',
	'ox_lib',
}

shared_script '@ox_lib/init.lua'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'modules/init.lua'
}

client_script 'modules/init.lua'

ui_page 'web/build/index.html'

files {
	'client.lua',
	'server.lua',
	'locales/*.json',
	'web/build/index.html',
	'web/build/assets/*.js',
	'web/build/assets/*.css',
	'web/images/*.png',
	'modules/**/shared.lua',
	'modules/**/client.lua',
	'modules/bridge/**/client.lua',
	'data/*.lua',
}
