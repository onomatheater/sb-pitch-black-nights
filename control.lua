-- Spaced Breakout Dark Nights — clean-room implementation, MIT.
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

local function apply_player(p)
  if not p or not p.valid then return end
  -- turn off personal flashlight if the API exposes it (guarded: version-safe)
  local ch = p.character
  if ch and ch.valid and ch.enable_flashlight ~= nil then
    pcall(function() ch.enable_flashlight = false end)
  end
end

local function apply_players()
  for _, p in pairs(game.players) do apply_player(p) end
end

script.on_event(defines.events.on_tick, function(e)
  -- re-assert every 10s in case another mod/planet script resets brightness
  if e.tick % 600 == 0 then
    apply_all()
  end
  -- keep flashlights off (cheap: every second)
  if e.tick % 60 == 0 then
    apply_players()
  end
end)

script.on_event(defines.events.on_player_created, function(e)
  apply_player(game.get_player(e.player_index))
end)
script.on_event(defines.events.on_player_joined_game, function(e)
  apply_player(game.get_player(e.player_index))
end)
