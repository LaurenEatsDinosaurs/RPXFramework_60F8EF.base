game 'rdr3'
fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description 'RPX GoldPan System'
author 'Sinatra#0101'
version '0.0.1'

client_scripts {
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
} 


shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
}

lua54 'yes'