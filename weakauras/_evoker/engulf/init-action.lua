function aura_env.GetDragonrageCooldown()
	local dragonrageCooldownInfo = C_Spell.GetSpellCooldown(375087)

	return dragonrageCooldownInfo.startTime + dragonrageCooldownInfo.duration
end

---@param state EngulfState
---@return boolean
function aura_env.shouldHold(state)
	local dragonrageReadyAt = state.dragonrageReadyAt or aura_env.GetDragonrageCooldown()

	if dragonrageReadyAt == 0 then
		return false
	end

	local chargeCooldown = state.duration > 0 and state.duration or C_Spell.GetSpellCharges(443328).cooldownDuration
	local cappingChargesIn = 0
	local now = GetTime()

	if state.expirationTime > 0 then
		local timeToNextCharge = state.expirationTime - now
		cappingChargesIn = cappingChargesIn + timeToNextCharge

		if state.stacks == 0 then
			cappingChargesIn = cappingChargesIn + chargeCooldown
		end
	end

	local dragonrageReadyIn = dragonrageReadyAt == 0 and 0 or dragonrageReadyAt - now

	-- currently at 2 charges
	if cappingChargesIn == 0 then
		local fudge = aura_env.config.slopPercent * chargeCooldown

		-- DR cd is further away than another charge, send
		if dragonrageReadyIn > chargeCooldown - fudge then
			return false
		end

		return true
	end

	local capsBeforeDragonrageCd = cappingChargesIn < dragonrageReadyIn

	if not capsBeforeDragonrageCd then
		return true
	end

	local timeBetweenCappingAndDragonrage = dragonrageReadyIn - cappingChargesIn

	if timeBetweenCappingAndDragonrage <= chargeCooldown then
		local fudge = aura_env.config.slopPercent * chargeCooldown

		if timeBetweenCappingAndDragonrage > (chargeCooldown - fudge) then
			return false
		end

		return true
	end

	return false
end
