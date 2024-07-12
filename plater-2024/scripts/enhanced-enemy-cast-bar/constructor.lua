function f(self, unitId, unitFrame, envTable, modTable)
	-- Create a tick if it doesn't already exist. The tick will be used to show when interrupt will be available.
	if not unitFrame.castBar.tick then
		unitFrame.castBar.tick = unitFrame.castBar:CreateTexture(nil, "overlay")
		unitFrame.castBar.tick:SetDrawLayer("overlay", 4)
		unitFrame.castBar.tick:SetBlendMode("DISABLE")
		--unitFrame.castBar.tick:SetHeight(unitFrame.castBar:GetHeight())
		unitFrame.castBar.tick:SetHeight(8)
	end
	unitFrame.castBar.tick:SetTexture(Plater.SparkTextures[8])
	unitFrame.castBar.tick:SetVertexColor(Plater:ParseColors(envTable.optionsColorTick))
	unitFrame.castBar.tick:SetWidth(2)

	---@param spellId number
	---@return number, number, number, number
	function envTable.GetSpellCooldown(spellId)
		if C_Spell.GetSpellCooldown then
			local info = C_Spell.GetSpellCooldown(spellId)
			return info.startTime, info.duration, info.isEnabled, info.modRate
		end

		return GetSpellCooldown(spellId)
	end

	---@param unitId string
	function envTable.EnhancedCastBar(unitId, castBar)
		castBar.tick:Hide()

		if castBar.IsInterrupted then
			return
		end

		local targetUnitId = unitId .. "target"

		if not UnitExists(targetUnitId) then
			return
		end

		local targetName = UnitName(targetUnitId)
		local spellName = castBar.SpellName
		local inParty = UnitInParty("player")
		local inRaid = UnitInRaid("player")
		castBar.Text:SetText(spellName)
		local isTargettingMe = targetName == UnitName("player")

		-- Cast is targetting a specific unit
		if targetName then
			-- Nameplate flash options
			if isTargettingMe then
				if envTable.optionsNameplateFlash then
					-- Default value of true since it is turned on in the options
					local showNameplateFlash = true

					-- Hide flash when not in a group
					if envTable.optionsHideFlashSolo then
						if not inParty and not inRaid then
							showNameplateFlash = false
						end
					end

					-- Hide flash when player is a tank specialization
					if envTable.optionsHideFlashAsTank then
						if GetSpecializationRole(GetSpecialization()) == "TANK" then
							showNameplateFlash = false
						end
					end

					-- Show nameplate flash if conditions met
					if showNameplateFlash then
						Plater.FlashNameplateBody(unitFrame)
					end
				end
			end

			-- Target name in cast bar options
			if envTable.optionsShowTargetName then
				-- Change character name to "Me" if turned on in options
				if envTable.optionsReplaceMyName and isTargettingMe then
					targetName = "Me"
				end

				-- Color the target name based on the targets class color
				local targetNameByColor = Plater.SetTextColorByClass(targetUnitId, targetName)

				-- Shrink the name of the cast bar text if necessary (based on options)
				local castBarWidth = castBar:GetWidth()
				DetailsFramework:TruncateText(castBar.Text, castBarWidth * (envTable.optionsCastNameSize / 100))

				-- Update the cast bar text
				local currentText = castBar.Text:GetText()
				if currentText ~= nil and currentText ~= "" then
					local castText = currentText .. " " .. targetNameByColor

					-- Hide self target name when solo
					if envTable.optionsHideNameSolo then
						if not inParty and not inRaid then
							if isTargettingMe then
								castText = currentText
							end
						end
					end
					castBar.Text:SetText(castText)
					DetailsFramework:TruncateText(castBar.Text, castBarWidth)
				end
			end
		end

		if not envTable.optionsShowInterruptColor then
			return
		end

		-- Interrupt bar color options
		local canInterrupt = castBar.canInterrupt
		local castEndTime = castBar.spellEndTime
		local interruptReadyTime = 0
		local start
		local duration
		local playerIsWarlock

		if envTable.interruptID ~= nil then
			start, duration = envTable.GetSpellCooldown(envTable.interruptID) --local
			interruptReadyTime = start + duration
		end

		if canInterrupt then
			if envTable.interruptID ~= nil then
				-- Is the player a warlock?
				playerIsWarlock = envTable.class == 9

				-- Check to see if the spell is known/talented
				if IsSpellKnown(envTable.interruptID, playerIsWarlock) then
					if interruptReadyTime == 0 then
						Plater.SetCastBarColor(unitFrame, envTable.optionsColorInterruptAvailable)
					elseif
						envTable.optionsShowSecondaryInterrupts
						and envTable.class == 2
						and IsSpellKnown(31935)
						and not envTable.isSpellOnCooldown_IgnoreGCD(31935)
					then
						-- Paladin Avenger's Shield
						Plater.SetCastBarColor(unitFrame, envTable.optionsColorSecondaryAvailable)
					elseif interruptReadyTime < (castEndTime - 0.25) then
						castBar.tick:Show()
						castBar.tick:SetVertexColor(Plater:ParseColors(envTable.optionsColorTick))
						local tickLocation = (start + duration - castBar.spellStartTime) / castBar.maxValue -- castBar.spellStartTime + 0.25
						if castBar.channeling then
							tickLocation = 1 - tickLocation
						end
						castBar.tick:SetPoint("center", castBar, "left", tickLocation * castBar:GetWidth(), 0)

						Plater.SetCastBarColor(unitFrame, envTable.optionsColorInterruptSoon)
					elseif interruptReadyTime >= (castEndTime - 0.25) then
						Plater.SetCastBarColor(unitFrame, envTable.optionsColorNoInterrupt)
					end
				else
					Plater.SetCastBarColor(unitFrame, envTable.optionsColorNoInterrupt)
				end
			end
		else
			Plater.SetCastBarColor(unitFrame, envTable.optionsColorProtected)
		end

		-- Spell Reflection coloring
		if
			envTable.optionsShowSecondaryInterrupts
			and isTargettingMe
			and IsSpellKnown(23920)
			and not envTable.isSpellOnCooldown_IgnoreGCD(23920)
			and envTable.IsSpellReflectable(castBar.SpellName, castBar.SpellID)
		then
			-- Color the bar if the spell is reflectable
			Plater.SetCastBarColor(unitFrame, envTable.optionsColorSecondaryAvailable)
		end
	end

	local function determineInterruptId()
		local class = select(3, UnitClass("player"))

		if class == 1 then -- Warrior
			return function()
				return 6552 -- Pummel
			end
		end

		if class == 2 then -- Paladin
			return function()
				return 96231 -- Rebuke
			end
		end

		if class == 3 then -- Hunter
			return function()
				local spec = GetSpecialization()

				if spec == 3 then -- survival
					return 187707 -- muzzle
				end

				return 147362 -- counter shot
			end
		end

		if class == 4 then -- rogue
			return function()
				return 1766 -- kick
			end
		end

		if class == 5 then -- priest
			return function()
				local spec = GetSpecialization()

				if spec == 3 then -- shadow
					return 15487 -- silence
				end

				return nil
			end
		end

		if class == 6 then -- death knight
			return function()
				return 47528 -- mind freeze
			end
		end

		if class == 7 then -- shaman
			return function()
				return 57994
			end
		end

		if class == 8 then -- mage
			return function()
				return 2139 -- counterspell
			end
		end

		if class == 9 then -- warlock
			return function()
				if IsSpellKnown(89766, true) then -- felguard: axe toss
					return 89766
				end

				if IsSpellKnown(19647, true) then -- felhunter: spell lock
					return 19647
				end

				if C_UnitAuras.GetPlayerAuraBySpellID(196099) ~= nil and IsSpellKnown(132409, true) then -- spell lock via grimoire of sacrifice
					return 132409
				end

				return nil
			end
		end

		if class == 10 then -- monk
			return function()
				return 116705 -- spear hand strike
			end
		end

		if class == 11 then -- druid
			return function()
				local spec = GetSpecialization()

				if spec == 1 then -- balance
					return 78675 -- soalr beam
				end

				return 106839 -- skull bash
			end
		end

		if class == 12 then -- demon hunter
			return function()
				return 183752 -- disrupt
			end
		end

		if class == 13 then -- evoker
			return function()
				return 351338 -- quell
			end
		end
	end

	envTable.GetInterruptId = determineInterruptId()

	-- Checks to see if the spell being cast is reflectable. Checks for a spell name and zone ID match.
	---@param spellName string
	---@param spellId number
	---@return boolean
	function envTable.IsSpellReflectable(spellName, spellId)
		local zoneId = C_Map.GetBestMapForUnit("player")
		local spellNames = modTable.reflectableSpellsByZoneId[zoneId]

		if not spellNames then
			return false
		end

		return spellNames[spellName] == true
	end

	-- Checks to see if a spell is on cooldown, not counting the 1.5s cooldown from global cooldown.
	---@param spellID number
	---@return boolean
	function envTable.isSpellOnCooldown_IgnoreGCD(spellID)
		local gcdSTART, gcdDUR = envTable.GetSpellCooldown(61304) -- GCD
		local GCD_expirationTime = gcdSTART + gcdDUR
		local spellStart, spellDuration = envTable.GetSpellCooldown(spellID)
		local spellReadyTime = spellStart + spellDuration
		return spellReadyTime > GCD_expirationTime
	end
end
