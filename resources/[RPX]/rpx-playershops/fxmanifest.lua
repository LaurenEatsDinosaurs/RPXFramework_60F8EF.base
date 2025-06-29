fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

lua54 'yes'

description 'Wasabi OX Inventory Player Owned Shops - Converted to RedM RPX Framework by Sinatra'
author 'wasabirobby#5110 & Sinatra#0101'
version '1.0.2'

shared_scripts { '@ox_lib/init.lua', 'shared/*.lua' }

client_scripts { 'client/*.lua' }

server_scripts { 'server/*.lua' }

dependencies { 'rpx-inventory' }
