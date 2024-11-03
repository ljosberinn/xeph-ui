-- UNIT_SPELLCAST_SUCCEEDED, CLEU:SPELL_AURA_APPLIED:SPELL_AURA_REFRESH:SPELL_AURA_REMOVED:UNIT_DIED, XEPHUI_CD_CHECK
---@class GroupCDsState
---@field show boolean
---@field changed boolean
---@field duration number
---@field expirationTime number
---@field autoHide boolean
---@field progressType "timed"
---@field icon number
---@field unit string

---@param states table<number, GroupCDsState>
---@param event "STATUS" | "OPTIONS" | "UNIT_SPELLCAST_SUCCEEDED" | "COMBAT_LOG_EVENT_UNFILTERED" | "XEPHUI_CD_CHECK"
---@return boolean
function f(states, event, ...)
	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		local unit, castGUID, spellId = ...

		if unit == "player" or not UnitInParty(unit) then
			return false
		end

		local duration = aura_env.trackedCasts[spellId]

		if not duration or not unit or not UnitIsFriend("player", unit) then
			return false
		end

		local name, icon = aura_env.getSpellInfo(spellId)

		aura_env.maybeTextToSpeech(name, duration)

		states[castGUID] = {
			show = true,
			changed = true,
			duration = duration,
			expirationTime = GetTime() + duration,
			autoHide = true,
			progressType = "timed",
			icon = icon,
			unit = unit,
			spellId = spellId,
		}

		return true
	end

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, subEvent, _, sourceGUID, _, _, _, targetGUID, _, _, _, spellId = ...

		-- players dying during summons would incorrectly linger upon death
		-- as there's no buff removal present to be tracked
		if subEvent == "UNIT_DIED" then
			local unit = UnitTokenFromGUID(targetGUID)

			if not unit or not UnitIsFriend("player", unit) then
				return false
			end

			local hasChanges = false

			for _, state in pairs(states) do
				if state.show and state.unit == unit then
					state.show = false
					state.changed = true
					hasChanges = true
				end
			end

			return hasChanges
		end

		if not aura_env.trackedBuffs[spellId] then
			return false
		end

		local guidToUse, unit = aura_env.getBuffedPlayerGuid(spellId, sourceGUID, targetGUID)

		if not guidToUse or not unit or guidToUse == WeakAuras.myGUID or not UnitInParty(unit) then
			return false
		end

		local duration, expirationTime, icon, name = aura_env.getAuraMeta(unit, spellId)

		if duration == 0 or expirationTime == 0 or icon == 0 then
			return false
		end

		local key = aura_env.createKey(guidToUse, spellId)

		if subEvent == "SPELL_AURA_APPLIED" then
			aura_env.maybeTextToSpeech(name, duration)

			states[key] = {
				show = true,
				changed = true,
				duration = duration,
				expirationTime = expirationTime,
				autoHide = true,
				progressType = "timed",
				icon = icon,
				unit = unit,
				spellId = spellId,
			}

			-- has no duration, nothing to poll
			if spellId ~= aura_env.breathOfSindragosaBuffId then
				aura_env.enqueuePoll(unit, guidToUse, spellId, key)
			end

			return true
		elseif subEvent == "SPELL_AURA_REFRESH" then
			if not states[key] then
				return false
			end

			local changed = states[key].duration ~= duration or states[key].expirationTime ~= duration

			if not changed then
				return false
			end

			states[key].changed = true
			states[key].duration = duration
			states[key].expirationTime = expirationTime

			aura_env.enqueuePoll(unit, guidToUse, spellId, key)

			return true
		elseif subEvent == "SPELL_AURA_REMOVED" then
			if not states[key] then
				return false
			end

			states[key].show = false
			states[key].changed = true

			aura_env.clearTickerFor(key)

			return true
		end

		return false
	end

	if event == aura_env.customEventName then
		local id, unit, guid, spellId = ...

		if id ~= aura_env.id then
			return false
		end

		local key = aura_env.createKey(guid, spellId)

		if not states[key] then
			return false
		end

		if UnitIsDead(unit) then
			-- might already be hidden via SPELL_AURA_REMOVED
			if states[key].show == false then
				return false
			end

			states[key].show = false
			states[key].changed = true

			aura_env.clearTickerFor(key)

			return true
		end

		local duration, expirationTime, icon = aura_env.getAuraMeta(unit, spellId)

		if duration == 0 or expirationTime == 0 or icon == 0 then
			return false
		end

		local changed = states[key].duration ~= duration or states[key].expirationTime ~= duration

		if not changed then
			return false
		end

		states[key].changed = true
		states[key].duration = duration
		states[key].expirationTime = expirationTime

		return true
	end

	return false
end
