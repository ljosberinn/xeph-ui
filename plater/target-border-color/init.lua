function f(modTable)
	local targetBorderColor = "#ffffff"
	local focusBorderColor = "#00FFFF"
	-- local nonTargetBorderColor = "white"

	---@class Cache
	---@field current Frame|nil
	---@field id number|nil

	---@type Cache
	modTable.target = {
		current = nil,
		id = nil,
	}

	---@type Cache
	modTable.focus = {
		current = nil,
		id = nil,
	}

	---@param token string
	local function GetUnitFrameForToken(token)
		local frame = C_NamePlate.GetNamePlateForUnit(token)

		--and frame.unitFrame.PlaterOnScreen
		if frame and frame.unitFrame then
			return frame.unitFrame
		end

		return nil
	end

	do
		local targetGUID = UnitGUID("target")
		local targetToken = targetGUID and UnitTokenFromGUID(targetGUID) or nil

		if targetToken then
			modTable.target.current = GetUnitFrameForToken(targetToken)
		end

		local focusGUID = UnitGUID("focus")
		local focusToken = focusGUID and UnitTokenFromGUID(focusGUID) or nil

		if focusToken then
			modTable.focus.current = GetUnitFrameForToken(focusToken)
		end
	end

	local function OnPlayerFocusChange(owner)
		local guid = UnitGUID("focus")

		-- player has focus
		if guid then
			local token = UnitTokenFromGUID(guid)
			local frame = token and GetUnitFrameForToken(token) or nil

			local previousFrame = modTable.focus.current
			modTable.focus.current = frame

			-- cleanup previous frame
			if previousFrame and previousFrame ~= modTable.target.current then
				Plater.SetBorderColor(previousFrame)
			end

			-- dont override target border color
			if frame ~= modTable.target.current then
				Plater.SetBorderColor(frame, focusBorderColor)
			end

			return
		end

		if modTable.focus.current and modTable.focus.current ~= modTable.target.current then
			Plater.SetBorderColor(modTable.focus.current)
		end

		modTable.focus.current = nil
	end

	local function OnPlayerTargetChange(owner)
		local guid = UnitGUID("target")

		-- player has target
		if guid then
			local token = UnitTokenFromGUID(guid)
			local frame = token and GetUnitFrameForToken(token) or nil

			local previousFrame = modTable.target.current
			modTable.target.current = frame

			-- cleanup previous frame
			if previousFrame then
				Plater.SetBorderColor(
					previousFrame,
					previousFrame == modTable.focus.current and focusBorderColor or nil
				)
			end

			if frame then
				Plater.SetBorderColor(frame, targetBorderColor)
			else
				-- targeting something outside of nameplate range has plater not initialized yet, but it will be on the next frame
				C_Timer.After(0, function()
					OnPlayerTargetChange(owner)
				end)
			end

			return
		end

		if modTable.target.current then
			Plater.SetBorderColor(
				modTable.target.current,
				modTable.target.current == modTable.focus.current and focusBorderColor or nil
			)
		end

		modTable.target.current = nil
	end

	---@param frame Frame
	function modTable.EnsureCorrectBorder(token, frame)
		local guid = UnitGUID("focus")
		local focusToken = guid and UnitTokenFromGUID(guid) or nil

		if token == focusToken then
			Plater.SetBorderColor(frame, focusBorderColor)
			modTable.focus.current = frame
			return
		end

		guid = UnitGUID("target")
		local targetToken = guid and UnitTokenFromGUID(guid) or nil

		if token == targetToken then
			Plater.SetBorderColor(frame, targetBorderColor)
			modTable.target.current = frame
			return
		end

		Plater.SetBorderColor(frame)
	end

	modTable.target.id = EventRegistry:RegisterFrameEventAndCallback("PLAYER_TARGET_CHANGED", OnPlayerTargetChange)
	modTable.focus.id = EventRegistry:RegisterFrameEventAndCallback("PLAYER_FOCUS_CHANGED", OnPlayerFocusChange)
end
