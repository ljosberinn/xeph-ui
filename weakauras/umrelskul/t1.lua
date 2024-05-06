-- CLEU:SPELL_AURA_APPLIED:SPELL_INSTAKILL, UNIT_HEALTH, CHALLENGE_MODE_START, CHALLENGE_MODE_COMPLETED, ENCOUNTER_START, ENCOUNTER_END
---@param event "COMBAT_LOG_EVENT_UNFILTERED" | "UNIT_HEALTH" | "CHALLENGE_MODE_START" | "CHALLENGE_MODE_COMPLETED" | "ENCOUNTER_START" | "ENCOUNTER_END"
function f(event, ...)
	-- whenever an afflicted target takes damage, update health.
	-- this is the costly part of the aura as we have to track how much
	-- health a unit had last before dying as the execute doesnt happen at
	-- precisely 5% but when the dot ticks the next time _below_ 5%
	if event == "UNIT_HEALTH" then
		local unit = ...

		if aura_env.debuffedEnemies[unit] == nil then
			return false
		end

		aura_env.debuffedEnemies[unit] = UnitHealth(unit)

		return false
	end

	if event == "CHALLENGE_MODE_START" then
		aura_env.progress.total = 0
		aura_env.progress.unitCount = 0

		return false
	end

	if event == "CHALLENGE_MODE_COMPLETED" then
		aura_env.onFinishMessage()

		return false
	end

	if event == "ENCOUNTER_START" then
		if C_ChallengeMode.IsChallengeModeActive() then
			return false
		end

		aura_env.progress.total = 0
		aura_env.progress.unitCount = 0

		return false
	end

	if event == "ENCOUNTER_END" then
		if C_ChallengeMode.IsChallengeModeActive() then
			return false
		end

		aura_env.onFinishMessage()

		return false
	end

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local subEvent = select(2, ...)

		-- on aura application, store an entry of unit token <-> current health
		if subEvent == "SPELL_AURA_APPLIED" then
			local _, _, _, _, _, _, _, targetGUID, _, _, _, spellId = ...

			if spellId ~= aura_env.debuffId then
				return false
			end

			local token = UnitTokenFromGUID(targetGUID)

			if not token or aura_env.debuffedEnemies[token] ~= nil then
				return false
			end

			aura_env.debuffedEnemies[token] = UnitHealth(token)

			return false
		end

		-- actual execute handling
		if subEvent == "SPELL_INSTAKILL" then
			local timestamp, _, _, sourceGUID, sourceName, sourceFlags, _, targetGUID, targetName, targetFlags, targetRaidFlags, spellId, spellName, spellType =
				...

			if spellId ~= aura_env.executeId then
				return false
			end

			local token = UnitTokenFromGUID(targetGUID)

			if not token or aura_env.debuffedEnemies[token] == nil then
				return false
			end

			local executeValue = aura_env.debuffedEnemies[token]

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
			aura_env.debuffedEnemies[token] = nil

			aura_env.sendMessage(
				format("%s executed %s for %s.", aura_env.trinketLink, UnitName(token), AbbreviateNumbers(executeValue))
			)
		end
	end

	if event == "PLAYER_REGEN_ENABLED" then
		table.wipe(aura_env.debuffedEnemies)

		return false
	end

	return false
end
