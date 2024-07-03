-- UNIT_MAXHEALTH:player
function f()
	aura_env.currentMaxHealth = UnitHealthMax("player")
	return true
end
