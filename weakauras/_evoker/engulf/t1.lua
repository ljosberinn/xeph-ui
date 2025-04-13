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
---@param event "TRIGGER" | "UNIT_SPELLCAST_SUCCEEDED" | "XEPHUI_ENGULF"
function f(states, event, ...)
	if event == "TRIGGER" then
		local updatedTriggerNumber, state = ...

		if not state then
			return false
		end

		if not states[""] then
			states[""] = {
				show = false,
				spellId = 443328,
				icon = 5927629,
				dragonrageReadyAt = aura_env.GetDragonrageCooldown(),
			}
		end

		if updatedTriggerNumber == 2 then -- engulf
			if
				not state[""]
				or state[""].stacks == nil
				or state[""].duration == nil
				or state[""].expirationTime == nil
			then
				return false
			end

			local chargeCooldown = state[""].duration > 0 and state[""].duration
				or C_Spell.GetSpellCharges(443328).cooldownDuration

			local cappingChargesIn = 0

			if state[""].expirationTime > 0 then
				local timeToNextCharge = state[""].expirationTime - GetTime()
				cappingChargesIn = cappingChargesIn + timeToNextCharge

				if state[""].stacks == 0 then
					cappingChargesIn = cappingChargesIn + chargeCooldown
				end
			end

			states:Update("", {
				stacks = state[""].stacks,
				progressType = "timed",
				expirationTime = state[""].expirationTime,
				duration = state[""].duration,
				show = state[""].stacks > 0 or state[""].expirationTime - GetTime() < aura_env.showWhenCdBelow,
				hold = aura_env.shouldHold(state[""]),
			})

			if states[""].stacks == 0 and not states[""].show then
				local queueTime = state[""].expirationTime - aura_env.showWhenCdBelow - GetTime()

				if queueTime > 0 then
					if aura_env.timer then
						aura_env.timer:Cancel()
					end

					aura_env.timer = C_Timer.After(queueTime, function()
						WeakAuras.ScanEvents("XEPHUI_ENGULF", aura_env.id)
					end)
				end
			end
		elseif updatedTriggerNumber == 4 then -- dragonrage
			states:Update("", {
				dragonrageReadyAt = state[""].duration > 0 and state[""].expirationTime or 0,
				hold = false,
			})
		end
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
		local unit, _, spellId = ...

		-- Living Flame damage id
		if
			unit ~= "player"
			or spellId ~= 361469
			or states[""] == nil
			or states[""].duration == nil
			or states[""].expirationTime == nil
		then
			return false
		end

		local hold = aura_env.shouldHold(states[""])

		if hold ~= states[""].hold then
			states:Update("", {
				hold = hold,
				show = states[""].show,
			})
		end
	elseif event == "XEPHUI_ENGULF" then
		local id = ...

		if id ~= aura_env.id then
			return false
		end

		states:Update("", {
			show = true,
			spellId = 443328,
			icon = 5927629,
			expirationTime = GetTime() + aura_env.showWhenCdBelow,
			duration = aura_env.showWhenCdBelow,
			stacks = 0,
			progressType = "timed",
			dragonrageReadyAt = aura_env.GetDragonrageCooldown(),
		})
	end
end
