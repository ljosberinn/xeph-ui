--- @class EclipseState
--- @field show boolean
--- @field changed boolean
--- @field value number
--- @field duration number | nil
--- @field expirationTime number | nil
--- @field autoHide true
--- @field progressType "static" | "timed"

--- @param states table<number, EclipseState>
--- @param event "OPTIONS" | "STATUS" | "COMBAT_LOG_EVENT_UNFILTERED" | "UNIT_SPELLCAST_SUCCEEDED"
--- @return boolean
function (states, event, ...)
	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		if not states[""] then
			return false
		end

		-- this auras buff is in progress
		if states[""].progressType == "timed" and states[""].expirationTime > GetTime() then
			return false
		end

		-- other buff is in progress
		if states[""].progressType == "static" and states[""].total == 0 then
			return false
		end

		local _, _, spellId = ...

		if spellId ~= aura_env.config.castId then
			return false
		end

		-- increment
		if states[""].progressType == "static" and states[""].value == 1 then
			states[""].value = 2
			states[""].changed = true
			return true
		end

		-- depending on which comes first, spell cast succeeded or losing the buff,
		-- flip to the other state
		states[""] = {
			progressType = "static",
			value = 1,
			total = 2,
			changed = true,
			show = true,
		}

		return true
	end

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local subEvent = select(2, ...)

		if subEvent == "SPELL_AURA_APPLIED" then
			local _, _, _, sourceGUID, _, _, _, targetGUID, _, _, _, spellId = ...

			if sourceGUID ~= WeakAuras.myGUID then
				return false
			end

			if sourceGUID ~= targetGUID then
				return false
			end

			local isIncarn = aura_env.isIncarn(spellId)

			if not isIncarn and not aura_env.isEclipse(spellId) then
				return false
			end

			if isIncarn then
				states[""] = {
					progressType = "timed",
					duration = 30,
					expirationTime = GetTime() + 30,
					show = true,
					changed = true,
					spellId = spellId,
				}

				return true
			end

			-- dont reset for applybuffs of other eclipse during incarn as their
			-- applybuff is after incarn
			if aura_env.isStillInIncarn(states) then
				return false
			end

			if spellId == aura_env.config.buffId then
				states[""] = {
					progressType = "timed",
					duration = 15,
					expirationTime = GetTime() + 15,
					show = true,
					changed = true,
					spellId = spellId,
				}

				return true
			end

			states[""] = {
				progressType = "static",
				total = 0,
				value = 0,
				show = true,
				changed = true,
			}

			return true
		end

		if subEvent == "SPELL_AURA_REMOVED" then
			local _, _, _, sourceGUID, _, _, _, targetGUID, _, _, _, spellId = ...

			if sourceGUID ~= WeakAuras.myGUID then
				return false
			end

			if sourceGUID ~= targetGUID then
				return false
			end

			if not aura_env.isEclipse(spellId) then
				return false
			end

			states[""] = {
				progressType = "static",
				autoHide = false,
				value = 0,
				total = 2,
				show = true,
				changed = true,
			}

			return true
		end

		return false
	end

	if not states[""] then
		states[""] = {
			progressType = "static",
			autoHide = false,
			value = 0,
			total = 2,
			show = true,
			changed = true,
		}

		return true
	end

	return false
end
