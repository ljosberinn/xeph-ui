-- UNIT_AURA:player, PLAYER_REGEN_DISABLED, PLAYER_REGEN_ENABLED, PLAYER_ENTERING_WORLD, UNIT_ENTERED_VEHICLE:player, UNIT_EXITED_VEHICLE:player
function (event, unit)
	if InCombatLockdown() or event == "PLAYER_REGEN_DISABLED" then
		return false
	end

	-- on combat leave or aura updates outside of combat to detect (dis)mounting
	if event == "PLAYER_REGEN_ENABLED" or event == "UNIT_AURA" then
		return IsMounted()
	end

	if event == "UNIT_ENTERED_VEHICLE" and unit == "player" then
		return true
	end

	if event == "UNIT_EXITED_VEHICLE" and unit == "player" then
		return false
	end

	-- default when WA is loaded
	return not InCombatLockdown() and IsMounted()
end
