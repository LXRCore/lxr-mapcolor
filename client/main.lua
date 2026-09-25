--[[ ═══════════════════════════════════════════════════════════════════════════
     🐺 LXR-MAPCOLOR — Client
     ═══════════════════════════════════════════════════════════════════════════
     © 2026 iBoss21 / LXRCore — All Rights Reserved
     ═══════════════════════════════════════════════════════════════════════════ ]]

local KVP = 'lxr-mapcolor:theme'
local theme = Config.Theme
local lastWp, lastPlot = nil, nil
local routeActive = false

local function themeDef()
    if theme == 'custom' then return Config.Custom end
    return Config.Presets[theme] or Config.Presets.gold
end

local function clearRoute()
    if not routeActive then return end
    Citizen.InvokeNative(0x9E0AB9AAEE87CE28) -- CLEAR_GPS_MULTI_ROUTE
    routeActive = false
end

local function plotRoute(wp)
    local def = themeDef()
    clearRoute()
    local pos = GetEntityCoords(PlayerPedId())
    Citizen.InvokeNative(0x3D3D15AF7BCAAF83, joaat(def.color), Config.Route.onFoot, Config.Route.onHorse) -- START_GPS_MULTI_ROUTE
    Citizen.InvokeNative(0x64C59DD6834FA942, pos.x, pos.y, pos.z, true)                                   -- ADD_POINT_TO_GPS_MULTI_ROUTE
    Citizen.InvokeNative(0x64C59DD6834FA942, wp.x, wp.y, wp.z, true)
    Citizen.InvokeNative(0x4426D65E029A4DC0, true)                                                       -- SET_GPS_MULTI_ROUTE_RENDER
    routeActive = true
    lastWp, lastPlot = wp, pos
end

CreateThread(function()
    local saved = GetResourceKvpString(KVP)
    if saved and (saved == 'custom' or Config.Presets[saved]) then theme = saved end
    if Config.Console then print(('^3[lxr-mapcolor]^7 theme "%s" (%s)'):format(theme, themeDef().color)) end
    if not Config.Route.enabled then return end
    while true do
        Wait(Config.Route.pollMs)
        if Citizen.InvokeNative(0x202B1BBFC6AB5EE4) then -- IS_WAYPOINT_ACTIVE
            local wp = Citizen.InvokeNative(0x29B30D07C3F7873B, Citizen.ResultAsVector()) -- _GET_WAYPOINT_COORDS
            local moved = lastPlot and #(GetEntityCoords(PlayerPedId()) - lastPlot) > Config.Route.refreshM
            if not lastWp or #(wp - lastWp) > 1.0 or moved then plotRoute(wp) end
        elseif routeActive then
            clearRoute()
            lastWp = nil
        end
    end
end)

---Blip modifier hash for a kind of place (Config.Kinds) or, without one, the current theme.
---An unknown kind used to fall back to the theme, which tinted EVERY blip on the map
---one colour - the look people recognise as VORP. RSG leaves a blip it has no opinion
---about alone. Config.TintUnknown = false restores that: only the kinds named in
---Config.Kinds are recoloured, everything else keeps the colour the game gave it.
local function modifier(kind)
    if Config.KindBlips == false then return 0 end   -- shop / job blips keep the game's own colour
    local preset = kind and Config.Kinds and Config.Kinds[kind] and Config.Presets[Config.Kinds[kind]]
    if not preset and Config.TintUnknown == false then return 0 end   -- 0 = add no modifier, keep the game's colour
    return joaat((preset or themeDef()).blipModifier)
end
local function colorHash() return joaat(themeDef().color) end
local function rgb() return themeDef().rgb end

local function setTheme(name)
    if name ~= 'custom' and not Config.Presets[name] then return false end
    theme = name
    SetResourceKvp(KVP, name)
    lastWp = nil
    clearRoute()
    TriggerEvent('lxr-mapcolor:client:themeChanged', name, themeDef())
    return true
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🏘️  ONE COLOUR PER TOWN
-- ═══════════════════════════════════════════════════════════════════════════════
-- Valentine green, Annesburg yellow, Blackwater white. Other resources ask for a
-- town's modifier the same way they ask for a kind's; this file also drops a blip
-- per town so the colour is visible without anything else installed.

