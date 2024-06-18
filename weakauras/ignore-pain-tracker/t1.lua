-- UNIT_AURA:player

function f(event)
	if event ~= "UNIT_AURA" then
		return false
	end

	local auraInfo = C_UnitAuras.GetPlayerAuraBySpellID(190456)
	local absorb = 0

	if auraInfo and auraInfo.points then
		absorb = auraInfo.points[1]
	end

	aura_env.currentIgnorePainAbsorb = absorb
	aura_env.changed = aura_env.currentIgnorePainAbsorb ~= aura_env.lastIgnorePainAbsorb
	aura_env.lastIgnorePainAbsorb = aura_env.currentIgnorePainAbsorb

	return true
end
