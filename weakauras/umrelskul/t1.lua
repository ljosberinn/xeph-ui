-- CLEU:SPELL_AURA_APPLIED:SPELL_INSTAKILL, UNIT_HEALTH
---@param event "COMBAT_LOG_EVENT_UNFILTERED" | "UNIT_HEALTH"
function f(event, ...)
	-- whenever an afflicted target takes damage, update health.
	-- this is the costly part of the aura as we have to track how much
	-- health a unit had last before dying as the execute doesnt happen at
	-- precisely 5% but when the dot ticks the next time _below_ 5%
	if event == "UNIT_HEALTH" then
		local unit = ...
		local guid = UnitGUID(unit)

		if not guid or aura_env.debuffedEnemies[guid] == nil then
			return false
		end

		aura_env.debuffedEnemies[guid] = UnitHealth(unit)

		return false
	end

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local subEvent = select(2, ...)

		-- on aura application, store an entry of unit token <-> current health
		if subEvent == "SPELL_AURA_APPLIED" then
			local _, _, _, _, _, _, _, targetGUID, _, _, _, spellId = ...

			-- ignore diff debuffs & enemies that are already tracked
			if spellId ~= aura_env.debuffId or aura_env.debuffedEnemies[targetGUID] ~= nil then
				return false
			end

			local token = UnitTokenFromGUID(targetGUID)

			if not token then
				return false
			end

			aura_env.debuffedEnemies[targetGUID] = UnitHealth(token)

			return false
		end

		-- actual execute handling
		if subEvent == "SPELL_INSTAKILL" then
			local timestamp, _, _, sourceGUID, sourceName, sourceFlags, _, targetGUID, targetName, targetFlags, targetRaidFlags, spellId, spellName, spellType =
				...

			if spellId ~= aura_env.executeId or aura_env.debuffedEnemies[targetGUID] == nil then
				return false
			end

			local executeValue = aura_env.debuffedEnemies[targetGUID]

			if not executeValue then
				return false
			end

			aura_env.maybeAddToDetails(
				timestamp,
				sourceGUID,
				sourceName,
				sourceFlags,
				targetGUID,
				targetName,
				targetFlags,
				targetRaidFlags,
				spellId,
				spellName,
				spellType,
				executeValue
			)

			if sourceGUID ~= WeakAuras.myGUID then
				return false
			end

			aura_env.progress.total = aura_env.progress.total + executeValue
			aura_env.progress.unitCount = aura_env.progress.unitCount + 1
			aura_env.debuffedEnemies[targetGUID] = nil

			local token = UnitTokenFromGUID(targetGUID)

			if not token then
				return false
			end

			aura_env.sendMessage(
				format("%s executed %s for %s.", aura_env.trinketLink, UnitName(token), AbbreviateNumbers(executeValue))
			)
		end
	end

	if event == "PLAYER_REGEN_ENABLED" and not UnitIsDead("player") then
		table.wipe(aura_env.debuffedEnemies)

		return false
	end

	return false
end
