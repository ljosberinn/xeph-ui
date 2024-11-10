function f(states, event)
	if event == "STATUS" or event == "GROUP_ROSTER_UPDATE" or event == "READY_CHECK" then
		for unit in WA_IterateGroupMembers() do
			if not UnitIsUnit(unit, "player") then
				local specId = WeakAuras.SpecForUnit(unit)

				if aura_env.eligibleSpecs[specId] then
					states[""] = {
						show = true,
						changed = true,
						value = 1,
						total = 1,
						progressType = "static",
						spellId = 412710,
						icon = 5199646,
					}

					return true
				end
			end
		end
	end

	return false
end
