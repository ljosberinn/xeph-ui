--- GROUP_ROSTER_UPDATE, GROUP_LEFT, GROUP_JOINED, CLEU:SPELL_AURA_APPLIED:SPELL_EMPOWER_END, UNIT_SPELLCAST_SUCCEEDED:player
---@param event "GROUP_ROSTER_UPDATE" | "GROUP_LEFT" | "GROUP_JOINED" | "COMBAT_LOG_EVENT_UNFILTERED" | "OPTIONS" | "UNIT_SPELLCAST_SUCCEEDED"
function f(event, ...)
	if event == "GROUP_ROSTER_UPDATE" or event == "GROUP_LEFT" or event == "GROUP_JOINED" or event == "OPTIONS" then
		aura_env.groupType = aura_env.determineGroupType()

		return false
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		if aura_env.groupType == "none" then
			return false
		end

		local _, subEvent, _, sourceGUID, _, _, _, targetGUID, _, _, _, spellId = ...

		if sourceGUID ~= WeakAuras.myGUID then
			return false
		end

		if subEvent == "SPELL_AURA_APPLIED" then
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

			-- account for Close as Clutchmates
			local multiplier = aura_env.groupType == "raid" and 0.065 or 0.065 * 1.1

			local effectiveInt = select(2, UnitStat("player", LE_UNIT_STAT_INTELLECT))
			local expectedBuff = math.floor(effectiveInt * multiplier)
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
