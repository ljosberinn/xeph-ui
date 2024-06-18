function f()
	if aura_env.config.iconOptions.saturateBasedOnRage then
		local powerCostInfo = GetSpellPowerCost and GetSpellPowerCost(190456) or C_Spell.GetSpellPowerCost(190456)
		local cost = powerCostInfo[2].cost
		local currentRage = UnitPower("player")
		local hasEnough = currentRage >= cost

		return not hasEnough
	end

	return aura_env.currentIgnorePainAbsorb == 0
end
