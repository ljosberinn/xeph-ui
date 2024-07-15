function f(self, unitId, unitFrame, envTable, modTable)
	if
		UnitIsTapDenied(unitId)
		or unitFrame.IsSelf
		or unitFrame.PlayerCannotAttack
		or not unitFrame.healthBar:IsShown()
	then
		return
	end

	if modTable.EXEenabled or modTable.uEXEenabled then
		local percent = unitFrame.healthBar.CurrentHealth / unitFrame.healthBar.CurrentHealthMax
		local execute = modTable.EXEpercent
		if modTable.EXEenabled and (percent <= execute) then
			if not unitFrame.coloredByScript then
				envTable.UnitInExecuteRange(unitFrame)
			end
			if not unitFrame.healthBar.healthCutOff:IsShown() then
				envTable.UnitInExecuteAlertRange(unitFrame, execute)
			end
		elseif modTable.uEXEenabled and (percent >= modTable.SER and percent < 1) then
			if not unitFrame.coloredByScript then
				envTable.UnitInExecuteRange(unitFrame)
			end
			if not unitFrame.healthBar.healthCutOff:IsShown() then
				envTable.UnitInExecuteAlertRange(unitFrame, modTable.SER)
			end
		else
			if unitFrame.executeRangeColored then
				if modTable.config.EXEhbcon then
					Plater.RefreshNameplateColor(unitFrame)
				end
				if modTable.config.EXEbdron then
					Plater.SetBorderColor(unitFrame)
				end
				unitFrame.executeRangeColored = false
			end

			if modTable.EXEenabled and (percent > execute and percent <= execute + modTable.EXEalert) then
				if not unitFrame.healthBar.healthCutOff:IsShown() then
					envTable.UnitInExecuteAlertRange(unitFrame, execute)
				end
			else
				if unitFrame.healthBar.healthCutOff:IsShown() then
					unitFrame.healthBar.healthCutOff:Hide()
					unitFrame.healthBar.ExecuteGlowUp:Hide()
					unitFrame.healthBar.ExecuteGlowDown:Hide()
					unitFrame.healthBar.executeRange:Hide()
				end
			end
		end
		-- dirty hax
		unitFrame.healthBar.healthCutOff:SetAlpha(modTable.config.EXEhdalpha / 100)
	else
		if unitFrame.InExecuteRange then
			envTable.UnitInExecuteRange(unitFrame, 0)
		end
	end
end
