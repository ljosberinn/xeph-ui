function aura_env.GetDragonrageCooldown()
	local dragonrageCooldownInfo = C_Spell.GetSpellCooldown(375087)

	return dragonrageCooldownInfo.startTime + dragonrageCooldownInfo.duration
end

aura_env.timer = nil
aura_env.slopPercent = 0.15
aura_env.showWhenCdBelow = 10

---@return boolean
function aura_env.shouldHold(state)
	local chargeCooldown = state.duration > 0 and state.duration or C_Spell.GetSpellCharges(443328).cooldownDuration

	local cappingChargesIn = 0

	if state.expirationTime > 0 then
		local timeToNextCharge = state.expirationTime - GetTime()
		cappingChargesIn = cappingChargesIn + timeToNextCharge

		if state.stacks == 0 then
			cappingChargesIn = cappingChargesIn + chargeCooldown
		end
	end

	local dragonrageReadyAt = state.dragonrageReadyAt or aura_env.GetDragonrageCooldown()

	if dragonrageReadyAt == 0 then
		return false
	end

	local capsBeforeDragonrageCd = GetTime() + cappingChargesIn < dragonrageReadyAt

	if not capsBeforeDragonrageCd then
		return true
	end

	local timeBetweenCappingAndDragonrage = dragonrageReadyAt - cappingChargesIn - GetTime()

	if timeBetweenCappingAndDragonrage <= chargeCooldown then
		-- delaying DR by up to approx. 25% of an engulf charge cd is ok if it means you can cast another
		local fudge = 0.15 * chargeCooldown
		return timeBetweenCappingAndDragonrage > fudge
	end

	return false
end
