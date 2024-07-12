function f(modTable)
	function modTable.UpdateEXETalent()
		modTable.EXEenabled = false
		modTable.uEXEenabled = false
		modTable.EXEpercent = 0
		modTable.EXEalert = modTable.config.EXEalert / 100
		modTable.SER = 1

		local _, class = UnitClass("player")
		local spec = GetSpecialization()
		local specID = GetSpecializationInfo(spec) or 0
		if not (spec or class or specID) or specID == 0 then
			return
		end

		if class == "MAGE" then
			if specID == 62 then
				local using_Bombardment = IsPlayerSpell(384581)
				if using_Bombardment then
					modTable.EXEenabled = true
					modTable.EXEpercent = 0.35
				end
			elseif specID == 63 then
				local using_Firestarter = IsPlayerSpell(205026)
				local using_Touch = IsPlayerSpell(269644)
				if using_Firestarter then
					modTable.uEXEenabled = true
					modTable.SER = 0.9
				end
				if using_Touch then
					modTable.EXEenabled = true
					modTable.EXEpercent = 0.3
				end
			end
		elseif class == "WARLOCK" then
			if specID == 265 then
				local using_Souldrain = IsPlayerSpell(198590)
				if using_Souldrain then
					modTable.EXEenabled = true
					modTable.EXEpercent = 0.2
				end
			elseif specID == 267 then
				local using_Shadowburn = IsPlayerSpell(17877)
				if using_Shadowburn then
					modTable.EXEenabled = true
					modTable.EXEpercent = 0.2
				end
			end
		elseif class == "PRIEST" then
			local using_ToF = IsPlayerSpell(390972)
			local using_SWD = IsPlayerSpell(32379)
			if using_ToF then
				modTable.EXEenabled = true
				modTable.EXEpercent = 0.2
			elseif using_SWD then
				modTable.EXEenabled = true
				modTable.EXEpercent = 0.2
			end
		elseif class == "WARRIOR" then
			modTable.EXEenabled = true
			modTable.EXEpercent = 0.2
			if (specID == 72 and IsPlayerSpell(206315)) or IsPlayerSpell(281001) then
				modTable.EXEpercent = 0.35
			end
		elseif class == "HUNTER" then
			local using_KillShot = IsPlayerSpell(53351)
			local using_KillerInstinct = IsPlayerSpell(273887)
			if using_KillerInstinct then
				modTable.EXEenabled = true
				modTable.EXEpercent = 0.35
			elseif using_KillShot then
				modTable.EXEenabled = true
				modTable.EXEpercent = 0.2
			end

			if specID == 254 then
				local using_CarefulAim = IsPlayerSpell(260228)
				if using_CarefulAim then
					modTable.uEXEenabled = true
					modTable.SER = 0.7
				end
			end
		elseif class == "ROGUE" then
			if specID == 259 then
				local using_Blindside = IsPlayerSpell(328085)
				if using_Blindside then
					modTable.EXEenabled = true
					modTable.EXEpercent = 0.35
				end
			end
		elseif class == "PALADIN" then
			if IsPlayerSpell(24275) then
				modTable.EXEenabled = true
				modTable.EXEpercent = 0.2
			end
		elseif class == "MONK" then
			if IsPlayerSpell(322109) then
				modTable.EXEenabled = true
				modTable.EXEpercent = 0.15
			end
		elseif class == "DEATHKNIGHT" then
			local using_Soulreaper = IsPlayerSpell(343294)
			if using_Soulreaper then
				modTable.EXEenabled = true
				modTable.EXEpercent = 0.35
			end
		end

		local EXECUTE = EXECUTE or CreateFrame("frame", "EXECUTE", UIParent)
		EXECUTE:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
		EXECUTE:RegisterEvent("SOULBIND_ACTIVATED")
		EXECUTE:SetScript("OnEvent", function(self, event, ...)
			modTable.UpdateEXETalent()
		end)
	end
end
