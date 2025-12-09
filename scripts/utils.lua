function updateItemGrid(code)
	local darkraiGoal = Tracker:ProviderCountForCode("goal_darkrai")
	local skyPeakAllRandom = Tracker:ProviderCountForCode("AllRandomSkyPeakMode")
	local skyPeakUnlockAll = Tracker:ProviderCountForCode("UnlockAllSkyPeakMode")
	local excludeSpecial = Tracker:ProviderCountForCode("ExcludeSpecial")
	local specialEpisodeSanity = Tracker:ProviderCountForCode("SpecialEpisodeSanity")
	local cursedAegisCave = Tracker:ProviderCountForCode("CursedAegisCave")
	local longLocations = Tracker:ProviderCountForCode("LongLocations")
	
	-- Dungeon Complete
	if longLocations == 1 and darkraiGoal == 1 then
		Tracker:AddLayouts("layouts/dungeons_complete_late_long.json")
	elseif darkraiGoal == 1 then
		Tracker:AddLayouts("layouts/dungeons_complete_late.json")
	else
		Tracker:AddLayouts("layouts/dungeons_complete.json")
	end
	
	-- Dungeons
	if longLocations == 1 and darkraiGoal == 1 and skyPeakUnlockAll == 1 then
		Tracker:AddLayouts("layouts/dungeons_late_long_unlock_all_sky.json")
	elseif longLocations == 1 and darkraiGoal == 1 and skyPeakAllRandom == 1 then
		Tracker:AddLayouts("layouts/dungeons_late_long_random_sky.json")
	elseif longLocations == 1 and darkraiGoal == 1 then
		Tracker:AddLayouts("layouts/dungeons_late_long.json")
	elseif darkraiGoal == 1 and skyPeakUnlockAll == 1 then
		Tracker:AddLayouts("layouts/dungeons_late_unlock_all_sky.json")
	elseif darkraiGoal == 1 and skyPeakAllRandom == 1 then
		Tracker:AddLayouts("layouts/dungeons_late_random_sky.json")
	elseif darkraiGoal == 1 then
		Tracker:AddLayouts("layouts/dungeons_late.json")
	else
		Tracker:AddLayouts("layouts/dungeons.json")
	end
	
	-- Items
	if cursedAegisCave == 1 and darkraiGoal == 1 and excludeSpecial == 1 then
		Tracker:AddLayouts("layouts/items_late_cursed_no_special.json")
	elseif cursedAegisCave == 1 and darkraiGoal == 1 and specialEpisodeSanity == 1 then
		Tracker:AddLayouts("layouts/items_late_cursed_special.json")
	elseif cursedAegisCave == 1 and darkraiGoal == 1 then
		Tracker:AddLayouts("layouts/items_late_cursed.json")
	elseif darkraiGoal == 1 and excludeSpecial == 1 then
		Tracker:AddLayouts("layouts/items_late_no_special.json")
	elseif darkraiGoal == 1 and specialEpisodeSanity == 1 then
		Tracker:AddLayouts("layouts/items_late_special.json")
	elseif darkraiGoal == 1 then
		Tracker:AddLayouts("layouts/items_late.json")
	elseif excludeSpecial == 1 then
		Tracker:AddLayouts("layouts/items_no_special.json")
	elseif specialEpisodeSanity == 1 then
		Tracker:AddLayouts("layouts/items_special.json")
	else
		Tracker:AddLayouts("layouts/items.json")
	end
end

function spindaDrinks(code)
	local drinks = Tracker:ProviderCountForCode("SpindaDrinks")
	local storedDrinks = Tracker:ProviderCountForCode("StoredSpindaDrinks")
	local difference = storedDrinks - drinks
	print("drinks"..drinks)
	if difference ~= 0 then
		local obj = Tracker:FindObjectForCode("@Spinda's Cafe/Spinda/Drink")
		obj.AvailableChestCount = obj.AvailableChestCount + difference
	end
end

function spindaDrinksEvent(code)
	local drinks = Tracker:ProviderCountForCode("DrinkEvents")
	local storedDrinks = Tracker:ProviderCountForCode("StoredDrinkEvents")
	local difference = storedDrinks - drinks
	print("events"..drinks)
	if difference ~= 0 then
		local obj = Tracker:FindObjectForCode("@Spinda's Cafe/Spinda/Drink Event")
		obj.AvailableChestCount = obj.AvailableChestCount + difference
	end
end

function updateMap(code)
	print("update map test")
	local recruit = Tracker:ProviderCountForCode("RecruitAll")
	if recruit == 1 then
		Tracker:AddLayouts("layouts/maps-recruitment.json")
	else
		Tracker:AddLayouts("layouts/maps.json")
	end
end