function f(self, unitId, unitFrame, envTable, scriptTable, id)
	--insert code here
	local specId = GetSpecialization()

	local shouldChange = Plater.PlayerClass == "MAGE" and specId == 3
	scriptTable.changeNameplateColor = shouldChange and scriptTable.config.useNameplateColor
	scriptTable.changeBorderColor = shouldChange and scriptTable.config.useBorderColor
	scriptTable.changeNameColor = shouldChange and scriptTable.config.useNameColor

	function envTable.UpdateColor(unitframe)
		if scriptTable.changeNameplateColor == true then
			Plater.SetNameplateColor(unitFrame, scriptTable.config.healthBarColor)
			Plater.DenyColorChange(unitFrame, true)
		end
		if scriptTable.changeBorderColor == true then
			Plater.SetBorderColor(unitFrame, scriptTable.config.borderColor)
			Plater.DenyColorChange(unitFrame, true)
		end
		if scriptTable.changeNameColor == true then
			Plater:SetFontColor(unitFrame.unitName, scriptTable.config.nameColor)
			Plater.DenyColorChange(unitFrame, true)
		end
	end
end
