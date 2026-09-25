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
    Discord:     https://discord.gg/GAhk8cgXe9
    GitHub:      https://github.com/LXRCore

    Version: 1.0.0
    Performance Target: 0.00 ms idle (one 500 ms waypoint poll)

    © 2026 iBoss21 / LXRCore | lxrcore.com | All Rights Reserved
]]

Config = Config or {}

-- Language for chat and command text: any bundle registered in locales/ ('en', 'ka').
Config.Lang = 'en'

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ THEME █████████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
Config.Theme = 'gold'   -- one of Config.Presets, or 'custom' → Config.Custom

Config.Custom = { color = 'COLOR_RED', blipModifier = 'BLIP_MODIFIER_MP_COLOR_1', rgb = { 194, 28, 55 } }

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

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ ONE COLOUR PER KIND OF PLACE ██████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
-- `exports['lxr-mapcolor']:modifier('doctor')` → that kind's preset; an unknown or missing kind → the theme.
-- Keys are what the official resources pass; add your own for third-party blips.
-- Recolour the shop / job blips by kind at all?
--   false - a general store, gunsmith, doctor, tailor... keeps the icon colour the game
--           gave it. The map reads the way Rockstar drew it and the only colour this
--           resource adds is the territory tint and the per-town colour below.
--   true  - each kind is tinted with its Config.Kinds colour.
Config.KindBlips = false

Config.Kinds = {
    shop     = 'green',      -- general stores
    gunsmith = 'red',
    doctor   = 'white',
    bank     = 'yellow',
    post     = 'bluelight',
    stable   = 'copper',
    law      = 'blue',
    saloon   = 'orange',
    tailor   = 'purple',
    barber   = 'pink',
    market   = 'greenlight',
    craft    = 'silver',
    storage  = 'copper',
    train    = 'silver',
    camp     = 'greenlight',
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ TERRITORY TINT ████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
-- The states painted on the paper map - New Hanover olive, Lemoyne blue, Roanoke red.
-- This is the thing people mean by "a coloured map"; it is NOT blips, and no texture
-- has to be replaced for it. The game paints a named region when you hand it a zone
-- hash and a colour:
--
--     0x563FCB6620523917(zoneHash, GetHashKey(colour))   -- paint
--     0x6786D7AFAC3162B3(zoneHash)                       -- clear
--
-- The zone hashes are the game's own, published in femga/rdr3_discoveries under
-- graphics/minimap/wanted_regions. `color` is a key of Config.Presets above, so the
-- territories speak the same colour vocabulary as everything else here.
--
-- Shipped ON by default: a plain parchment map is the thing every server complains about.

Config.Territory = {
    enabled = true,
}

-- Only the states by default. The district and outline hashes exist too (Grizzlies,
-- Scarlett Meadows, Cholla Springs, every town outline) - add them here when you want
-- a finer map; the reference table above has them all.
Config.Territories = {
    { zone = 0x3B8DD21A, id = 'ambarino',        color = 'white' },      -- STATE_AMBARINO
    { zone = 0x41332496, id = 'new_hanover',     color = 'yellow' },     -- STATE_NEW_HANOVER
    { zone = 0x945395DF, id = 'lemoyne',         color = 'blue' },       -- STATE_LEMOYNE
    { zone = 0xD69B5B49, id = 'west_elizabeth',  color = 'greenlight' }, -- STATE_WEST_ELIZABETH
    { zone = 0x41759831, id = 'new_austin',      color = 'copper' },     -- STATE_NEW_AUSTIN
    { zone = 0x30FAE29B, id = 'roanoke_ridge',   color = 'red' },        -- DISTRICT_ROANOKE_RIDGE
    { zone = 0xBB785C8A, id = 'wapiti',          color = 'greenlight' }, -- REGION_GRZ_WAPITI
    -- { zone = 0x9307FD41, id = 'guarma',       color = 'orange' },     -- STATE_GUARMA
    -- { zone = 0x33F2D34F, id = 'nuevo_paraiso', color = 'orange' },    -- STATE_NUEVO_PARAISO
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ ONE COLOUR PER TOWN ███████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
-- Valentine green, Annesburg yellow, Blackwater white - a glance at the map tells you
-- which part of the country you are looking at. `exports['lxr-mapcolor']:town('valentine')`
-- returns that town's modifier; other resources can tint their own blips by town.
--
-- With Config.TownBlips.enabled the resource also drops one blip per town in its colour.
-- The coordinates below are the town centres to within a few metres. If one sits wrong for
-- you, stand where you want it and run:  /mapcolor here <town>   - it rewrites the entry.

Config.Towns = {
    valentine    = { color = 'green',      coords = vector3(-273.0,   781.0,   119.0) },
    annesburg    = { color = 'yellow',     coords = vector3(2930.0,  1310.0,    44.0) },
    blackwater   = { color = 'white',      coords = vector3(-871.0, -1350.0,    43.0) },
    saintdenis   = { color = 'purple',     coords = vector3(2640.0, -1300.0,    46.0) },
    rhodes       = { color = 'red',        coords = vector3(1348.0, -1300.0,    77.0) },
    strawberry   = { color = 'greenlight', coords = vector3(-1794.0, -391.0,   155.0) },
    armadillo    = { color = 'copper',     coords = vector3(-3725.0,-2600.0,   -13.0) },
    tumbleweed   = { color = 'orange',     coords = vector3(-5512.0,-2950.0,    -2.0) },
    vanhorn      = { color = 'bluelight',  coords = vector3(2970.0,   520.0,    44.0) },
    emeraldranch = { color = 'silver',     coords = vector3(1417.0,   352.0,    89.0) },
    wallace      = { color = 'pink',       coords = vector3(-1400.0,  490.0,   105.0) },
    colter       = { color = 'blue',       coords = vector3(1540.0,  2290.0,   304.0) },
}

Config.TownBlips = {
    enabled  = true,    -- draw one blip per town in its own colour
    sprite   = 1755311170,   -- BLIP_STYLE_TOWN
    showName = true,    -- label it with the town's name from the locale
    scale    = 0.2,
}

-- Only recolour the kinds named above. false = a blip this resource has no opinion
-- about keeps the colour the game gave it, which is how RSG behaves. true = the old
-- behaviour, where every unknown blip fell back to Config.Theme and the whole map
-- came out one colour - the look people recognise as VORP.
Config.TintUnknown = false

Config.Console = true    -- print the applied theme in F8

-- Chat command to switch the theme for yourself (empty = disabled). Saved per player in KVP.
Config.Command = 'mapcolor'
