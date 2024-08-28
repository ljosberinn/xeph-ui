--- CLEU:SPELL_AURA_APPLIED:SPELL_EMPOWER_END:SPELL_AURA_REFRESH, UNIT_SPELLCAST_SUCCEEDED:player
---@param event "COMBAT_LOG_EVENT_UNFILTERED" | "OPTIONS" | "UNIT_SPELLCAST_SUCCEEDED"
function f(event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, subEvent, _, sourceGUID, _, _, _, targetGUID, _, _, _, spellId = ...

		if sourceGUID ~= WeakAuras.myGUID then
			return false
		end

		if subEvent == "SPELL_AURA_APPLIED" or subEvent == "SPELL_AURA_REFRESH" then
			if spellId ~= 395152 then
				return false
			end

			local token = UnitTokenFromGUID(targetGUID)

			if not token then
				return false
			end

			local auraInfo = C_UnitAuras.GetAuraDataBySpellName(token, aura_env.spellName)

			if not auraInfo or not auraInfo.points or not auraInfo.points[2] then
				return false
			end

			local effectiveInt = select(2, UnitStat("player", LE_UNIT_STAT_INTELLECT))
			local expectedBuff = math.floor(effectiveInt * 0.05)
			local grantedMainStat = auraInfo.points[2]
			local buffRatio = grantedMainStat / expectedBuff

			-- the ratio is usually very consistently 1.5001, but just in case
			aura_env.active = buffRatio >= 1.4

			return aura_env.active
		elseif subEvent == "SPELL_EMPOWER_END" and aura_env.active then
			return aura_env.isExtender(spellId)
		end

		return false
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" and aura_env.active then
		local spellId = select(3, ...)

		return aura_env.isExtender(spellId)
	end

	return false
end
