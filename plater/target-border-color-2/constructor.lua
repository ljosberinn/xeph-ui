function f(self, unitId, unitFrame, envTable, modTable)
	local targetBorderColor = modTable.config.targetColor
	local focusBorderColor = modTable.config.focusColor

	modTable.target = nil
	modTable.focus = nil

	local function holdsSameColor(frame, nextColor)
		local currentR, currentG, currentB, currentA =
			unpack(frame.customBorderColor and frame.customBorderColor or Plater.db.profile.border_color)
		local nextR, nextG, nextB, nextA = unpack(nextColor or Plater.db.profile.border_color)

		return currentR == nextR and currentG == nextG and currentB == nextB and currentA == nextA
	end

	function envTable.updateBorderColor(frame)
		if unitFrame.namePlateIsTarget then
			if holdsSameColor(unitFrame, targetBorderColor) then
				return
			end

			Plater.SetBorderColor(unitFrame, targetBorderColor)
			modTable.target = unitFrame
		elseif unitFrame.IsFocus then
			if holdsSameColor(unitFrame, focusBorderColor) then
				return
			end

			Plater.SetBorderColor(unitFrame, focusBorderColor)
			modTable.focus = unitFrame
		else
			if not UnitExists("target") then
				modTable.target = nil
			end

			if not UnitExists("focus") or UnitIsFriend("focus", "player") then
				modTable.focus = nil
			else
				local plate = C_NamePlate.GetNamePlateForUnit("focus")

				if plate and plate.unitFrame then
					modTable.focus = plate.unitFrame
				end
			end

			if modTable.target ~= unitFrame and modTable.focus ~= unitFrame and not holdsSameColor(unitFrame) then
				Plater.SetBorderColor(unitFrame)
			end
		end
	end
end
