-- Dark Nights data stage: kill the character flashlight so night is truly dark.
-- Lamps, car/vehicle lights and buildings are untouched (gameplay needs light sources).
local chars = data.raw["character"]
if chars then
  for _, c in pairs(chars) do
    c.light = { intensity = 0, size = 0, color = { r = 1, g = 1, b = 1 } }
  end
end
