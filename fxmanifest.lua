fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_scripts {
    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/elements/*.lua",
    "RageUI/menu/items/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/windows/*.lua",
    'Client/*.lua'
}

server_scripts {
    'Server/*.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'Shared/*.lua'
}