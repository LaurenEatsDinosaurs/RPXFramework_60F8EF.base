fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description 'RPX Shops - A shops script to be packaged with the RPX Framework.'
author 'Sinatra#0101'
version '0.0.1'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
}

server_scripts {
    'server/main.lua',
}

client_scripts {
    'client/main.lua',
}

ui_page {
    'ui/index.html'
}

files {
    'ui/index.html',
    'ui/script.js',
    'ui/style.css',
    'ui/*',
    'ui/fonts/*',
    'ui/img/*',
    -- Todo: Add more files here
}

lua54 'yes'