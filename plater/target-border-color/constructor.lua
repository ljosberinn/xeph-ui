function f(self, unitId, unitFrame, envTable, modTable)
	local function holdsSameColor(frame, nextColor)
		local currentR, currentG, currentB, currentA =
			unpack(frame.customBorderColor and frame.customBorderColor or Plater.db.profile.border_color)
		local nextR, nextG, nextB, nextA = unpack(nextColor or Plater.db.profile.border_color)

		return currentR == nextR and currentG == nextG and currentB == nextB and currentA == nextA
	end

	function envTable.updateBorderColor(frame)
		local color = nil

		if UnitIsUnit("target", unitFrame.unit) then
			color = modTable.config.targetColor
		elseif UnitIsUnit("focus", unitFrame.unit) then
			color = modTable.config.focusColor
		end

		if not holdsSameColor(frame, color) then
			Plater.SetBorderColor(frame, color)
		end
	end
end
