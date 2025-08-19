--TRIGGER:2:3:4,  UNIT_SPELLCAST_SUCCEEDED:player
---@class EngulfState
---@field show boolean
---@field spellId number
---@field icon number
---@field expirationTime number
---@field duration number
---@field stacks number
---@field progressType "timed"
---@field dragonrageReadyAt number
---@field hold boolean

---@param states table<number, EngulfState>
---@param event "TRIGGER" | "UNIT_SPELLCAST_SUCCEEDED"
function f(states, event, ...)
	if event == "TRIGGER" then
		local updatedTriggerNumber, state = ...

		if not state then
			return
		end

		if not states[""] then
			states[""] = {
				show = true,
				spellId = 443328,
				icon = 5927629,
				dragonrageReadyAt = aura_env.GetDragonrageCooldown(),
				changed = true,
			}
		end

		if updatedTriggerNumber == 2 then -- engulf
			if
				not state[""]
				or state[""].stacks == nil
				or state[""].duration == nil
				or state[""].expirationTime == nil
			then
				return
			end

			local nextState = {
				stacks = state[""].stacks,
				progressType = "timed",
				expirationTime = state[""].expirationTime,
				duration = state[""].duration,
				show = true,
				hold = aura_env.shouldHold(state[""]),
			}

			local changed = false

			for k, v in pairs(nextState) do
				if states[""][k] ~= v then
					states[""][k] = v
					changed = true
				end
			end

			if changed then
				states[""].changed = true
			end

			return changed
		elseif updatedTriggerNumber == 4 then -- dragonrage
			if not state[""] then
				return false
			end

			local nextState = {
				dragonrageReadyAt = state[""].duration > 0 and state[""].expirationTime or 0,
				hold = false,
			}

			local changed = false

			for k, v in pairs(nextState) do
				if states[""][k] ~= v then
					states[""][k] = v
					changed = true
				end
			end

			if changed then
				states[""].changed = true
			end

			return changed
		end

		return false
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
		local unit = ...

		if unit ~= "player" or states[""] == nil or states[""].duration == nil or states[""].expirationTime == nil then
			return
		end

		local hold = aura_env.shouldHold(states[""], event)

		if hold ~= states[""].hold then
			states[""].hold = hold
			states[""].changed = true
			states[""].show = true

			return true
		end
	end

	return false
end
