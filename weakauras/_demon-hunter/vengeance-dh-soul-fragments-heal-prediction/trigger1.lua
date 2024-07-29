-- TRIGGER:2, UNIT_AURA:player, UNIT_HEALTH:player, CLEU:SWING_DAMAGE, CLEU:SPELL_DAMAGE, CLEU:SPELL_PERIODIC_DAMAGE, CLEU:SPELL_ABSORBED
function f(event, timestamp, subEvent, _, _, _, _, _, targetGUID, _, _, _, ...)
	if event == "TRIGGER" and timestamp == 2 then
		for _, triggerState in pairs(subEvent) do
			if triggerState.triggernum == 2 then
				aura_env.hasT302SetEquipped = triggerState.show
			end
		end

		return false
	end

	if event == "UNIT_HEALTH" then
		local current = aura_env.getCurrentPlayerHealth()
		local max = aura_env.getPlayerMaxHealth()

		if current == aura_env.currentHealth and max == aura_env.maxHealth then
			return aura_env.currentFragments > 0
		end

		aura_env.currentHealth = current
		aura_env.maxHealth = max

		return true
	end

	if event == "UNIT_AURA" then
		aura_env.maybeToggleGuardianSpirit()
		aura_env.maybeToggleDivineHymn()
		aura_env.maybeToggleLuckyOfTheDraw()
		aura_env.maybeToggleBlessingOfSpring()

		local fragments = aura_env.getSoulFragmentCount()

		if fragments == aura_env.lastFragments then
			return fragments > 0
		end

		aura_env.lastFragments = aura_env.currentFragments
		aura_env.currentFragments = fragments

		return fragments > 0
	end

	if targetGUID ~= WeakAuras.myGUID then
		return aura_env.currentFragments > 0
	end

	local amount = 0

	if subEvent == "SWING_DAMAGE" then
		amount = ...
	elseif subEvent == "SPELL_DAMAGE" or subEvent == "SPELL_PERIODIC_DAMAGE" then
		amount = select(4, ...)
	elseif subEvent == "SPELL_ABSORBED" then
		local spellId, spellName = ...

		amount = select(GetSpellInfo(spellId) == spellName and 11 or 8, ...)
	end

	if amount > 0 then
		aura_env.appendDamageTaken(timestamp, amount)
	end

	return aura_env.currentFragments > 0
end
