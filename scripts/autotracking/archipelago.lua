-- this is an example/default implementation for AP autotracking
-- it will use the mappings defined in item_mapping.lua and location_mapping.lua to track items and locations via their ids
-- it will also keep track of the current index of on_item messages in CUR_INDEX
-- addition it will keep track of what items are local items and which one are remote using the globals LOCAL_ITEMS and GLOBAL_ITEMS
-- this is useful since remote items will not reset but local items might
-- if you run into issues when touching A LOT of items/locations here, see the comment about Tracker.AllowDeferredLogicUpdate in autotracking.lua
ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/dungeons.lua")

CUR_INDEX = -1
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}

-- resets an item to its initial state
function resetItem(item_code, item_type)
	local obj = Tracker:FindObjectForCode(item_code)
	if obj then
		item_type = item_type or obj.Type
		if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("resetItem: resetting item %s of type %s", item_code, item_type))
		end
		if item_type == "toggle" or item_type == "toggle_badged" then
			obj.Active = false
		elseif item_type == "progressive" or item_type == "progressive_toggle" then
			obj.CurrentStage = 0
			obj.Active = false
		elseif item_type == "consumable" then
			obj.AcquiredCount = 0
		elseif item_type == "custom" then
			-- your code for your custom lua items goes here
		elseif item_type == "static" and AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("resetItem: tried to reset static item %s", item_code))
		elseif item_type == "composite_toggle" and AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format(
				"resetItem: tried to reset composite_toggle item %s but composite_toggle cannot be accessed via lua." ..
				"Please use the respective left/right toggle item codes instead.", item_code))
		elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("resetItem: unknown item type %s for code %s", item_type, item_code))
		end
	elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("resetItem: could not find item object for code %s", item_code))
	end
end

-- advances the state of an item
function incrementItem(item_code, item_type, multiplier)
	local obj = Tracker:FindObjectForCode(item_code)
	if obj then
		item_type = item_type or obj.Type
		if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("incrementItem: code: %s, type %s", item_code, item_type))
		end
		if item_type == "toggle" or item_type == "toggle_badged" then
			obj.Active = true
		elseif item_type == "progressive" or item_type == "progressive_toggle" then
			if obj.Active then
				obj.CurrentStage = obj.CurrentStage + 1
			else
				obj.Active = true
			end
		elseif item_type == "consumable" then
			obj.AcquiredCount = obj.AcquiredCount + obj.Increment * multiplier
		elseif item_type == "custom" then
			-- your code for your custom lua items goes here
		elseif item_type == "static" and AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("incrementItem: tried to increment static item %s", item_code))
		elseif item_type == "composite_toggle" and AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format(
				"incrementItem: tried to increment composite_toggle item %s but composite_toggle cannot be access via lua." ..
				"Please use the respective left/right toggle item codes instead.", item_code))
		elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("incrementItem: unknown item type %s for code %s", item_type, item_code))
		end
	elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("incrementItem: could not find object for code %s", item_code))
	end
end

function updateMissionCounts()
	local earlyMissionCount = Tracker:ProviderCountForCode("EarlyMissionChecks")
	local earlyStoredMissionCount = Tracker:ProviderCountForCode("EarlyStoredMissionChecks")
	local lateMissionCount = Tracker:ProviderCountForCode("LateMissionChecks")
	local lateStoredMissionCount = Tracker:ProviderCountForCode("LateStoredMissionChecks")
	local earlyOutlawCount = Tracker:ProviderCountForCode("EarlyOutlawChecks")
	local earlyStoredOutlawCount = Tracker:ProviderCountForCode("EarlyStoredOutlawChecks")
	local lateOutlawCount = Tracker:ProviderCountForCode("LateOutlawChecks")
	local lateStoredOutlawCount = Tracker:ProviderCountForCode("LateStoredOutlawChecks")
	
	local earlyMissionDiff = earlyStoredMissionCount - earlyMissionCount
	local lateMissionDiff = lateStoredMissionCount - lateMissionCount
	local earlyOutlawDiff = earlyStoredOutlawCount - earlyOutlawCount
	local lateOutlawDiff = lateStoredOutlawCount - lateOutlawCount
	
	if earlyMissionDiff ~= 0 then
		Tracker:FindObjectForCode("EarlyStoredMissionChecks").AcquiredCount = earlyMissionCount
		updateEarlyCount("Mission", -earlyMissionDiff, true)
	end
	if lateMissionDiff ~= 0 then
		Tracker:FindObjectForCode("LateStoredMissionChecks").AcquiredCount = lateMissionCount
		updateLateCount("Mission", -lateMissionDiff, true)
	end
	if earlyOutlawDiff ~= 0 then
		Tracker:FindObjectForCode("EarlyStoredOutlawChecks").AcquiredCount = earlyOutlawCount
		updateEarlyCount("Outlaw", -earlyOutlawDiff, true)
	end
	if lateOutlawDiff ~= 0 then
		Tracker:FindObjectForCode("LateStoredOutlawChecks").AcquiredCount = lateOutlawCount
		updateLateCount("Outlaw", -lateOutlawDiff, true)
	end
	
	return true
