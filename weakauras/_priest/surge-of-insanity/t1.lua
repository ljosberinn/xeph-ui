--UNIT_SPELLCAST_SUCCEEDED:player PLAYER_DEAD, TRIGGER:2

---@param event "STATUS" | "TRIGGER" | "PLAYER_DEAD" | "UNIT_SPELLCAST_SUCCEEDED"
---@return boolean
function f(states, event, ...)
	if event == "STATUS" then
		states[""] = {
			show = false,
			changed = true,
			value = 2,
			total = 2,
			progressType = "static",
			icon = 425954,
		}

		return true
	end

	if event == "TRIGGER" then
		local updatedTriggerStates = select(2, ...)

		if states[""].value == 2 then
			return false
		end

		local changed = false

		if updatedTriggerStates then
			for _, state in pairs(updatedTriggerStates) do
				for k, v in pairs(state) do
					print(k, v)
				end
			end
		end

		return changed
	end

	if event == "PLAYER_DEAD" then
		states[""].changed = states[""].value ~= 2
		states[""].value = 2

		return states[""].changed
	end

	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		local spellId = select(3, ...)

		-- casting Devouring Plague
		if spellId == 335467 then
			if states[""].value > 1 then
				states[""].value = states[""].value - 1
			else
				states[""].value = 2
			end

			states[""].changed = true
			states[""].show = states[""].value ~= 2

			return true
		end

		return false
	end

	return false
end
