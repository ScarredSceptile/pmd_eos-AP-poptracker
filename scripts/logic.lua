function early_missions()
	local missionCount = Tracker:ProviderCountForCode("EarlyMissionChecks")
	return missionCount > 0
end

function early_outlaws()
	local outlawCount = Tracker:ProviderCountForCode("EarlyOutlawChecks")
	return outlawCount > 0
end

function late_missions()
	local latemissionCount = Tracker:ProviderCountForCode("LateMissionChecks")
	return latemissionCount > 0 and darkraiGoal()
end

function late_outlaws()
	local lateoutlawCount = Tracker:ProviderCountForCode("LateOutlawChecks")
	return lateoutlawCount > 0 and darkraiGoal()
end

function darkraiGoal()
	local count = Tracker:ProviderCountForCode("goal_darkrai")
	return count > 0
end

function enoughRelicFragments()
	local relicCount = Tracker:ProviderCountForCode("RelicFragmentCount")
	local relicGoal = Tracker:ProviderCountForCode("RequiredRelicFragmentShards")
	return relicCount >= relicGoal
end

function canAccessDarkCrater()
	if darkraiGoal() then
		local instrumentCount = Tracker:ProviderCountForCode("Instruments")
		local instrumentGoal = Tracker:ProviderCountForCode("RequiredInstruments")
		return instrumentCount >= instrumentGoal and Tracker:ProviderCountForCode("Complete Temporal Tower")
	end
	return Tracker:ProviderCountForCode("Dark Crater") == 1
end

function canAccessSkyPeak(...)
	print(...)
	if Tracker:ProviderCountForCode("UnlockAllSkyPeakMode") == 1 then
		return Tracker:ProviderCountForCode("Sky Peak")
	end
	if Tracker:ProviderCountForCode("AllRandomSkyPeakMode") == 1 then
		local canAccess = 0
		for i,passNum in ipairs({...}) do
			local pass = tonumber(passNum)
			if pass == 1 then
				canAccess = Tracker:ProviderCountForCode("1st Station Pass")
			end
			if pass == 2 then
				canAccess = Tracker:ProviderCountForCode("2nd Station Pass")
			end
			if pass == 3 then
				canAccess = Tracker:ProviderCountForCode("3rd Station Pass")
			end
			if pass == 4 then
				canAccess = Tracker:ProviderCountForCode("4th Station Pass")
			end
			if pass == 5 then
				canAccess = Tracker:ProviderCountForCode("5th Station Pass")
			end
			if pass == 6 then
				canAccess = Tracker:ProviderCountForCode("6th Station Pass")
			end
			if pass == 7 then
				canAccess = Tracker:ProviderCountForCode("7th Station Pass")
			end
			if pass == 8 then
				canAccess = Tracker:ProviderCountForCode("8th Station Pass")
			end
			if pass == 9 then
				canAccess = Tracker:ProviderCountForCode("9th Station Pass")
			end
			if pass == 10 then
				canAccess = Tracker:ProviderCountForCode("Sky Peak Summit Pass")
			end
			if canAccess == 1 then
				return 1
			end
		end
		return 0
	end
	for i,passNum in ipairs({...}) do
		local pass = tonumber(passNum)
		return Tracker:ProviderCountForCode("Progressive Sky Peak") >= pass
	end
end

function aegisAccess(sealNum)
	local seal = tonumber(sealNum)
	if Tracker:ProviderCountForCode("CursedAegisCave") == 1 then
		return Tracker:ProviderCountForCode("Progressive Seal") >= seal
	end
	return true
end

function specialEpisodeAccess()
	return Tracker:ProviderCountForCode("ExcludeSpecial") == 0
end