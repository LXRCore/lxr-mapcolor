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

---Blip modifier hash for the current theme — other LXR resources call this for their blips.
local function modifier() return joaat(themeDef().blipModifier) end
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
