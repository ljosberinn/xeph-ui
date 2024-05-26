-- TRIGGER:2

--- @class FocusKickState
--- @field show boolean
--- @field changed boolean
--- @field expirationTime number
--- @field autoHide true
--- @field progressType "timed"
--- @field icon number|string
--- @field spellId number
--- @field duration number
--- @field remaining number
--- @field name string
--- @field additionalProgress table<number, { min: number; max: number }> | nil
--- @field interruptOnCooldown boolean
--- @field unit string | nil
--- @field castType "cast" | "channel"
--- @field raidMark number | nil
--- @field raidMarkIndex number | nil
--- @field class string | nil
--- @field stage number | nil
--- @field stageTotal number | nil
--- @field sourceName string | nil
--- @field sourceUnit string | nil
--- @field sourceRealm string | nil
--- @field destName string | nil
--- @field destUnit string | nil
--- @field destRealm string | nil

--- @param states table<"", FocusKickState>
--- @param event "TRIGGER"
function f(states, event, updatedTriggerNumber, updatedTriggerStates)
	if event == "TRIGGER" and updatedTriggerNumber == 2 then
		local state = updatedTriggerStates[""]

		if not state then
			if not states[""] or not states[""].show then
				return false
			end

			states[""].show = false
			states[""].changed = true

			return true
		end

		if not states[""] then
			states[""] = {
				changed = true,
				show = true,
				autoHide = false,
				progressType = "timed",
			}
		end

		if WeakAuras.GetPlayerReaction("focus") == "friendly" then
			if states[""].show then
				states[""].show = false
				states[""].changed = true
				return true
			end

			return false
		end

		for k, v in pairs(state) do
			if aura_env.allowedKeys[k] then
				states[""][k] = v
			end
		end

		states[""].destName = UnitName("focus-target")

		if state.stageTotal ~= nil and state.stageTotal > 0 then
			local empowerHoldAtMaxTime = GetUnitEmpowerHoldAtMaxTime("focus")
			-- endTime on empowered abilities does not account for holding at max
			local endTime = state.expirationTime * 1000 + empowerHoldAtMaxTime
			local expirationTime = endTime / 1000
			states[""].expirationTime = expirationTime
			states[""].remaining = expirationTime - GetTime()
			states[""].duration = state.duration + (empowerHoldAtMaxTime / 1000)
			states[""].castType = "cast"
		end

		local interruptCooldown, interruptCastTimestamp = aura_env.getInterruptCooldown()
		states[""].interruptOnCooldown = interruptCooldown > 0

		if not state.interruptible or not states[""].interruptOnCooldown then
			aura_env.hideTick()
			return true
		end

		local interruptReadyAt = interruptCastTimestamp + interruptCooldown

		if interruptReadyAt > state.expirationTime - aura_env.config.interruptThreshold then
			aura_env.hideTick()
			return true
		end

		local max = states[""].expirationTime - interruptReadyAt

		states[""].additionalProgress = {
			{
				min = 0,
				max = max,
			},
		}

		aura_env.updateTickPlacement(states[""].duration - max)

		return true
	end

	return false
end
