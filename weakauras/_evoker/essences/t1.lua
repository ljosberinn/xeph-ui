---UNIT_POWER_FREQUENT:player, UNIT_MAXPOWER:player, PLAYER_SPECIALIZATION_CHANGED:player

---@param states table<number, EssenceStateXephUI>
---@param event "UNIT_POWER_FREQUENT" | "UNIT_MAXPOWER" | "PLAYER_SPECIALIZATION_CHANGED"
---@return boolean
function f(states, event, unit, powerType)
	if powerType and powerType ~= "ESSENCE" then
		return false
	end

	local current = UnitPower("player", Enum.PowerType.Essence)
	local maxPower = UnitPowerMax("player", Enum.PowerType.Essence)

	if
		event ~= "PLAYER_SPECIALIZATION_CHANGED"
		and unit
		and powerType
		and current == aura_env.lastPower
		and maxPower == aura_env.lastMaxPower
	then
		return false
	end

	local hasChanges = false

	for i = 1, 6 do
		if i > maxPower then
			if states[i] then
				local state = states[i]

				if state.show then
					state.show = false
					state.changed = true
					hasChanges = true
				end
			end
		else
			states[i] = states[i] or {
				progressType = "timed",
				index = i,
			}
			local state = states[i]

			state.power = current

			local partial = nil

			if i == current + 1 then
				local baseRechargeRate = GetPowerRegenForPowerType(Enum.PowerType.Essence)
				if baseRechargeRate == nil or baseRechargeRate == 0 then
					baseRechargeRate = 0.2
				end
				local essenceRechargeRate = 1 / baseRechargeRate
				local now = GetTime()
				local remaining = 0

				if aura_env.lastPower and i < aura_env.lastPower then
					local lastState = states[aura_env.lastPower + 1]

					if lastState and lastState.progressType == "timed" then
						local maybeRemaining = lastState.duration - ((lastState.expirationTime or 0) - now)
						if maybeRemaining > 0 then
							remaining = maybeRemaining
						end
					end
				end

				partial = {
					duration = essenceRechargeRate,
					expirationTime = (essenceRechargeRate - remaining) + now,
					progressType = "timed",
					show = true,
				}
			elseif i <= current then
				partial = {
					value = 1,
					total = 1,
					progressType = "static",
					show = true,
				}
			else
				partial = {
					value = 0,
					total = 1,
					progressType = "static",
					show = true,
				}
			end

			local changed = false

			for k, v in pairs(partial) do
				if state[k] ~= v then
					state[k] = v
					changed = true
				end
			end

			if changed then
				state.changed = true
				hasChanges = true
			end
		end
	end

	aura_env.lastPower = current
	aura_env.lastMaxPower = maxPower

	return hasChanges
end