end

function updateEarlyCount(type, count)
	print("Called from updateEarlyCount"..type..count)
	for i,dungeon in ipairs(EARLY_DUNGEONS) do
		local obj = Tracker:FindObjectForCode("@Dungeons/"..dungeon.."/"..type)
		obj.AvailableChestCount = obj.AvailableChestCount + count
	end
end

function updateLateCount(type, count)
	print("Called from updateLateCount"..type..count)
	for i,dungeon in ipairs(LATE_DUNGEONS) do
		local obj = Tracker:FindObjectForCode("@Dungeons/"..dungeon.."/"..type)
		obj.AvailableChestCount = obj.AvailableChestCount + count
	end
	for i,place in ipairs(SKY_PEAK_DUNGEONS) do
		local obj = Tracker:FindObjectForCode("@Dungeons/Sky Peak/"..place..type)
		obj.AvailableChestCount = obj.AvailableChestCount + count
	end
end

function updateEarly(type, count)
	print("Called from updateEarly"..type..count)
	if type == "Mission" then
		Tracker:FindObjectForCode("EarlyStoredMissionChecks").AcquiredCount = count
	elseif type == "Outlaw" then
		Tracker:FindObjectForCode("EarlyStoredOutlawChecks").AcquiredCount = count
	end
	for i,dungeon in ipairs(EARLY_DUNGEONS) do
		Tracker:FindObjectForCode("@Dungeons/"..dungeon.."/"..type).AvailableChestCount = count
	end
end

function updateLate(type, count)
	print("Called from updateLate"..type..count)
	if type == "Mission" then
		Tracker:FindObjectForCode("LateStoredMissionChecks").AcquiredCount = count
	elseif type == "Outlaw" then
		Tracker:FindObjectForCode("LateStoredOutlawChecks").AcquiredCount = count
	end
	for i,dungeon in ipairs(LATE_DUNGEONS) do
		Tracker:FindObjectForCode("@Dungeons/"..dungeon.."/"..type).AvailableChestCount = count
	end
	for i,place in ipairs(SKY_PEAK_DUNGEONS) do
		Tracker:FindObjectForCode("@Dungeons/Sky Peak/"..place..type).AvailableChestCount = count
	end
end

function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    elseif type(v) == 'boolean' then
      print(formatting .. tostring(v))      
    else
      print(formatting .. v)
    end
  end
end


