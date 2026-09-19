--[[
    🐺 LXR Core - Map Colour — brand the waypoint route and blips (standalone, RedM)

    Brand:       LXRCore — Lux Empire eXperience RedM Core
    Developer:   iBoss21 / LXRCore
    Website:     https://www.lxrcore.com
    Discord:     https://discord.gg/GAhk8cgXe9
    GitHub:      https://github.com/LXRCore

    Version: 1.0.0

    © 2026 iBoss21 / LXRCore | lxrcore.com | All Rights Reserved
]]

fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
lua54 'yes'

name 'lxr-mapcolor'
author 'iBoss21 / LXRCore'
description 'LXRCore map colour: themed waypoint route + shared blip colour vocabulary (standalone)'
version '3.0.0'
repository 'https://github.com/LXRCore/lxr-mapcolor'

shared_scripts {
    'shared/locale.lua',
    'locales/*.lua',
    'config.lua',
}
client_script 'client/main.lua'
server_script 'server/main.lua'
