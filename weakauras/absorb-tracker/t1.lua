-- UNIT_ABSORB_AMOUNT_CHANGED:player
--- @param event "UNIT_ABSORB_AMOUNT_CHANGED" | "UNIT_MAXHEALTH"
--- @return boolean
function f(states, event, ...)
	if event == "STATUS" then
		states[""] = {
			changed = true,
			show = false,
			stacks = aura_env.getTotalAbsorb(),
			autoHide = true,
			progressType = "static",
		}

		return true
	end

	if event == "UNIT_ABSORB_AMOUNT_CHANGED" then
		local totalAbsorb = aura_env.getTotalAbsorb()

		if totalAbsorb == states[""].stacks then
			return false
		end

		states[""].stacks = totalAbsorb
		states[""].changed = true
		states[""].show = totalAbsorb > 0

		return true
	end

	return false
end