-- apply everything needed from slot_data, called from onClear
function apply_slot_data(slot_data)
	local count = 0
	print("Before dumping the slot data")
	tprint(slot_data, 2)
	if slot_data["EarlyOutlawsAmount"] then
		count = tonumber(slot_data["EarlyOutlawsAmount"])
		Tracker:FindObjectForCode("EarlyOutlawChecks").AcquiredCount = count
		updateEarly("Outlaw", count)
	else
		Tracker:FindObjectForCode("EarlyOutlawChecks").AcquiredCount = 0
		updateEarly("Outlaw", 0)
	end
	if slot_data["LateOutlawsAmount"] then
		count = tonumber(slot_data["LateOutlawsAmount"])
		Tracker:FindObjectForCode("LateOutlawChecks").AcquiredCount = count
		updateLate("Outlaw", count)
	else
		Tracker:FindObjectForCode("LateOutlawChecks").AcquiredCount = 0
		updateLate("Outlaw", 0)
	end
	if slot_data["EarlyMissionsAmount"] then
		count = tonumber(slot_data["EarlyMissionsAmount"])
		Tracker:FindObjectForCode("EarlyMissionChecks").AcquiredCount = count
		updateEarly("Mission", count)
	else
		Tracker:FindObjectForCode("EarlyMissionChecks").AcquiredCount = 0
		updateEarly("Mission", 0)
	end
	if slot_data["LateMissionsAmount"] then
		count = tonumber(slot_data["LateMissionsAmount"])
		Tracker:FindObjectForCode("LateMissionChecks").AcquiredCount = count
		updateLate("Mission", count)
	else
		Tracker:FindObjectForCode("LateMissionChecks").AcquiredCount = 0
		updateLate("Mission", 0)
	end
	if slot_data["ShardFragmentAmount"] then
		Tracker:FindObjectForCode("RequiredRelicFragmentShards").AcquiredCount = tonumber(slot_data["ShardFragmentAmount"])
	end
	if slot_data["ExtraShardsAmount"] then
		Tracker:FindObjectForCode("ExtraRelicFragmentShards").AcquiredCount = tonumber(slot_data["ExtraShardsAmount"])
	else
		Tracker:FindObjectForCode("ExtraRelicFragmentShards").AcquiredCount = 0
	end
	if slot_data["RequiredInstruments"] then
		Tracker:FindObjectForCode("RequiredInstruments").AcquiredCount = tonumber(slot_data["RequiredInstruments"])
	end
	if slot_data["ExtraInstruments"] then
		Tracker:FindObjectForCode("ExtraInstruments").AcquiredCount = tonumber(slot_data["ExtraInstruments"])
	end
	if slot_data["Goal"] then
		Tracker:FindObjectForCode("Goal").CurrentStage = tonumber(slot_data["Goal"])
	end
	if slot_data["LegendaryAmount"] then
		Tracker:FindObjectForCode("LegendaryAmount").AcquiredCount = tonumber(slot_data["LegendaryAmount"])
	else
		Tracker:FindObjectForCode("LegendaryAmount").AcquiredCount = 0
	end
	if slot_data["DojoDungeonsRandomization"] then
		Tracker:FindObjectForCode("DojoDungeonsRandomization").AcquiredCount = tonumber(slot_data["DojoDungeonsRandomization"])
	else
		Tracker:FindObjectForCode("DojoDungeonsRandomization").AcquiredCount = 0
	end
	if slot_data["SkyPeakType"] then
		Tracker:FindObjectForCode("SkyPeakMode").CurrentStage = tonumber(slot_data["SkyPeakType"]) - 1
	end
	if slot_data["DrinkEvents"] then
		Tracker:FindObjectForCode("DrinkEvents").AcquiredCount = tonumber(slot_data["DrinkEvents"])
	else
		Tracker:FindObjectForCode("DrinkEvents").AcquiredCount = 0
	end
	if slot_data["SpindaDrinks"] then
		Tracker:FindObjectForCode("SpindaDrinks").AcquiredCount = tonumber(slot_data["SpindaDrinks"])
	else
		Tracker:FindObjectForCode("SpindaDrinks").AcquiredCount = 0
	end
	if slot_data["ExcludeSpecial"] then
		Tracker:FindObjectForCode("ExcludeSpecial").Active = tonumber(slot_data["ExcludeSpecial"]) == 1
	end
	if slot_data["SpecialEpisodeSanity"] then
		Tracker:FindObjectForCode("SpecialEpisodeSanity").Active = tonumber(slot_data["SpecialEpisodeSanity"]) == 1
	end
	if slot_data["MaxRank"] then
		Tracker:FindObjectForCode("MaxRank").CurrentStage = tonumber(slot_data["MaxRank"])
	end
	if slot_data["LongLocations"] then
		Tracker:FindObjectForCode("LongLocations").Active = tonumber(slot_data["LongLocations"]) == 1
	end
	if slot_data["CursedAegisCave"] then
		Tracker:FindObjectForCode("CursedAegisCave").Active = tonumber(slot_data["CursedAegisCave"]) == 1
	end
end

-- called right after an AP slot is connected
function onClear(slot_data)
	-- use bulk update to pause logic updates until we are done resetting all items/locations
	Tracker.BulkUpdate = true	
	--print(string.format("called onClear, slot_data:\n%s", dump_table(slot_data)))
	CUR_INDEX = -1
	-- reset locations
	for _, mapping_entry in pairs(LOCATION_MAPPING) do
		for _, location_table in ipairs(mapping_entry) do
			if location_table then
				local location_code = location_table[1]
				if location_code then
					if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
						print(string.format("onClear: clearing location %s", location_code))
					end
					if location_code:sub(1, 1) == "@" then
						local obj = Tracker:FindObjectForCode(location_code)
						if obj then
							obj.AvailableChestCount = obj.ChestCount
						elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
							print(string.format("onClear: could not find location object for code %s", location_code))
						end
					else
						-- reset hosted item
						local item_type = location_table[2]
						resetItem(location_code, item_type)
					end
				elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
					print(string.format("onClear: skipping location_table with no location_code"))
				end
			elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
				print(string.format("onClear: skipping empty location_table"))
			end
		end
	end
	-- reset items
	for _, mapping_entry in pairs(ITEM_MAPPING) do
		for _, item_table in ipairs(mapping_entry) do
			if item_table then
				local item_code = item_table[1]
				local item_type = item_table[2]
				if item_code then
					resetItem(item_code, item_type)
				elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
					print(string.format("onClear: skipping item_table with no item_code"))
				end
			elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
				print(string.format("onClear: skipping empty item_table"))
			end
		end
	end
	apply_slot_data(slot_data)
	LOCAL_ITEMS = {}
	GLOBAL_ITEMS = {}
	-- manually run snes interface functions after onClear in case we need to update them (i.e. because they need slot_data)
	if PopVersion < "0.20.1" or AutoTracker:GetConnectionState("SNES") == 3 then
		-- add snes interface functions here
	end
	Tracker.BulkUpdate = false
