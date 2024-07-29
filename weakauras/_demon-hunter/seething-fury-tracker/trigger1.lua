-- UNIT_SPELLCAST_SUCCEEDED:player, CLEU:SPELL_AURA_REFRESH, CLEU:SPELL_AURA_APPLIED, CLEU:SPELL_AURA_REMOVED
--- @param event "UNIT_SPELLCAST_SUCCEEDED" | "COMBAT_LOG_EVENT_UNFILTERED" | "PLAYER_DEAD"
--- @return boolean
function f(event, ...)
	if event == "PLAYER_DEAD" then
		aura_env.furySpent = 0

		return true
	end

	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		local unit, _, spellId = ...

		if unit ~= "player" or not aura_env.abilities[spellId] then
			return true
		end

		local cost = aura_env.abilities[spellId].determineCost()

		if cost and cost > 0 then
			aura_env.furySpent = aura_env.furySpent + cost
		end

		return true
	end

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, subEvent, _, sourceGUID, _, _, _, _, _, _, _, spellId, _, _, type = ...

		if type ~= "BUFF" or sourceGUID ~= WeakAuras.myGUID or spellId ~= aura_env.seethingFuryBuffId then
			return true
		end

		if subEvent == "SPELL_AURA_APPLIED" or subEvent == "SPELL_AURA_REFRESH" then
			aura_env.seethingFuryActive = true

			local remainder = aura_env.furySpent - aura_env.threshold

			if remainder <= 0 then
				aura_env.furySpent = 0
			else
				aura_env.furySpent = remainder
			end
		else
			aura_env.seethingFuryActive = false
		end
	end

	return true
end
