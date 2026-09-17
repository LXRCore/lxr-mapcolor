--[[ ═══════════════════════════════════════════════════════════════════════════
     LXR-MAPCOLOR — Locale: English (canonical)
     Developer   : iBoss21 | Brand : LXRCore | https://www.lxrcore.com
     © 2026 iBoss21 / LXRCore — All Rights Reserved
     ═══════════════════════════════════════════════════════════════════════════ ]]

Locale.Register('en', {
    command = { help = 'Map colour theme: /%{cmd} [preset]' },
    chat = {
        current = 'current: %{theme} · presets: %{list}',
        unknown = 'unknown preset %{name}',
        applied = 'map theme: %{theme}',
    },
})
