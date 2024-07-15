function f(self, unitId, unitFrame, envTable, scriptTable, id)
	local shouldChange = Plater.PlayerClass == "MAGE" and GetSpecialization() == 3
	scriptTable.changeNameplateColor = shouldChange and scriptTable.config.useNameplateColor
	scriptTable.changeBorderColor = shouldChange and scriptTable.config.useBorderColor
	scriptTable.changeNameColor = shouldChange and scriptTable.config.useNameColor

	function envTable.UpdateColor(unitframe)
		if not shouldChange then
			return
		end

		if scriptTable.changeNameplateColor then
			Plater.SetNameplateColor(unitFrame, scriptTable.config.healthBarColor)
			Plater.DenyColorChange(unitFrame, true)
		end
		if scriptTable.changeBorderColor then
			Plater.SetBorderColor(unitFrame, scriptTable.config.borderColor)
			Plater.DenyColorChange(unitFrame, true)
		end
		if scriptTable.changeNameColor then
			Plater:SetFontColor(unitFrame.unitName, scriptTable.config.nameColor)
			Plater.DenyColorChange(unitFrame, true)
		end
	end
end
