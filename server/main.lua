--[[ ═══════════════════════════════════════════════════════════════════════════
     🐺 LXR-MAPCOLOR — Server: banner only (no HTTP, no framework calls)
     © 2026 iBoss21 / LXRCore — All Rights Reserved
     ═══════════════════════════════════════════════════════════════════════════ ]]

CreateThread(function()
    Wait(1000)
    local def = Config.Theme == 'custom' and Config.Custom or (Config.Presets[Config.Theme] or Config.Presets.gold)
    print(('^5🐺 LXR-MAPCOLOR^7 ^3v%s^7 — theme %s (%s / %s)'):format(GetResourceMetadata(GetCurrentResourceName(), 'version', 0) or '?', Config.Theme, def.color, def.blipModifier))
end)
