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

		if castBar.IsInterrupted or castBar.interrupted then
			return
		end

		local targetUnitId = unitId .. "target"

		if not UnitExists(targetUnitId) then
			return
		end

		local targetName = UnitName(targetUnitId)
		local isTargettingMe = targetName == UnitName("player")

		-- Cast is targetting a specific unit
		if targetName then
			-- Nameplate flash options
			if isTargettingMe and envTable.optionsNameplateFlash then
				-- Default value of true since it is turned on in the options
				local showNameplateFlash = true

				if envTable.optionsHideFlashSolo and not UnitInParty("player") and not UnitInRaid("player") then
					showNameplateFlash = false
				end

				if envTable.optionsHideFlashAsTank and GetSpecializationRole(GetSpecialization()) == "TANK" then
					showNameplateFlash = false
				end

				-- Show nameplate flash if conditions met
				if showNameplateFlash then
					Plater.FlashNameplateBody(unitFrame)
				end
			end

			-- Target name in cast bar options
			if envTable.optionsShowTargetName then
				if envTable.optionsReplaceMyName and isTargettingMe then
					targetName = "Me"
				end

				local currentText = castBar.Text:GetText()
				local nextText = ""

				if
					isTargettingMe
					and envTable.optionsHideNameSolo
					and not UnitInParty("player")
					and not UnitInRaid("player")
				then
					nextText = currentText
				else
					local targetNameByColor = Plater.SetTextColorByClass(targetUnitId, targetName)
					nextText = castBar.SpellName .. " " .. targetNameByColor
				end

				if nextText ~= currentText then
					local previousLength = string.len(currentText)
					local newLength = string.len(nextText)
					local needsUpdate = false

					if previousLength < newLength then
						local trimmed = string.sub(nextText, 1, previousLength)

						if trimmed ~= currentText then
							needsUpdate = true
						end
					elseif nextText ~= currentText then
						needsUpdate = true
					end

					if needsUpdate then
						castBar.Text:SetText(nextText)
						-- Shrink the name of the cast bar text if necessary (based on options)
						local castBarWidth = castBar:GetWidth()
						DetailsFramework:TruncateText(castBar.Text, castBarWidth * (envTable.optionsCastNameSize / 100))
					end
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

		if envTable.interruptID ~= nil then
			start, duration = envTable.GetSpellCooldown(envTable.interruptID) --local
			interruptReadyTime = start + duration
		end

		local nextColor = envTable.optionsColorProtected

		if canInterrupt and envTable.interruptID ~= nil then
			local playerIsWarlock = envTable.class == 9

			-- Check to see if the spell is known/talented
			if IsSpellKnown(envTable.interruptID, playerIsWarlock) then
				if interruptReadyTime == 0 then
					nextColor = envTable.optionsColorInterruptAvailable
				elseif
					envTable.optionsShowSecondaryInterrupts
					and envTable.class == 2 -- paladin
					and IsSpellKnown(31935) -- avenger's shield
					and not envTable.isSpellOnCooldown_IgnoreGCD(31935)
				then
					nextColor = envTable.optionsColorSecondaryAvailable
				elseif interruptReadyTime < (castEndTime - 0.25) then
					castBar.tick:Show()
					castBar.tick:SetVertexColor(Plater:ParseColors(envTable.optionsColorTick))
					local tickLocation = (start + duration - castBar.spellStartTime) / castBar.maxValue -- castBar.spellStartTime + 0.25
					if castBar.channeling then
						tickLocation = 1 - tickLocation
					end
					castBar.tick:SetPoint("center", castBar, "left", tickLocation * castBar:GetWidth(), 0)

					nextColor = envTable.optionsColorInterruptSoon
				elseif interruptReadyTime >= (castEndTime - 0.25) then
					nextColor = envTable.optionsColorNoInterrupt
				end
			else
				nextColor = envTable.optionsColorNoInterrupt
			end
		end

		-- Spell Reflection coloring
		if
			envTable.optionsShowSecondaryInterrupts
			and isTargettingMe
			and envTable.class == 1
			and IsSpellKnown(23920) -- spell reflect
			and not envTable.isSpellOnCooldown_IgnoreGCD(23920)
			and modTable.reflectableSpells[castBar.SpellID] == true
		then
			-- Color the bar if the spell is reflectable
			nextColor = envTable.optionsColorSecondaryAvailable
		end

		local currentR, currentG, currentB, currentA = castBar:GetColor()
		local nextR, nextG, nextB, nextA = unpack(nextColor)

		if currentR ~= nextR or currentG ~= nextG or currentB ~= nextB or currentA ~= nextA then
			Plater.SetCastBarColor(unitFrame, nextColor)
		end
	end

	envTable.class = select(3, UnitClass("player"))

	local function determineInterruptId()
		if envTable.class == 1 then -- Warrior
			return function()
				return 6552 -- Pummel
			end
		end

		if envTable.class == 2 then -- Paladin
			return function()
				return 96231 -- Rebuke
			end
		end

		if envTable.class == 3 then -- Hunter
			return function()
				local spec = GetSpecialization()

				if spec == 3 then -- survival
					return 187707 -- muzzle
				end

				return 147362 -- counter shot
			end
		end

		if envTable.class == 4 then -- rogue
			return function()
				return 1766 -- kick
			end
		end

		if envTable.class == 5 then -- priest
			return function()
				local spec = GetSpecialization()

				if spec == 3 then -- shadow
					return 15487 -- silence
				end

				return nil
			end
		end

		if envTable.class == 6 then -- death knight
			return function()
				return 47528 -- mind freeze
			end
		end

		if envTable.class == 7 then -- shaman
			return function()
				return 57994
			end
		end

		if envTable.class == 8 then -- mage
			return function()
				return 2139 -- counterspell
			end
		end

		if envTable.class == 9 then -- warlock
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

		if envTable.class == 10 then -- monk
			return function()
				return 116705 -- spear hand strike
			end
		end

		if envTable.class == 11 then -- druid
			return function()
				local spec = GetSpecialization()

				if spec == 1 then -- balance
					return 78675 -- soalr beam
				end

				return 106839 -- skull bash
			end
		end

		if envTable.class == 12 then -- demon hunter
			return function()
				return 183752 -- disrupt
			end
		end

		if envTable.class == 13 then -- evoker
			return function()
				return 351338 -- quell
			end
		end
	end

	envTable.GetInterruptId = determineInterruptId()

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
