function f(self, unitId, unitFrame, envTable, modTable)
	do
		function envTable.UnitInExecuteRange(unitFrame)
			if
				(modTable.config.onlyNPC and UnitIsPlayer(unitFrame.unit))
				or (
					modTable.config.TrackAggro
					and (
						(unitFrame.namePlateThreatIsTanking and not Plater.PlayerIsTank)
						or (not unitFrame.namePlateThreatIsTanking and Plater.PlayerIsTank)
					)
				)
			then
				if unitFrame.executeRangeColored then
					unitFrame.executeRangeColored = false
				end
				return
			end

			if modTable.config.EXEhbcon then
				Plater.SetNameplateColor(unitFrame, modTable.config.EXEhbcolor)
				unitFrame.executeRangeColored = true
			end

			if modTable.config.EXEbdron then
				Plater.SetBorderColor(unitFrame, modTable.config.EXEbdrcolor)
				unitFrame.executeRangeColored = true
			end
		end

		function envTable.UnitInExecuteAlertRange(unitFrame, divisorPercent)
			if modTable.config.EXEhdoff then
				unitFrame.healthBar.healthCutOff:Hide()
				unitFrame.healthBar.ExecuteGlowUp:Hide()
				unitFrame.healthBar.ExecuteGlowDown:Hide()
				unitFrame.healthBar.executeRange:Hide()
			else
				envTable.UpdateHealthDivisor(unitFrame, divisorPercent)
			end
		end

		function envTable.UpdateHealthDivisor(unitFrame, divisorPercent)
			local healthBar = unitFrame.healthBar

			healthBar.healthCutOff:Show()
			healthBar.healthCutOff:SetVertexColor(DetailsFramework:ParseColors(modTable.config.EXEhdcolor))
			healthBar.healthCutOff.ShowAnimation:Play()

			if Plater.db.profile.health_cutoff_extra_glow then
				healthBar.ExecuteGlowUp.ShowAnimation:Play()
				healthBar.ExecuteGlowDown.ShowAnimation:Play()
			end

			healthBar.executeRange:Show()
			healthBar.executeRange:SetVertexColor(DetailsFramework:ParseColors(modTable.config.EXEhicolor))

			if modTable.EXEenabled or modTable.uEXEenabled then
				healthBar.healthCutOff:ClearAllPoints()
				healthBar.healthCutOff:SetPoint("center", healthBar, "left", healthBar:GetWidth() * divisorPercent, 0)
				healthBar.healthCutOff:SetSize(healthBar:GetHeight(), healthBar:GetHeight())

				healthBar.executeRange:ClearAllPoints()
				if divisorPercent == modTable.EXEpercent then
					healthBar.executeRange:SetTexCoord(0, modTable.EXEpercent, 0, 1)
					healthBar.executeRange:SetPoint("left", healthBar, "left", 0, 0)
					healthBar.executeRange:SetPoint("right", healthBar.healthCutOff, "center")
				elseif divisorPercent == modTable.SER then
					healthBar.executeRange:SetTexCoord(0, modTable.SER, 0, 1)
					healthBar.executeRange:SetPoint("left", healthBar.healthCutOff, "center")
					healthBar.executeRange:SetPoint("right", healthBar, "right", 0, 0)
				end
				healthBar.executeRange:SetHeight(healthBar:GetHeight())
			end
		end
	end
end
