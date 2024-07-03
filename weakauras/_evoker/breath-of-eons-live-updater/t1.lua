-- CLEU:SPELL_DAMAGE, XEPHUI_BREATH_OF_EONS_ESTIMATION, UNIT_SPELLCAST_SUCCEEDED:player, CLEU:SPELL_AURA_APPLIED
--- @class BreathOfEonsHighlighterEstimation
--- @field show boolean
--- @field changed boolean
--- @field stacks number
--- @field duration number
--- @field expirationTime number
--- @field autoHide boolean
--- @field progressType "timed"
--- @field icon number

--- @param states table<number, BreathOfEonsHighlighterEstimation>
--- @param event "STATUS" | "OPTIONS" | "COMBAT_LOG_EVENT_UNFILTERED" | "XEPHUI_BREATH_OF_EONS" | "UNIT_SPELLCAST_SUCCEEDED"
--- @return boolean
function (states, event, ...)
	if not states[""] then
		states[""] = {
			stacks = 0,
			show = false,
			changed = true,
			progressType = "timed",
			icon = 5199622,
			duration = 5,
			expirationTime = 0,
			autoHide = true,
		}

		return false
	end

	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		if aura_env.total == 0 then
			return false
		end

		local now = GetTime()

		if now - aura_env.lastUpdate < 5 then
			return false
		end

		aura_env.total = 0
		aura_env.targets = {}
		states[""].stacks = 0
		states[""].expirationTime = now
		states[""].changed = true
		states[""].show = false

		return true
	end

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local subEvent = select(2, ...)

		if subEvent == "SPELL_DAMAGE" then
			local _, _, _, sourceGUID, _, _, _, targetGUID, _, _, _, spellId, _, _, amount, _, _, _, _, absorbed = ...

			if not aura_env.isAugvoker and sourceGUID ~= WeakAuras.myGUID then
				return false
			end

			if spellId == 409632 then -- Temporal Wounds detonation
				aura_env.estimated = 0

				aura_env.total = aura_env.total + amount + (absorbed or 0)
				aura_env.lastUpdate = GetTime()
				aura_env.queue()

				return false
			end

			if aura_env.targets[targetGUID] == nil or aura_env.total > 0 then
				return false
			end

			local factor = IsInRaid() and 0.1 or 0.12
			local total = (amount + (absorbed or 0)) * factor

			aura_env.estimated = aura_env.estimated + total
			aura_env.lastUpdate = GetTime()
			aura_env.queue()

			return false
		elseif subEvent == "SPELL_AURA_APPLIED" then
			local _, _, _, sourceGUID, _, _, _, targetGUID, _, _, _, spellId, _, _, type = ...

			if type ~= "DEBUFF" then
				return false
			end

			local isMyPersonalAccumulator = spellId == 409722
			local isMyBreathDebuff = spellId == 409560 and sourceGUID == WeakAuras.myGUID

			if isMyPersonalAccumulator or isMyBreathDebuff then
				aura_env.targets[targetGUID] = true
			end

			return false
		end

		return false
	end

	if event ~= aura_env.customEventName then
		return false
	end

	local id = ...

	if id ~= aura_env.id then
		return false
	end

	aura_env.nextFrame = nil

	states[""].stacks = aura_env.total
	states[""].estimated = aura_env.total > 0 and 0 or aura_env.estimated
	states[""].changed = true
	states[""].show = true
	states[""].expirationTime = GetTime() + 5
	states[""].duration = 5

	return true
end
