function f()
	local ignorePainCap = aura_env.calcCurrentIgnorePainCap()
	local currentIgnorePainAbsorb = aura_env.currentIgnorePainAbsorb

	if ignorePainCap < currentIgnorePainAbsorb then
		ignorePainCap = currentIgnorePainAbsorb
	end

	local percentOfCap = aura_env.shortenPercent(currentIgnorePainAbsorb / ignorePainCap * 100)
	local percentOfMaxHP = aura_env.shortenPercent(currentIgnorePainAbsorb / aura_env.currentMaxHealth * 100)
	local additionalAbsorb = ignorePainCap - (currentIgnorePainAbsorb or 0)
	aura_env.overabsorb = additionalAbsorb / aura_env.tooltipAbsorb

	if aura_env.config.textOptions.shortenText then
		currentIgnorePainAbsorb = aura_env.shortenNumber(currentIgnorePainAbsorb)
		additionalAbsorb = aura_env.shortenNumber(additionalAbsorb)
	end

	aura_env.text1 = aura_env.determineTextOne(currentIgnorePainAbsorb, percentOfCap, additionalAbsorb, percentOfMaxHP)
	aura_env.text2 = aura_env.determineTextTwo(currentIgnorePainAbsorb, percentOfCap, additionalAbsorb, percentOfMaxHP)

	aura_env.updateVisuals()

	return aura_env.text1, aura_env.text2 -- required to trigger update
end
