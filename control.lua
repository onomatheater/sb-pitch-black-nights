-- SB Pitch-Black Nights — clean-room implementation, MIT.
-- Goal: pitch-black nights where there is no light, flashlight/lamps still work.
-- Method: min_brightness = 0 always; at deep night also scale
-- brightness_visual_weights to 0 (multiplier on the night render).
-- Day visuals of other mods (e.g. Cerys frozen day) are never touched:
-- we only override while darkness is high and restore the previous
-- weights when it gets light again.

local NIGHT_DARKNESS = 0.85 -- full override at/above this darkness
local DAY_DARKNESS = 0.75 -- restore below this darkness (hysteresis)

local function weights_to_string(w)
  if type(w) == "table" then
    return (w[1] or w.r or "?") .. "," .. (w[2] or w.g or "?") .. "," .. (w[3] or w.b or "?")
  end
  return tostring(w)
end

local function get_weights(surface)
  local ok, w = pcall(function() return surface.brightness_visual_weights end)
  if ok and type(w) == "table" then
    return { w[1] or w.r or 1, w[2] or w.g or 1, w[3] or w.b or 1 }
  end
  return { 1, 1, 1 }
end

local function dbg(msg)
  log("[SB-PBN] " .. msg)
end

local function apply(surface)
  if not surface or not surface.valid then return end
  if surface.min_brightness ~= 0 then
    surface.min_brightness = 0
  end

  local darkness = 0
  pcall(function() darkness = surface.darkness or 0 end)

  storage.sbpb = storage.sbpb or {}
  local saved = storage.sbpb[surface.index]
  local cur_w = get_weights(surface)

  if darkness >= NIGHT_DARKNESS then
    if not saved then
      storage.sbpb[surface.index] = { weights = cur_w }
      dbg(surface.name .. " night darkness=" .. string.format("%.2f", darkness)
        .. " saved_weights={" .. weights_to_string(cur_w) .. "} -> set {0,0,0}")
    end
    surface.brightness_visual_weights = { 0, 0, 0 }
    -- read back: verify what the engine actually holds now
    local back = get_weights(surface)
    if back[1] ~= 0 or back[2] ~= 0 or back[3] ~= 0 then
      local st = storage.sbpb[surface.index]
      if st and not st.readback_logged then
        dbg(surface.name .. " READBACK weights={" .. weights_to_string(back) .. "} (expected 0,0,0!)")
        st.readback_logged = true
      end
    end
  elseif darkness <= DAY_DARKNESS then
    if saved then
      pcall(function()
        surface.brightness_visual_weights = saved.weights
      end)
      dbg(surface.name .. " day darkness=" .. string.format("%.2f", darkness)
        .. " restored weights={" .. weights_to_string(saved.weights) .. "}")
      storage.sbpb[surface.index] = nil
    end
  end
  -- between thresholds: leave as-is (no flicker)
end

local function apply_all()
  for _, s in pairs(game.surfaces) do
    apply(s)
  end
end

script.on_init(function()
  storage.sbpb = storage.sbpb or {}
  dbg("on_init, surfaces=" .. #game.surfaces)
  apply_all()
end)

script.on_configuration_changed(function()
  storage.sbpb = storage.sbpb or {}
  dbg("on_configuration_changed")
  apply_all()
end)

script.on_event(defines.events.on_surface_created, function(e)
  local s = game.surfaces[e.surface_index]
  apply(s)
end)

script.on_event(defines.events.on_tick, function(e)
  -- every second: cheap (a few surfaces), catches day/night transitions
  if e.tick % 60 == 0 then
    apply_all()
  end
end)
