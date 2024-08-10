-- ACTIVE_PLAYER_SPECIALIZATION_CHANGED, GROUP_ROSTER_UPDATE, GROUP_LEFT, STATUS, WA_DELAYED_PLAYER_ENTERING_WORLD, UNIT_SPEC_CHANGED
--- @param event "ACTIVE_PLAYER_SPECIALIZATION_CHANGED" | "WA_DELAYED_PLAYER_ENTERING_WORLD" | "UNIT_SPEC_CHANGED" | "GROUP_LEFT" | "GROUP_ROSTER_UPDATE"
function f(_, event, ...)
	if not aura_env.active or not event then
		return false
	end

	if event == "ACTIVE_PLAYER_SPECIALIZATION_CHANGED" then
		aura_env.onPlayerSpecChange(event)

		return false
	end

	if event == "GROUP_LEFT" then
		aura_env.onGroupLeave()
		return false
	end

	if string.find(event, "UNIT_SPEC_CHANGED") ~= nil then
		local unit = ...

		-- personal spec changes are already handled above
		-- unlikely that UNIT_SPEC_CHANGED fires for anything other than party/raid but just in case, ignore those
		if UnitIsUnit(unit, "player") or (string.find(event, "party") == nil and string.find(event, "raid") == nil) then
			return
		end

		local specId = WeakAuras.SpecForUnit(unit)

		if specId and specId ~= aura_env.tokenToSpecIdMap[unit] then
			aura_env.tokenToSpecIdMap[unit] = specId

			aura_env.log("received spec for " .. aura_env.formattedSpecIconWithName(unit, specId))
		end

		aura_env.setup("UNIT_SPEC_CHANGED")

		return false
	end

	if event == "STATUS" then
		aura_env.onLoginOrReload()

		for unit in WA_IterateGroupMembers() do
			if not UnitIsUnit(unit, "player") then
				aura_env.tokenToSpecIdMap[unit] = WeakAuras.SpecForUnit(unit)
			end
		end

		aura_env.setup(event == "STATUS" and "UNIT_SPEC_CHANGED" or "OPTIONS")

		return false
	end

	if event == "GROUP_ROSTER_UPDATE" or event == "READY_CHECK" or event == "WA_DELAYED_PLAYER_ENTERING_WORLD" then
		if event == "WA_DELAYED_PLAYER_ENTERING_WORLD" then
			aura_env.onLoginOrReload()
		end

		if event == "GROUP_ROSTER_UPDATE" then
			for unit in WA_IterateGroupMembers() do
				if not UnitIsUnit(unit, "player") then
					local specId = WeakAuras.SpecForUnit(unit)

					if specId then
						if specId ~= aura_env.tokenToSpecIdMap[unit] then
							aura_env.tokenToSpecIdMap[unit] = specId

							aura_env.log("received spec for " .. aura_env.formattedSpecIconWithName(unit, specId))
						end
					else
						aura_env.log("could not determine spec for unit " .. unit .. " (" .. UnitName(unit) .. ")")
					end
				end
			end
		end

		aura_env.setup(event)
	end

	return false
end
