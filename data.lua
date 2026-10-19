-- SB Pitch-Black Nights — data stage.
-- Replace the vanilla night color LUT with a pure-black one.
-- Day entries are byte-identical to vanilla (see
-- data/core/prototypes/utility-constants.lua in the game install):
-- only the 0.45-0.55 night window changes, so day rendering is untouched.
-- Lights (lamps, flashlight, fires) are additive and keep working.

local BLACK_LUT = "__sb-pitch-black-nights__/graphics/black-lut.png"

local uc = data.raw["utility-constants"] and data.raw["utility-constants"]["default"]
if uc then
  uc.daytime_color_lookup =
  {
    {0.00, "identity"},
    {0.15, "identity"},
    {0.20, "identity"},
    {0.45, BLACK_LUT},
    {0.55, BLACK_LUT},
    {0.80, "identity"},
    {0.85, "identity"}
  }

  uc.zoom_to_world_daytime_color_lookup =
  {
    {0.25, "identity"},
    {0.45, BLACK_LUT},
    {0.55, BLACK_LUT},
    {0.75, "identity"}
  }
end
