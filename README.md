# SB Pitch-Black Nights

Pitch-black nights on all surfaces (Nauvis, planets, platforms). Flashlight and lamps still work. Clean-room implementation, MIT. No solar changes, visuals only.

## How it works

- Data stage (`data.lua`): the vanilla night color LUT (`lut-night.png`, 0.45–0.55 window) is swapped for a pure-black one. Day entries are byte-identical to vanilla.
- Runtime (`control.lua`): `min_brightness = 0` always; at deep night `brightness_visual_weights` are forced to 0 and restored by day (other mods' day visuals untouched).

## Portal upload

1. Take `sb-pitch-black-nights_<version>.zip` from the release (zip contains the `sb-pitch-black-nights/` folder, not loose files)
2. Upload at https://mods.factorio.com/mod/sb-pitch-black-nights (or new mod page)
3. Factorio version 2.0, category Tweaks, tag Environment
