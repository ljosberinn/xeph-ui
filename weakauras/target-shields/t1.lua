---UNIT_ABSORB_AMOUNT_CHANGED:target,PLAYER_TARGET_CHANGED, XEPHUI_ShieldUpdate
--@param event "PLAYER_TARGET_CHANGED" | "UNIT_ABSORB_AMOUNT_CHANGED" | "XEPHUI_ShieldUpdate"
function f(states, event, ...)
	if event == "PLAYER_TARGET_CHANGED" or event == "UNIT_ABSORB_AMOUNT_CHANGED" then
		aura_env.queue()

		return false
	end

	if event == "XEPHUI_ShieldUpdate" then
		local current = UnitGetTotalAbsorbs("target")

		if
			current == 0
			or UnitIsPlayer("target")
			or (UnitIsFriend("player", "target") and not UnitCanAttack("player", "target"))
		then
			if states[""] and states[""].show then
				states[""].show = false
				states[""].changed = true

				return true
			end

			return false
		end

		if states[""] == nil then
			states[""] = {
				show = true,
				changed = true,
				autoHide = true,
				progressType = "static",
				total = current,
				value = current,
			}

			return true
		end

		if current > states[""].total then
			states[""].total = current
			states[""].changed = true
		end

		if states[""].value ~= current then
			states[""].value = current
			states[""].changed = true
		end

		return states[""].changed
	end

	return false
end