local townBlips = {}

---The blip modifier for a town. Unknown town → the theme, same rule as modifier().
local function townModifier(name)
    local t = (Config.Towns or {})[tostring(name or ''):lower()]
    local preset = t and Config.Presets[t.color]
    return joaat((preset or themeDef()).blipModifier)
end

local function clearTownBlips()
    for _, b in pairs(townBlips) do if DoesBlipExist(b) then RemoveBlip(b) end end
    townBlips = {}
end

local function drawTownBlips()
    clearTownBlips()
    local TB = Config.TownBlips or {}
    if not TB.enabled then return end
    for name, t in pairs(Config.Towns or {}) do
        if t.coords then
            local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, t.coords.x, t.coords.y, t.coords.z)
            SetBlipSprite(blip, TB.sprite or 1755311170, true)
            SetBlipScale(blip, TB.scale or 0.2)
            Citizen.InvokeNative(0x662D364ABF16DE2F, blip, townModifier(name))   -- BLIP_ADD_MODIFIER
            if TB.showName ~= false then
                Citizen.InvokeNative(0x9CB1A1623062F402, blip, Lang:t('town.' .. name, {}) ~= ('town.' .. name)
                    and Lang:t('town.' .. name) or (name:sub(1,1):upper() .. name:sub(2)))
            end
            townBlips[name] = blip
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🗺️  TERRITORY TINT — the states painted on the paper map
-- ═══════════════════════════════════════════════════════════════════════════════
-- New Hanover olive, Lemoyne blue, Roanoke red. The game paints a named region for us:
-- nothing is drawn per frame and no texture is replaced, so this costs exactly one pass
-- at boot and nothing afterwards.

local painted = {}

local function territoryColour(t)
    local preset = t.color and Config.Presets[t.color]
    return joaat((preset or themeDef()).blipModifier)
end

local function clearTerritories()
    for _, zone in ipairs(painted) do
        Citizen.InvokeNative(0x6786D7AFAC3162B3, zone)   -- clear the region tint
    end
    painted = {}
end

local function paintTerritories()
    clearTerritories()
    if not (Config.Territory and Config.Territory.enabled) then return end
    for _, t in ipairs(Config.Territories or {}) do
        if t.zone then
            Citizen.InvokeNative(0x563FCB6620523917, t.zone, territoryColour(t))
            painted[#painted + 1] = t.zone
        end
    end
    if Config.Console then
        print(('^3[lxr-mapcolor]^7 %d territories painted'):format(#painted))
    end
end

exports('territories', paintTerritories)
exports('clearTerritories', clearTerritories)

-- Repaint when the player switches theme: an unknown territory colour falls back to it.
AddEventHandler('lxr-mapcolor:client:themeChanged', function() paintTerritories() end)

exports('town', townModifier)
exports('townBlips', drawTownBlips)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then clearTownBlips() clearTerritories() end
end)

CreateThread(function()
    Wait(2000)          -- let the map settle after the session starts
    paintTerritories()
    drawTownBlips()
end)

exports('modifier', modifier)
exports('colorHash', colorHash)
exports('rgb', rgb)
exports('theme', function() return theme, themeDef() end)
exports('setTheme', setTheme)
exports('apply', function() lastWp = nil end)

if Config.Command and Config.Command ~= '' then
    RegisterCommand(Config.Command, function(_, args)
        local name = args[1]
        if not name then
            local list = {}
            for k in pairs(Config.Presets) do list[#list + 1] = k end
            table.sort(list)
            return TriggerEvent('chat:addMessage', { args = { 'lxr-mapcolor', Lang:t('chat.current', { theme = theme, list = table.concat(list, ', ') }) } })
        end
        if not setTheme(name) then TriggerEvent('chat:addMessage', { args = { 'lxr-mapcolor', Lang:t('chat.unknown', { name = name }) } }) end
    end, false)
    TriggerEvent('chat:addSuggestion', '/' .. Config.Command, Lang:t('command.help', { cmd = Config.Command }))
end

AddEventHandler('onResourceStop', function(res) if res == GetCurrentResourceName() then clearRoute() end end)
