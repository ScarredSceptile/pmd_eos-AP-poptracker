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

function canAccessSkyPeak(passNum)
	local pass = tonumber(passNum)
	if Tracker:ProviderCountForCode("SkyPeakMode") == 0 then
		return Tracker:ProviderCountForCode("Progressive Sky Peak") >= pass
	end
	if Tracker:ProviderCountForCode("SkyPeakMode") == 1 then
		if pass == 1 then
			return Tracker:ProviderCountForCode("1st Station Pass")
		end
		if pass == 2 then
			return Tracker:ProviderCountForCode("2nd Station Pass")
		end
		if pass == 3 then
			return Tracker:ProviderCountForCode("3rd Station Pass")
		end
		if pass == 4 then
			return Tracker:ProviderCountForCode("4th Station Pass")
		end
		if pass == 5 then
			return Tracker:ProviderCountForCode("5th Station Pass")
		end
		if pass == 6 then
			return Tracker:ProviderCountForCode("6th Station Pass")
		end
		if pass == 7 then
			return Tracker:ProviderCountForCode("7th Station Pass")
		end
		if pass == 8 then
			return Tracker:ProviderCountForCode("8th Station Pass")
		end
		if pass == 9 then
			return Tracker:ProviderCountForCode("9th Station Pass")
		end
		if pass == 10 then
			return Tracker:ProviderCountForCode("Sky Peak Summit Pass")
		end
	end
	return Tracker:ProviderCountForCode("Sky Peak")
end

function aegisAccess(sealNum)
	local seal = tonumber(sealNum)
	if Tracker:ProviderCoundForCode("CursedAegisCave") == 1 then
		return Tracker:ProviderCountForCode("Progressive Seal") >= seal
	end
	return true
end