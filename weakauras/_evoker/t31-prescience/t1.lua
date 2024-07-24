-- CLEU:SPELL_AURA_APPLIED, CLEU:SPELL_AURA_REFRESH, PLAYER_DEAD, XEPHUI_PRESCIENCE_T31, TRIGGER:3, TRIGGER:4
--- @class T31_PrescienceState
--- @field show boolean
--- @field changed boolean
--- @field stacks number
--- @field autoHide boolean
--- @field progressType "static"

--- @param states table<"", T31_PrescienceState>
--- @param event "OPTIONS" | "STATUS" | "COMBAT_LOG_EVENT_UNFILTERED" | "PLAYER_DEAD" | "XEPHUI_PRESCIENCE_T31" | "TRIGGER"
--- @return boolean
function f(states, event, ...)
	if event == "TRIGGER" then
		aura_env.active = aura_env.checkGear()
	end

	if not aura_env.active then
		aura_env.reset(states)

		return false
	end

	if event == "PLAYER_DEAD" then
		aura_env.reset(states)

		return true
	end

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, _, _, sourceGUID, _, _, _, targetGUID, _, _, _, spellId = ...

		if spellId ~= 410089 or sourceGUID ~= WeakAuras.myGUID or string.find(targetGUID, "Pet") ~= nil then
			return false
		end

		local unit = UnitTokenFromGUID(targetGUID)

		if not unit then
			return false
		end

		local duration = 0

		AuraUtil.ForEachAura(unit, "HELPFUL", nil, function(...)
			local _, _, _, _, dur, _, source, _, _, auraSpellId = ...

			if auraSpellId == 410089 and source == "player" then
				duration = dur
				return true
			end

			return false
		end)

		if duration == 0 then
			aura_env.queue(unit, 1)
			return false
		end

		aura_env.performUpdate(states, duration)

		return true
	end

	if event == aura_env.customEventName then
		local id, unit, count = ...

		if id ~= aura_env.id then
			return false
		end

		local duration = 0

		AuraUtil.ForEachAura(unit, "HELPFUL", nil, function(...)
			local _, _, _, _, dur, _, source, _, _, auraSpellId = ...

			if auraSpellId == 410089 and source == "player" then
				duration = dur
				return true
			end

			return false
		end)

		if duration == 0 then
			aura_env.queue(unit, count + 1)
			return false
		end

		aura_env.performUpdate(states, duration)

		return true
	end

	return false
end
