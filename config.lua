--[[
    ██╗     ██╗  ██╗██████╗       ███╗   ███╗ █████╗ ██████╗
    ██║     ╚██╗██╔╝██╔══██╗      ████╗ ████║██╔══██╗██╔══██╗
    ██║      ╚███╔╝ ██████╔╝█████╗██╔████╔██║███████║██████╔╝
    ██║      ██╔██╗ ██╔══██╗╚════╝██║╚██╔╝██║██╔══██║██╔═══╝
    ███████╗██╔╝ ██╗██║  ██║      ██║ ╚═╝ ██║██║  ██║██║
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝

    🐺 LXR Core - Map Colour

    Brand the map: the route drawn to the player's waypoint, the player's own
    blip, and a shared colour vocabulary every LXR resource can use for its
    blips (`exports['lxr-mapcolor']:modifier()`), so the whole server wears one
    colour instead of Rockstar's yellow.

    RDR3 has no ReplaceHudColourWithRgba; colours are the game's named colours
    (COLOR_GOLD, COLOR_BLUELIGHT, …) and blips take BLIP_MODIFIER_MP_COLOR_n.
    The waypoint route is redrawn as a GPS multi-route in the theme colour.

    Brand:       LXRCore — Lux Empire eXperience RedM Core
    Developer:   iBoss21 / LXRCore
    Website:     https://www.lxrcore.com
    Discord:     https://discord.gg/ZHMKVYyhBa (development)
    GitHub:      https://github.com/LXRCore

    Version: 1.0.0
    Performance Target: 0.00 ms idle (one 500 ms waypoint poll)

    © 2026 iBoss21 / LXRCore | lxrcore.com | All Rights Reserved
]]

Config = Config or {}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ THEME █████████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
Config.Theme = 'gold'   -- one of Config.Presets, or 'custom' → Config.Custom

Config.Custom = { color = 'COLOR_GOLD', blipModifier = 'BLIP_MODIFIER_MP_COLOR_10', rgb = { 196, 165, 116 } }

-- Named game colours and the matching player-colour blip modifier. `rgb` is only used for chat / NUI.
Config.Presets = {
    gold      = { color = 'COLOR_GOLD',         blipModifier = 'BLIP_MODIFIER_MP_COLOR_10', rgb = { 196, 165, 116 } },
    red       = { color = 'COLOR_RED',          blipModifier = 'BLIP_MODIFIER_MP_COLOR_1',  rgb = { 168, 58, 58 } },
    redlight  = { color = 'COLOR_REDLIGHT',     blipModifier = 'BLIP_MODIFIER_MP_COLOR_6',  rgb = { 220, 90, 90 } },
    orange    = { color = 'COLOR_ORANGE',       blipModifier = 'BLIP_MODIFIER_MP_COLOR_9',  rgb = { 240, 140, 40 } },
    yellow    = { color = 'COLOR_YELLOW',       blipModifier = 'BLIP_MODIFIER_MP_COLOR_11', rgb = { 240, 220, 60 } },
    green     = { color = 'COLOR_GREEN',        blipModifier = 'BLIP_MODIFIER_MP_COLOR_3',  rgb = { 80, 180, 80 } },
    greenlight = { color = 'COLOR_GREENLIGHT',  blipModifier = 'BLIP_MODIFIER_MP_COLOR_14', rgb = { 140, 210, 120 } },
    blue      = { color = 'COLOR_BLUE',         blipModifier = 'BLIP_MODIFIER_MP_COLOR_2',  rgb = { 60, 110, 200 } },
    bluelight = { color = 'COLOR_BLUELIGHT',    blipModifier = 'BLIP_MODIFIER_MP_COLOR_8',  rgb = { 110, 160, 220 } },
    purple    = { color = 'COLOR_PURPLE',       blipModifier = 'BLIP_MODIFIER_MP_COLOR_5',  rgb = { 140, 90, 190 } },
    pink      = { color = 'COLOR_PINK',         blipModifier = 'BLIP_MODIFIER_MP_COLOR_7',  rgb = { 220, 110, 170 } },
    silver    = { color = 'COLOR_SILVER',       blipModifier = 'BLIP_MODIFIER_MP_COLOR_16', rgb = { 190, 190, 190 } },
    copper    = { color = 'COLOR_COPPER',       blipModifier = 'BLIP_MODIFIER_MP_COLOR_13', rgb = { 184, 115, 51 } },
    white     = { color = 'COLOR_PURE_WHITE',   blipModifier = 'BLIP_MODIFIER_MP_COLOR_12', rgb = { 255, 255, 255 } },
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ WHAT GETS COLOURED ████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
Config.Route = {
    enabled    = true,   -- draw a GPS route to the waypoint in the theme colour
    pollMs     = 500,    -- how often the waypoint is checked
    onFoot     = true,
    onHorse    = true,
    refreshM   = 15.0,   -- re-plot the route when the player moved this far (keeps it on roads)
}

Config.PlayerBlip = {
    enabled  = false,    -- apply the theme modifier to the local player's own blip (only visible when a player blip exists)
}

Config.Console = true    -- print the applied theme in F8

-- Chat command to switch the theme for yourself (empty = disabled). Saved per player in KVP.
Config.Command = 'mapcolor'
