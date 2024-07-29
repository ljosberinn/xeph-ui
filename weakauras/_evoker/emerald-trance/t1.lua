--- @class EmeraldTranceState
--- @field show boolean
--- @field changed boolean
--- @field value number
--- @field duration number | nil
--- @field expirationTime number | nil
--- @field autoHide true
--- @field progressType "static"

--- @param states table<number, EmeraldTranceState>
--- @param event "OPTIONS" | "STATUS" | "COMBAT_LOG_EVENT_UNFILTERED" | "XEPHUI_EMERALD_TRANCE" | "TRIGGER"
--- @return boolean
function f(states, event, ...)
	if event == "TRIGGER" then
		local updatedTriggerStates = select(2, ...)

		if updatedTriggerStates then
			for _, state in pairs(updatedTriggerStates) do
				aura_env.active = state.equipped >= 4
			end
		end
	end

	if not aura_env.active then
		return false
	end

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, subEvent, _, sourceGUID, _, _, _, _, _, _, _, spellId = ...

		if sourceGUID ~= WeakAuras.myGUID or spellId ~= aura_env.emeraldTranceBuffId then
			return false
		end

		if subEvent == "SPELL_AURA_APPLIED" then
			local duration = select(5, WA_GetUnitBuff("player", aura_env.emeraldTranceBuffId)) or 0

			if duration == nil or duration == 0 then
				return false
			end

			states[""] = {
				show = true,
				changed = true,
				progressType = "timed",
				autoHide = true,
				expirationTime = GetTime() + duration,
				duration = duration,
				stacks = math.floor(duration / 5),
			}

			aura_env.queue()

			return true
		end

		if subEvent == "SPELL_AURA_REMOVED" and states[""] then
			states[""].show = false
			states[""].changed = true

			return true
		end

		return false
	end

	if event == aura_env.customEventName then
		local id = ...

		aura_env.timer = nil

		if id ~= aura_env.id or not states[""] then
			return false
		end

		if states[""].stacks >= 1 then
			states[""].stacks = states[""].stacks - 1
			states[""].changed = true

			aura_env.queue()
		end

		return true
	end

	return false
end
