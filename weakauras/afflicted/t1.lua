-- CLEU:SPELL_CAST_START, CLEU:SPELL_DISPEL, CLEU:SPELL_STOLEN, UNIT_SPELLCAST_STOP, UNIT_SPELLCAST_FAILED_QUIET
--- @class AfflictedState
--- @field show boolean
--- @field changed boolean
--- @field autoHide boolean
--- @field progressType "static"
--- @field units number
--- @field duration number
--- @field icon number
--- @param states table<number, AfflictedState>
--- @param event "COMBAT_LOG_EVENT_UNFILTERED" | "STATUS" | "OPTIONS" | "UNIT_SPELLCAST_FAILED_QUIET" | "UNIT_SPELLCAST_STOP"
function f(states, event, ...)
	if event == "STATUS" or event == "OPTIONS" then
		return false
	end

	if not states[""] then
		states[""] = {
			show = false,
			changed = true,
			autoHide = true,
			progressType = "timed",
			duration = 10,
			icon = 237555,
			units = 0,
			guids = {},
		}
	end

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local subEvent = select(2, ...)

		if subEvent == "SPELL_CAST_START" then
			local sourceGUID = select(4, ...)
			local spellId = select(12, ...)

			if spellId ~= aura_env.afflictedCry or states[""].guids[sourceGUID] then
				return false
			end

			states[""].units = states[""].units + 1
			states[""].expirationTime = GetTime() + 10
			states[""].changed = true
			states[""].show = true
			states[""].guids[sourceGUID] = true

			return true
		end

		if subEvent == "SPELL_DISPEL" or subEvent == "SPELL_STOLEN" then
			local targetGUID = select(8, ...)
			local spellId = select(15, ...)

			if aura_env.debuffs[spellId] ~= true or states[""].guids[targetGUID] == nil then
				return false
			end

			states[""].units = states[""].units - 1
			states[""].changed = true
			states[""].show = states[""].units > 0
			states[""].guids[targetGUID] = nil

			return true
		end

		return false
	end

	if event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_FAILED_QUIET" then
		local unit, _, spellId = ...

		if not unit then
			return false
		end

		local guid = UnitGUID(unit)

		if spellId ~= aura_env.afflictedCry or not guid or states[""].guids[guid] == nil then
			return false
		end

		states[""].units = states[""].units - 1
		states[""].changed = true
		states[""].show = states[""].units > 0
		states[""].guids[guid] = nil

		return true
	end

	return false
end
