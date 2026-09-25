# Changelog

## 3.1.1 — 2026-09-25

### Changed
- **The territory colours are now the community's own values for these zones**, used
  exactly: Ambarino `MP_COLOR_1`, New Hanover `8`, Lemoyne `3`, West Elizabeth `6`,
  New Austin `4`, Roanoke Ridge `19`, Wapiti `2`. Three of those (`4`, `19`, `22`) have no
  entry in `Config.Presets`, so a territory row can now carry `modifier = 'BLIP_MODIFIER_…'`
  directly instead of naming a preset — rounding them to the nearest colour we happened to
  have would have quietly changed the map. `color = '<preset>'` still works for any row that
  should follow the theme.

## 3.1.0 — 2026-09-25

### Added
- **Territory tint, on by default.** The states are painted on the paper map — New Hanover
  olive, Lemoyne blue, Roanoke red, New Austin copper. `Config.Territory.enabled` and
  `Config.Territories` (a zone hash and a `Config.Presets` colour). Two natives do the work,
  `0x563FCB6620523917` to paint and `0x6786D7AFAC3162B3` to clear, so nothing is drawn per
  frame and no texture is replaced. Exports `territories` and `clearTerritories`; repaints
  when the player changes theme, clears on stop.

### Changed
- **`Config.KindBlips`, default `true`.** The per-kind blip colours — store green, gunsmith
  red, doctor white, tailor purple — are now a switch of their own rather than something
  welded on. They sit alongside the territory tint: the land carries the state's colour,
  the pin carries the trade's. `false` makes `modifier()` return 0 so every blip keeps the
  colour the game gave it, and none of the 17 callers need to change. The tint, the kind
  colours and the town colours all switch independently.

## 3.0.0 — 2026-09-19
* LXRCore v3 release line: every resource ships as 3.0.0 from here (the entries below are the road to it).

## 1.1.0 — 2026-09-19
* One colour per kind of place: `modifier('doctor' | 'shop' | 'bank' | …)` reads `Config.Kinds`; every official blip names its kind, so the map reads at a glance instead of one colour for everything. — lxr-mapcolor

## [1.0.0] — 2026-09-17
- First RedM/LXRCore release: themed waypoint route, blip-colour vocabulary exports, per-player `/mapcolor`, 14 presets.
