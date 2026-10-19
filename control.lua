-- SB Pitch-Black Nights — clean-room implementation, MIT.
-- Makes nights completely dark by forcing min_brightness to 0 on every surface.
-- Visual only: does not touch solar_power_multiplier or day length.

local TARGET_BRIGHTNESS = 0

local function apply(surface)
  if surface and surface.valid then
    surface.min_brightness = TARGET_BRIGHTNESS
  end
end

local function apply_all()
  for _, s in pairs(game.surfaces) do
    apply(s)
  end
end

script.on_init(apply_all)
script.on_configuration_changed(apply_all)

script.on_event(defines.events.on_surface_created, function(e)
  local s = game.surfaces[e.surface_index]
  apply(s)
end)

script.on_event(defines.events.on_tick, function(e)
  -- re-assert every 10s in case another mod/planet script resets brightness
  if e.tick % 600 == 0 then
    apply_all()
  end
end)
