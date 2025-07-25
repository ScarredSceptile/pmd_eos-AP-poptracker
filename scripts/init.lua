ENABLE_DEBUG_LOG = true

Tracker:AddLocations("locations/dungeons-early.json")
Tracker:AddLocations("locations/dungeons-late.json")
Tracker:AddLocations("locations/dungeons-long.json")
Tracker:AddLocations("locations/special.json")
Tracker:AddLocations("locations/dojo.json")
Tracker:AddLocations("locations/town.json")
Tracker:AddLocations("locations/evolution.json")
Tracker:AddLocations("locations/spindas-cafe.json")
Tracker:AddLocations("locations/shaymin-village.json")
Tracker:AddMaps("maps/maps.json")

Tracker:AddItems("items/dungeons.json")
Tracker:AddItems("items/events.json")
Tracker:AddItems("items/gen1.json")
Tracker:AddItems("items/gen2.json")
Tracker:AddItems("items/gen3.json")
Tracker:AddItems("items/gen4.json")
Tracker:AddItems("items/items.json")
Tracker:AddItems("items/settings.json")
Tracker:AddItems("items/legendaries.json")

Tracker:AddLayouts("layouts/items_grid.json")
Tracker:AddLayouts("layouts/settings.json")
Tracker:AddLayouts("layouts/broadcast.json")
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/maps.json")
Tracker:AddLayouts("layouts/dungeons.json")
Tracker:AddLayouts("layouts/dungeons_complete.json")
Tracker:AddLayouts("layouts/items.json")
Tracker:AddLayouts("layouts/gen1-layout.json")
Tracker:AddLayouts("layouts/gen2-layout.json")
Tracker:AddLayouts("layouts/gen3-layout.json")
Tracker:AddLayouts("layouts/gen4-layout.json")

ScriptHost:LoadScript("scripts/logic.lua")
ScriptHost:LoadScript("scripts/utils.lua")
ScriptHost:LoadScript("scripts/autotracking.lua")
ScriptHost:LoadScript("scripts/watch.lua")

initialize_watch_items()
updateMissionCounts()