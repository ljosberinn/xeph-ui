--- CLEU:SPELL_AURA_APPLIED:SPELL_AURA_REFRESH, UNIT_SPELLCAST_SUCCEEDED:player
function f(event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, _, _, sourceGUID, _, _, _, _, _, _, _, spellId = ...

		if sourceGUID == WeakAuras.myGUID and spellId == aura_env.shatteringStarId then
			local diff = GetTime() - aura_env.lastCast

			-- around 0.65s is travel time for 25y
			return diff >= 0.7
		end
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
		local unit, _, spellId = ...

		if unit == "player" and spellId == aura_env.shatteringStarId then
			aura_env.lastCast = GetTime()
		end
	end

	return false
end
