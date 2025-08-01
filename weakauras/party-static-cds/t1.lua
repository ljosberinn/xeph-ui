--- UNIT_SPELLCAST_SUCCEEDED:party:raid, GROUP_ROSTER_UPDATE, READY_CHECK, XEPHUI_PartyStaticCDs

---@param states table<string, table>
---@param event "UNIT_SPELLCAST_SUCCEEDED" | "GROUP_ROSTER_UPDATE" | "READY_CHECK" | "XEPHUI_PartyStaticCDs"
---@return boolean
function f(states, event, ...)
	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		local unit, _, spellId = ...
		local changed = false

		if not states then
			return changed
		end

		-- Shifting Power tick
		if spellId == 382445 then
			local now = GetTime()

			for key, state in pairs(states) do
				-- just blanket assume any tracked mage ability is affected by Shifting Power
				-- although that isn't true for... hopefully irrelevant scenarios
				if state.unit == unit and state.progressType == "timed" then
					local nextExpirationTime = state.expirationTime - 3

					state.changed = true
					changed = true

					if nextExpirationTime < now then
						state.progressType = "static"
						state.value = 1
						state.total = 1
						state.changed = true
						state.duration = nil
						state.expirationTime = nil

						aura_env.clearTimerForKey(key)
					else
						state.expirationTime = nextExpirationTime

						local remainingCooldown = state.expirationTime - now
						aura_env.queue(key, remainingCooldown)
					end
				end
			end

			return changed
		end

		for key, state in pairs(states) do
			if state.unit == unit and state.spellId == spellId then
				local now = GetTime()

				if state.progressType == "timed" and (state.maxCharges == nil or state.charges == 0) then
					print(
						format(
							"[%s] observed %s using %s %ds before its supposed to be ready again",
							aura_env.id,
							UnitName(state.unit) or "Unknown",
							C_Spell.GetSpellName(state.spellId),
							state.expirationTime - now
						)
					)
				end

				local skipTimer = false

				if state.maxCharges and state.charges > 0 then
					state.charges = state.charges - 1

					if state.expirationTime == nil then
						state.expirationTime = now + state.cooldown
					else
						-- do not mutate expirationTime here as the first charges timer is still accurate.
						-- we also don't queue another timer since that's handled in the custom event branch
						skipTimer = true
					end
				else
					state.expirationTime = now + state.cooldown
				end

				state.changed = true
				state.progressType = "timed"
				state.duration = state.cooldown
				state.value = nil
				state.total = nil
				state.activation = now

				if not skipTimer then
					aura_env.queue(key, state.cooldown)
				end

				return true
			end
		end

		return changed
	end

	if event == aura_env.customEventName then
		local id, key = ...

		if id ~= aura_env.id then
			return false
		end

		local state = states[key]

		if not state then
			return false
		end

		if state.maxCharges then
			if state.charges == state.maxCharges then
				return false
			end

			state.charges = state.charges + 1
			state.changed = true

			if state.charges < state.maxCharges then
				state.expirationTime = GetTime() + state.cooldown
				state.progressType = "timed"
				state.duration = state.cooldown
				state.value = nil
				state.total = nil

				aura_env.queue(key, state.cooldown)

				return true
			end
		end

		state.progressType = "static"
		state.value = 1
		state.total = 1
		state.changed = true
		state.duration = nil
		state.expirationTime = nil

		return true
	end

	if event == "STATUS" or event == "GROUP_ROSTER_UPDATE" or event == "READY_CHECK" then
		local changed = false

		for unit in WA_IterateGroupMembers() do
			local specId = WeakAuras.SpecForUnit(unit)

			if specId then
				local spells = aura_env.spells[specId]

				if spells then
					local race = select(3, UnitRace(unit))

					if race == 3 then -- dwarf, stoneform
						spells[20594] = {
							cooldown = 120,
							maxCharges = 0,
						}
					elseif race == 4 then -- nelf, shadowmeld
						spells[58984] = {
							cooldown = 120,
							maxCharges = 0,
						}
					end

					for spellId, info in pairs(spells) do
						local guid = UnitGUID(unit)
						local spellInfo = C_Spell.GetSpellInfo(spellId)

						local key = guid .. spellId
						local locallyChanged = false

						if not states[key] then
							local nextState = {
								show = true,
								icon = spellInfo.iconID,
								progressType = "static",
								value = 1,
								total = 1,
								unit = unit,
								spellId = spellId,
								autoHide = false,
								cooldown = info.cooldown,
								unitName = UnitName(unit),
								guid = guid,
								charges = 0,
							}

							if info.maxCharges > 0 then
								nextState.maxCharges = info.maxCharges
								nextState.charges = info.maxCharges
							end

							states[key] = nextState
							locallyChanged = true
						else
							local nextStatePartial = {
								show = true,
								icon = spellInfo.iconID,
								unit = unit,
								spellId = spellId,
								autoHide = false,
								cooldown = info.cooldown,
								unitName = UnitName(unit),
								guid = guid,
							}

							for k, v in pairs(nextStatePartial) do
								if states[key][k] ~= v then
									states[key][k] = v
									locallyChanged = true
								end
							end
						end

						if locallyChanged then
							changed = true
							states[key].changed = true
						end
					end
				end
			end
		end

		return changed
	end

	if WeakAuras.IsOptionsOpen() then
		local now = GetTime()

		for specId, spells in pairs(aura_env.spells) do
			for spellId, info in pairs(spells) do
				local key = specId .. spellId
				local locallyChanged = false
				local spellInfo = C_Spell.GetSpellInfo(spellId)

				local nextState = {
					show = true,
					icon = spellInfo.iconID,
					progressType = "static",
					value = 1,
					total = 1,
					spellId = spellId,
					autoHide = false,
					unit = "player",
					cooldown = info.cooldown,
					unitName = UnitName("player"),
					spellName = spellInfo.name,
				}

				if info.maxCharges > 0 then
					nextState.maxCharges = info.maxCharges
					nextState.charges = info.maxCharges
				end

				if math.random(2) == 1 then
					nextState.progressType = "timed"
					nextState.duration = info.cooldown
					nextState.expirationTime = now + info.cooldown
				end

				if not states[key] then
					states[key] = nextState
					locallyChanged = true
				else
					for k, v in pairs(nextState) do
						if states[key][k] ~= v then
							states[key][k] = v
							locallyChanged = true
						end
					end
				end

				if locallyChanged then
					states[key].changed = true
				end
			end
		end

		return true
	end

	return false
end
