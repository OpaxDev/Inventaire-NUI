fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name "mPersonal"
description "FiveM Personal Manager Menu , leak by shadow leaks"
author "Barwoz, LQuatre, leak by shadow leaks"
version "1.0.0"

shared_scripts {
	'shared/*.lua'
}

client_scripts {
	'client/**/*.lua',
}

server_scripts {
	"@mysql-async/lib/MySQL.lua",
	'server/*.lua'
}

ui_page {
	"html/index.html"
}

files {
	'html/assets/img/items/*.png',
	'html/assets/img/bullet.png',
	'html/index.html',
	'html/wallet.html',
	'html/assets/js/script.js',
	'html/assets/css/style.css',
	'html/assets/css/jquery-ui.css',
	'html/assets/css/reset.css',
}

escrow_ignore {
    'shared/main.lua',
} 

