-- UNIT_POWER_FREQUENT:player, UNIT_MAXPOWER:player, UNIT_SPECIALIZATION_CHANGED:player

--- @type table<number, EssenceState2> states
--- @type string event "UNIT_POWER_FREQUENT" | "UNIT_MAXPOWER" | "UNIT_SPECIALIZATION_CHANGED"
--- @return boolean
function f(states, event, ...)
	if event == "UNIT_POWER_FREQUENT" or event == "UNIT_MAXPOWER" or event == "UNIT_SPECIALIZATION_CHANGED" then
		local unit, powerType = ...

		if event ~= "UNIT_SPECIALIZATION_CHANGED" and (unit ~= "player" or powerType ~= "ESSENCE") then
			return false
		end

		local essences = aura_env.getEssences()
		local maxEssences = aura_env.getMaxEssences()

		if essences == aura_env.currentEssences and maxEssences == aura_env.maxEssences then
			return false
		end

		local changed = false

		for essence = 1, 6 do
			if essence > maxEssences then
				if states[essence] then
					states[essence].show = false
					states[essence].changed = true

					changed = true
				end
			else
				states[essence] = states[essence] or {
					progressType = "timed",
					index = essence,
				}
				local state = states[essence]

				if essence == essences + 1 then
					local lastRemaining = 0
					local now = GetTime()

					if essence < aura_env.currentEssences then
						local lastState = states[aura_env.currentEssences + 1]
						if lastState and lastState.progressType == "timed" then
							local remaining = lastState.duration - ((lastState.expirationTime or 0) - now)

							if remaining > 0 then
								lastRemaining = remaining
							end
						end
					end

					local peace = aura_env.getEssenceRegenerationSpeed()

					local updated = aura_env.updateState(state, {
						duration = peace,
						expirationTime = (peace - lastRemaining) + now,
						show = true,
						progressType = "timed",
					})

					changed = changed or updated
				elseif essence <= essences then
					local updated = aura_env.updateState(state, {
						value = 1,
						total = 1,
						progressType = "static",
						show = true,
					})

					changed = changed or updated
				else
					local updated = aura_env.updateState(state, {
						value = 0,
						total = 1,
						progressType = "static",
						show = true,
					})

					changed = changed or updated
				end
			end
		end

		aura_env.currentEssences = essences
		aura_env.maxEssences = maxEssences

		return changed
	end

	return false
end
