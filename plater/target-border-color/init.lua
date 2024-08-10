function f(modTable)
	local targetBorderColor = modTable.config.targetColor
	local focusBorderColor = modTable.config.focusColor
	-- local nonTargetBorderColor = "white"

	---@class Cache
	---@field current Frame|nil
	---@field id number|nil

	---@param token string
	local function GetUnitFrameForToken(token)
		local frame = C_NamePlate.GetNamePlateForUnit(token)

		--and frame.unitFrame.PlaterOnScreen
		if frame and frame.unitFrame then
			return frame.unitFrame
		end

		return nil
	end

	---@type Cache
	modTable.target = {
		current = GetUnitFrameForToken("target"),
	}

	---@type Cache
	modTable.focus = {
		current = GetUnitFrameForToken("focus"),
	}

	modTable.globalKey = "PlaterJundiesTargetBorderColor"

	if _G[modTable.globalKey] == nil then
		local frame = CreateFrame("Frame", modTable.globalKey)

		frame.unregistered = nil
		frame:RegisterEvent("PLAYER_TARGET_CHANGED")
		frame:RegisterEvent("PLAYER_FOCUS_CHANGED")

		local function OnPlayerFocusChange()
			-- player has focus
			if UnitExists("focus") then
				local frame = GetUnitFrameForToken("focus")

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
			else
				if modTable.focus.current and modTable.focus.current ~= modTable.target.current then
					Plater.SetBorderColor(modTable.focus.current)
				end

				modTable.focus.current = nil
			end
		end

		local function OnPlayerTargetChange()
			-- player has target
			if UnitExists("target") then
				local frame = GetUnitFrameForToken("target")

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
					C_Timer.After(0, OnPlayerTargetChange)
				end
			else
				if modTable.target.current then
					Plater.SetBorderColor(
						modTable.target.current,
						modTable.target.current == modTable.focus.current and focusBorderColor or nil
					)
				end

				modTable.target.current = nil
			end
		end

		frame:SetScript("OnEvent", function(self, event, ...)
			if event == "PLAYER_TARGET_CHANGED" then
				OnPlayerTargetChange()
			elseif event == "PLAYER_FOCUS_CHANGED" then
				OnPlayerFocusChange()
			end
		end)
	end

	---@param frame Frame
	function modTable.EnsureCorrectBorder(token, frame)
		if UnitExists("target") and UnitIsUnit(token, "target") then
			Plater.SetBorderColor(frame, targetBorderColor)
			modTable.target.current = frame
		elseif UnitExists("focus") and UnitIsUnit(token, "focus") then
			Plater.SetBorderColor(frame, focusBorderColor)
			modTable.focus.current = frame
		else
			Plater.SetBorderColor(frame)
		end
	end
end
