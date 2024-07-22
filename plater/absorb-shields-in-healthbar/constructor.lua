function f(self, unitId, unitFrame, envTable, modTable)
	--Disable for classic
	if WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE then
		function envTable.addHook(unitFrame) end
		return
	end

	--settings: (changing this requires a /reload)
	local shieldTexture = ""
	--local shieldTexture = "Details Flat"
	local useHalfBar = false --use a "half bar" overlay if the health+absorb is > 100% of the health

	--init
	local hb = unitFrame.healthBar
	if shieldTexture and shieldTexture ~= "" then
		local texture = modTable.LibSharedMedia:Fetch("statusbar", shieldTexture)
		hb.Settings.ShieldIndicatorTexture = texture or [[Interface\RaidFrame\Shield-Fill]]
		hb.shieldAbsorbIndicator:SetTexture(hb.Settings.ShieldIndicatorTexture, true, true)
	else
		hb.Settings.ShieldIndicatorTexture = [[Interface\RaidFrame\Shield-Fill]]
		hb.shieldAbsorbIndicator:SetTexture(hb.Settings.ShieldIndicatorTexture, true, true)
	end

	-- ensure settings are up to date... workardound till fix in Plater core.
	unitFrame.healthBar.Settings.ShowShields = Plater.db.profile.show_shield_prediction

	-- overwrite UpdateHealPrediction on the healthBar
	function envTable.addHook(unitFrame)
		if WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE then
			return
		end
		local hb = unitFrame.healthBar

		if hb.isCustomShieldHook then
			return
		end
		--health and absorbs prediction from Plater core, reworked to integrate shields into the health bar
		hb.UpdateHealPrediction = function(self)
			local currentHealth = self.currentHealth
			local currentHealthMax = self.currentHealthMax
			local healthPercent = currentHealth / currentHealthMax

			if not currentHealthMax or currentHealthMax <= 0 then
				return
			end

			--order is: the health of the unit > damage absorb > heal absorb > incoming heal
			local width = self:GetWidth()

			hb.shieldAbsorbIndicator:Hide()
			hb.shieldAbsorbGlow:Hide()

			if not self.displayedUnit then
				return
			end

			if self.Settings.ShowHealingPrediction then
				--incoming heal on the unit from all sources
				local unitHealIncoming = UnitGetIncomingHeals(self.displayedUnit) or 0
				--heal absorbs
				local unitHealAbsorb = UnitGetTotalHealAbsorbs(self.displayedUnit) or 0

				if unitHealIncoming > 0 then
					--calculate what is the percent of health incoming based on the max health the player has
					local incomingPercent = unitHealIncoming / currentHealthMax
					self.incomingHealIndicator:Show()
					self.incomingHealIndicator:SetWidth(
						max(1, min(width * incomingPercent, abs(healthPercent - 1) * width))
					)
					self.incomingHealIndicator:SetPoint("topleft", self, "topleft", width * healthPercent, 0)
					self.incomingHealIndicator:SetPoint("bottomleft", self, "bottomleft", width * healthPercent, 0)
				else
					self.incomingHealIndicator:Hide()
				end

				if unitHealAbsorb > 0 then
					local healAbsorbPercent = unitHealAbsorb / currentHealthMax
					self.healAbsorbIndicator:Show()
					self.healAbsorbIndicator:SetWidth(
						max(1, min(width * healAbsorbPercent, abs(healthPercent - 1) * width))
					)
					self.healAbsorbIndicator:SetPoint("topleft", self, "topleft", width * healthPercent, 0)
					self.healAbsorbIndicator:SetPoint("bottomleft", self, "bottomleft", width * healthPercent, 0)
				else
					self.healAbsorbIndicator:Hide()
				end
			end

			if self.Settings.ShowShields then
				--damage absorbs
				local unitDamageAbsorb = UnitGetTotalAbsorbs(self.displayedUnit) or 0
				self.currentAbsorb = unitDamageAbsorb

				if unitDamageAbsorb > 0 then
					local curHealthTotal = unitDamageAbsorb + currentHealth
					local damageAbsorbPercent
					local healthPercentAbsorb
					local isHalfBar = false
					if curHealthTotal > currentHealthMax then
						if useHalfBar then
							damageAbsorbPercent = unitDamageAbsorb / currentHealthMax
							if damageAbsorbPercent > 1 then
								damageAbsorbPercent = 1 -- just limit it to the healthbar width...
							end
							healthPercentAbsorb = 1 - damageAbsorbPercent
							self:SetMinMaxValues(0, currentHealthMax)

							isHalfBar = true
						else
							damageAbsorbPercent = unitDamageAbsorb / curHealthTotal
							healthPercentAbsorb = currentHealth / curHealthTotal
							self:SetMinMaxValues(0, curHealthTotal)
						end
					else
						damageAbsorbPercent = unitDamageAbsorb / currentHealthMax
						healthPercentAbsorb = currentHealth / currentHealthMax
						self:SetMinMaxValues(0, currentHealthMax)
					end
					--print(healthPercentAbsorb, currentHealth, unitDamageAbsorb, damageAbsorbPercent)

					self.shieldAbsorbIndicator:SetWidth(width * damageAbsorbPercent)
					self.shieldAbsorbIndicator:SetPoint(
						"topleft",
						self,
						"topleft",
						width * healthPercentAbsorb,
						(isHalfBar and (-self:GetHeight() / 2)) or 0
					)
					self.shieldAbsorbIndicator:SetPoint(
						"bottomleft",
						self,
						"bottomleft",
						width * healthPercentAbsorb,
						0
					)

					self.shieldAbsorbIndicator:Show()
				else
					self.shieldAbsorbIndicator:Hide()
				end
			end

			hb.isCustomShieldHook = true
		end

		if hb.displayedUnit then
			hb.shieldAbsorbIndicator:Hide()
			hb.shieldAbsorbGlow:Hide()
			hb:UNIT_MAXHEALTH()
		else
			hb.customShieldHookNeedsUpdate = true
		end
	end
end
