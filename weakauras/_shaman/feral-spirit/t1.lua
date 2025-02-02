--- CLEU:SPELL_SUMMON, PLAYER_DEAD, XEPHUI_FERAL_SPIRITS
function f(states, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, subEvent, _, sourceGUID, _, _, _, _, _, _, _, spellId = ...

		if subEvent ~= "SPELL_SUMMON" or sourceGUID ~= WeakAuras.myGUID then
			return false
		end

		local duration = 0
		if spellId == 426516 then
			duration = 15
		elseif spellId == 469330 or spellId == 469322 or spellId == 469332 or spellId == 469328 then
			duration = 8
		end

		if duration == 0 then
			return false
		end

		local expiresFirst = true
		local now = GetTime()
		local expirationTime = now + duration

		for _, state in pairs(states) do
			if state.expirationTime > now and state.expirationTime < expirationTime then
				expiresFirst = false
				break
			end
		end

		local key = #states + 1

		states[key] = {
			changed = true,
			show = true,
			spellId = spellId,
			autoHide = true,
			expirationTime = expirationTime,
			duration = duration,
			progressType = "timed",
			expiresFirst = expiresFirst,
		}

		if expiresFirst then
			local id = aura_env.id

			aura_env.timer = C_Timer.After(8, function()
				WeakAuras.ScanEvents("XEPHUI_FERAL_SPIRITS", id, now + 8)
			end)

			for otherKey, state in pairs(states) do
				if otherKey ~= key and state.expiresFirst then
					state.changed = true
					state.expiresFirst = false
				end
			end
		end

		return true
	end

	if event == "PLAYER_DEAD" then
		local hasChanges = false

		for _, state in pairs(states) do
			if state.expirationTime > GetTime() then
				state.changed = true
				state.show = false
				hasChanges = true
			end
		end

		if aura_env.timer ~= nil and not aura_env.timer:IsCancelled() then
			aura_env.timer:Cancel()
		end

		return hasChanges
	end

	if event == "XEPHUI_FERAL_SPIRITS" then
		local id, now = ...

		if id ~= aura_env.id then
			return false
		end

		local lowestExpirationKey = nil

		for key, state in pairs(states) do
			if
				state.expirationTime > now
				and (lowestExpirationKey == nil or state.expirationTime < states[lowestExpirationKey].expirationTime)
			then
				lowestExpirationKey = key
			end
		end

		if lowestExpirationKey == nil then
			return false
		end

		local nextExpiration = states[lowestExpirationKey].expirationTime - now

		aura_env.timer = C_Timer.After(nextExpiration, function()
			WeakAuras.ScanEvents("XEPHUI_FERAL_SPIRITS", id, now + nextExpiration)
		end)

		local hasChanges = false

		for key, state in pairs(states) do
			if key == lowestExpirationKey then
				if not state.expiresFirst then
					state.changed = true
					state.expiresFirst = true
					hasChanges = true
				end
			elseif state.expiresFirst then
				state.expiresFirst = false
				state.changed = true
				hasChanges = true
			end
		end

		return hasChanges
	end

	return false
end
