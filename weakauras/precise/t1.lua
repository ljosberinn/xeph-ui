-- CLEU:SPELL_DAMAGE, CLEU:SPELL_PERIODIC_DAMAGE, XEPHUI_Precise_Damage, PLAYER_REGEN_DISABLED, CHALLENGE_MODE_START
-- CLEU:SPELL_HEAL, CLEU:SPELL_PERIODIC_HEAL, XEPHUI_Precise_Healing, PLAYER_REGEN_DISABLED, CHALLENGE_MODE_START

--- @class PreciseState
--- @field show boolean
--- @field changed boolean
--- @field value number
--- @field total number
--- @field autoHide false
--- @field name string
--- @field progressType "static"
--- @field perSecond number
--- @field icon number

--- @param states table<number, PreciseState>
--- @param event "COMBAT_LOG_EVENT_UNFILTERED" | "STATUS" | "OPTIONS" | "XEPHUI_Precise_Damage" | "XEPHUI_Precise_Healing" | "PLAYER_REGEN_DISABLED" | "CHALLENGE_MODE_START" | "UNIT_INFO_READY"
--- @return boolean
function f(states, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local subEvent = select(2, ...)
		local handler = aura_env.cleuMap[subEvent]

		if not handler then
			return false
		end

		local hasChanges = handler(...)

		if hasChanges then
			aura_env.queue()
		end

		return false
	end

	if event == "UNIT_INFO_READY" then
		return aura_env.onUnitUpdate(...)
	end

	if event == "PLAYER_REGEN_DISABLED" then
		if C_ChallengeMode.IsChallengeModeActive() then
			return false
		end

		for guid in pairs(states) do
			states[guid].show = false
			states[guid].changed = true
			states[guid].value = 0
		end

		aura_env.wipeCache()

		return true
	end

	if event == "CHALLENGE_MODE_START" then
		for guid in pairs(states) do
			states[guid].show = false
			states[guid].changed = true
			states[guid].value = 0
		end

		return true
	end

	if event == aura_env.customEventName then
		local id = ...

		if id ~= aura_env.id then
			return false
		end

		aura_env.nextFrame = nil

		local totalToCompareTo = 0

		for _, meta in pairs(aura_env.data) do
			if meta.total > totalToCompareTo then
				totalToCompareTo = meta.total
			end
		end

		local hasChanges = false

		for guid, meta in pairs(aura_env.data) do
			local diff = meta.lastUpdate - meta.start

			if diff == 0 then
				diff = 1
			end

			local perSecond = math.floor(meta.total / diff)

			if states[guid] == nil then
				states[guid] = {
					show = true,
					changed = true,
					progressType = "static",
					autoHide = false,
					icon = meta.icon,
					value = 0,
					total = totalToCompareTo,
					name = meta.name,
					class = meta.class,
					perSecond = perSecond,
				}
			end

			if states[guid].icon == 0 then
				states[guid].icon = meta.icon

				states[guid].show = true
				states[guid].changed = true
				hasChanges = true
			end

			if states[guid].value ~= meta.total then
				states[guid].value = meta.total

				states[guid].show = true
				states[guid].changed = true
				hasChanges = true
			end

			if states[guid].perSecond ~= perSecond then
				states[guid].perSecond = perSecond

				states[guid].show = true
				states[guid].changed = true
				hasChanges = true
			end

			states[guid].total = totalToCompareTo
		end

		return hasChanges
	end

	return false
end