end

-- called when an item gets collected
function onItem(index, item_id, item_name, player_number)
	print(string.format("called onItem: %s, %s, %s, %s, %s", index, item_id, item_name, player_number, CUR_INDEX))
	if not AUTOTRACKER_ENABLE_ITEM_TRACKING then
		return
	end
	if index <= CUR_INDEX then
		return
	end
	local is_local = player_number == Archipelago.PlayerNumber
	CUR_INDEX = index;
	local mapping_entry = ITEM_MAPPING[item_id]
	if not mapping_entry then
		if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("onItem: could not find item mapping for id %s", item_id))
		end
		return
	end
	for _, item_table in pairs(mapping_entry) do
		if item_table then
			local item_code = item_table[1]
			local item_type = item_table[2]
			local multiplier = item_table[3] or 1
			if item_code then
				incrementItem(item_code, item_type, multiplier)
				-- keep track which items we touch are local and which are global
				if is_local then
					if LOCAL_ITEMS[item_code] then
						LOCAL_ITEMS[item_code] = LOCAL_ITEMS[item_code] + 1
					else
						LOCAL_ITEMS[item_code] = 1
					end
				else
					if GLOBAL_ITEMS[item_code] then
						GLOBAL_ITEMS[item_code] = GLOBAL_ITEMS[item_code] + 1
					else
						GLOBAL_ITEMS[item_code] = 1
					end
				end
			elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
				print(string.format("onClear: skipping item_table with no item_code"))
			end
		elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("onClear: skipping empty item_table"))
		end
	end
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("local items: %s", dump_table(LOCAL_ITEMS)))
		print(string.format("global items: %s", dump_table(GLOBAL_ITEMS)))
	end
	-- track local items via snes interface
	if PopVersion < "0.20.1" or AutoTracker:GetConnectionState("SNES") == 3 then
		-- add snes interface functions for local item tracking here
	end
end

-- called when a location gets cleared
function onLocation(location_id, location_name)
	print(string.format("called onLocation: %s, %s", location_id, location_name))
	if not AUTOTRACKER_ENABLE_LOCATION_TRACKING then
		return
	end
	local mapping_entry = LOCATION_MAPPING[location_id]
	if not mapping_entry then
		if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("onLocation: could not find location mapping for id %s", location_id))
		end
		return
	end
	for _, location_table in pairs(mapping_entry) do
		if location_table then
			local location_code = location_table[1]
			if location_code then
				local obj = Tracker:FindObjectForCode(location_code)
				if obj then
					if location_code:sub(1, 1) == "@" then
						obj.AvailableChestCount = obj.AvailableChestCount - 1
					else
						-- increment hosted item
						local item_type = location_table[2]
						incrementItem(location_code, item_type)
					end
				elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
					print(string.format("onLocation: could not find object for code %s", location_code))
				end
			elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
				print(string.format("onLocation: skipping location_table with no location_code"))
			end
		elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
			print(string.format("onLocation: skipping empty location_table"))
		end
	end
end

-- called when a locations is scouted
function onScout(location_id, location_name, item_id, item_name, item_player)
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("called onScout: %s, %s, %s, %s, %s", location_id, location_name, item_id, item_name,
			item_player))
	end
	-- not implemented yet :(
end

-- called when a bounce message is received
function onBounce(json)
	if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
		print(string.format("called onBounce: %s", dump_table(json)))
	end
	-- your code goes here
end

-- add AP callbacks
-- un-/comment as needed
Archipelago:AddClearHandler("clear handler", onClear)
if AUTOTRACKER_ENABLE_ITEM_TRACKING then
	Archipelago:AddItemHandler("item handler", onItem)
end
if AUTOTRACKER_ENABLE_LOCATION_TRACKING then
	Archipelago:AddLocationHandler("location handler", onLocation)
end
-- Archipelago:AddScoutHandler("scout handler", onScout)
-- Archipelago:AddBouncedHandler("bounce handler", onBounce)
