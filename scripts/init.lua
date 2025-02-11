ENABLE_DEBUG_LOG = true

Tracker:AddLocations("locations/dungeons.json")
Tracker:AddMaps("maps/maps.json")

Tracker:AddItems("items/items.json")
Tracker:AddItems("items/settings.json")

Tracker:AddLayouts("layouts/items.json")
Tracker:AddLayouts("layouts/settings.json")
Tracker:AddLayouts("layouts/broadcast.json")
Tracker:AddLayouts("layouts/tracker.json")

ScriptHost:LoadScript("scripts/logic.lua")
--if PopVersion and PopVersion >= "0.18.0" then
--    ScriptHost:LoadScript("scripts/archipelago.lua")
--end
