-- UNIT_SPELLCAST_SUCCEEDED:player,UNIT_AURA:player,UNIT_POWER_UPDATE:player
function f(event, _, _, arg3)
	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		aura_env.onPlayerSpellCastSuccess(arg3)
	elseif event == "UNIT_AURA" then
		aura_env.onPlayerAuraUpdate()
	elseif event == "UNIT_POWER_UPDATE" then
		aura_env.onRageChange()
	end

	return true
end
