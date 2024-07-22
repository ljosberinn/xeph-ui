function f(states, event, ...)
	if event == "STATUS" then
		local maxStacks = IsPlayerSpell(374737) and 12 or 10
		local aura = C_UnitAuras.GetPlayerAuraBySpellID(195181)
		local currentStacks = aura and aura.applications or 0

		for i = 1, maxStacks do
			states[i] = {
				show = true,
				changed = true,
				value = i <= currentStacks and 1 or 0,
				total = 1,
				progressType = "static",
				maxStacks = maxStacks,
			}
		end

		return true
	end

	if event == "UNIT_AURA" then
		local aura = C_UnitAuras.GetPlayerAuraBySpellID(195181)
		local hasChanges = false

		if aura == nil then
			for i = 1, states[1].maxStacks do
				local state = states[i]

				if state.value == 1 then
					state.value = 0
					state.changed = true
					hasChanges = true
				end
			end

			return hasChanges
		end

		local stacks = aura.applications or 0

		for i = 1, states[1].maxStacks do
			local state = states[i]

			if i > stacks then
				if state.value == 1 then
					state.value = 0
					state.changed = true
					hasChanges = true
				end
			elseif i < stacks then
				if state.value == 0 then
					state.value = 1
					state.changed = true
					hasChanges = true
				end
			elseif state.value ~= 1 then
				state.value = 1
				state.changed = true
				hasChanges = true
			end
		end

		return hasChanges
	end

	return false
end
