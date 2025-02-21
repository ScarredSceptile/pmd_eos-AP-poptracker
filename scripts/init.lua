ENABLE_DEBUG_LOG = true

Tracker:AddLocations("locations/dungeons.json")
Tracker:AddLocations("locations/special.json")
Tracker:AddLocations("locations/dojo.json")
Tracker:AddLocations("locations/town.json")
Tracker:AddLocations("locations/shaymin-village.json")
Tracker:AddMaps("maps/maps.json")

Tracker:AddItems("items/dungeons.json")
Tracker:AddItems("items/events.json")
Tracker:AddItems("items/items.json")
Tracker:AddItems("items/settings.json")
Tracker:AddItems("items/legendaries.json")

Tracker:AddLayouts("layouts/items.json")
Tracker:AddLayouts("layouts/settings.json")
Tracker:AddLayouts("layouts/broadcast.json")
Tracker:AddLayouts("layouts/tracker.json")

ScriptHost:LoadScript("scripts/logic.lua")
ScriptHost:LoadScript("scripts/autotracking.lua")