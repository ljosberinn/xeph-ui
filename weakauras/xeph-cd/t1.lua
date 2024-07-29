-- PLAYER_SPECIALIZATION_CHANGED, INSPECT_READY, TRAIT_CONFIG_UPDATED, UNIT_SPELLCAST_SUCCEEDED, XephCD_CD_READY, UNIT_AURA, XephCD_AURA_EXPIRED, PLAYER_EQUIPMENT_CHANGED, CUSTOM_EVENT_CHARGE_GAINED

---@class XephCDState
---@field show boolean
---@field changed boolean
---@field spellId number
---@field unit string
---@field progressType string
---@field duration number|nil
---@field expirationTime number|nil
---@field cooldown number
---@field value number|nil
---@field total number|nil
---@field kind string
---@field auraActive boolean
---@field stacks number|nil
---@field maxStacks number|nil
---@field auraInstanceId number|nil
---@field onAuraExpiryState? XephCDState

---@param states table<string, XephCDState>
---@param event "OPTIONS" | "STATUS" | "PLAYER_SPECIALIZATION_CHANGED" | "INSPECT_READY" | "TRAIT_CONFIG_UPDATED" | "XephCD_CD_READY" | "UNIT_AURA" | "XephCD_AURA_EXPIRED" | "PLAYER_EQUIPMENT_CHANGED"
---@return boolean
function f(states, event, ...)
	if event == "STATUS" or event == "OPTIONS" then
		DevTool:AddData({}, event)
		if event ~= "OPTIONS" then -- dont enqueue inspecting here, apparently cannot clean those timers up
			for unit in WA_IterateGroupMembers() do
				aura_env.enqueueInspect(unit)
			end
		end

		local specId = GetSpecializationInfo(GetSpecialization())

		if specId == nil or specId == 0 then
			return false
		end

		local activeConfigId = C_ClassTalents.GetActiveConfigID()

		if not activeConfigId then
			return false
		end

		local talents, talentsSuccess = aura_env.getTalents(activeConfigId)

		if not talentsSuccess or not talents then
			return false
		end

		local gear, gearSuccess = aura_env.getGear("player")

		if not gearSuccess then
			return false
		end

		aura_env.setupState(states, {
			guid = WeakAuras.myGUID,
			unit = "player",
			talents = talents,
			gear = gear,
			specId = specId,
		})

		return true
	end

	if event == "UNIT_AURA" then
		---@type string, UnitAuraUpdateInfo|nil
		local unit, updateInfo = ...

		if
			not updateInfo
			or (unit ~= "player" and string.find(unit, "party") == nil and string.find(unit, "raid") == nil)
		then
			return false
		end
		DevTool:AddData({ unit, updateInfo }, event)

		local hasChanges = false

		---@type table<number, string>
		local activeAuraInstanceIds = {}

		for key, state in pairs(states) do
			if state.unit == unit and state.auraActive and state.auraInstanceId then
				activeAuraInstanceIds[state.auraInstanceId] = key
			end
		end

		---@type table<number, AuraData>
		local addedAuras = {}
		---@type table<number, AuraData>
		local updatedAuras = {}

		if updateInfo.addedAuras then
			for i = 1, #updateInfo.addedAuras do
				local aura = updateInfo.addedAuras[i]
				addedAuras[aura.spellId] = aura
			end
		end

		if updateInfo.updatedAuraInstanceIDs then
			for i = 1, #updateInfo.updatedAuraInstanceIDs do
				local id = updateInfo.updatedAuraInstanceIDs[i]
				local aura = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, id)

				if aura then
					updatedAuras[aura.spellId] = aura
				end
			end
		end

		for key, state in pairs(states) do
			if state.unit == unit then
				local addedAura = addedAuras[state.spellId]

				if addedAura and addedAura.expirationTime > 0 and addedAura.duration < 600 then
					state.changed = true
					state.auraActive = true
					state.auraInstanceId = addedAura.auraInstanceID

					local remainingTime = state.cooldown - addedAura.duration
					local expirationTime = state.expirationTime
					local customEventName = aura_env.CUSTOM_EVENT_AURA_EXPIRED
					local id = aura_env.id

					print(event, "queued " .. state.spellId .. " for " .. addedAura.duration .. " seconds")

					-- state.onAuraExpiryState = {
					-- 	progressType = "timed",
					-- 	expirationTime = expirationTime,
					-- 	duration = remainingTime,
					-- }

					DevTool:AddData(state, "added aura")

					aura_env.scheduledAuraEvents[key] = C_Timer.NewTimer(addedAura.duration, function()
						WeakAuras.ScanEvents(customEventName, id, key, remainingTime, expirationTime, "addedAura")
					end, 1)

					state.progressType = "timed"
					state.duration = addedAura.duration
					state.expirationTime = addedAura.expirationTime

					hasChanges = true
				end

				local updatedAura = updatedAuras[state.spellId]

				if updatedAura then
					local recuperatedCooldown = GetTime() - (state.expirationTime - state.duration)

					state.changed = true
					state.expirationTime = updatedAura.expirationTime
					state.duration = updatedAura.duration

					local remainingTime = state.cooldown - recuperatedCooldown - updatedAura.duration
					local expirationTime = state.expirationTime + remainingTime
					local customEventName = aura_env.CUSTOM_EVENT_AURA_EXPIRED
					local id = aura_env.id

					if aura_env.scheduledAuraEvents[key] and not aura_env.scheduledAuraEvents[key]:IsCancelled() then
						aura_env.scheduledAuraEvents[key]:Cancel()
						aura_env.scheduledAuraEvents[key] = nil
						print("UPDATED canceled previous aura timer")
					end

					-- state.onAuraExpiryState = {
					-- 	progressType = "timed",
					-- 	expirationTime = expirationTime,
					-- 	duration = remainingTime,
					-- }

					DevTool:AddData(state, "updated aura")

					aura_env.scheduledAuraEvents[key] = C_Timer.NewTimer(updatedAura.duration, function()
						WeakAuras.ScanEvents(customEventName, id, key, remainingTime, expirationTime, "updatedAura")
					end, 1)

					hasChanges = true
				end
			end
		end

		if updateInfo.removedAuraInstanceIDs then
			for i = 1, #updateInfo.removedAuraInstanceIDs do
				local auraInstanceId = updateInfo.removedAuraInstanceIDs[i]
				local key = activeAuraInstanceIds[auraInstanceId]

				if key then
					local state = states[key]
					state.auraActive = false
					state.changed = true
					state.auraInstanceId = nil
					-- todo: account for manual removal of aura
					hasChanges = true

					-- if aura_env.scheduledAuraEvents[key] and not aura_env.scheduledAuraEvents[key]:IsCancelled() then
					-- aura_env.scheduledAuraEvents[key]:Cancel()
					-- aura_env.scheduledAuraEvents[key] = nil
					-- print("REMOVAL canceled previous aura timer")

					-- todo: doing this is technically wrong. the scheduled events sets the state for the next remaining cooldown in the custom event branch
					-- end

					DevTool:AddData(state, "removed aura")

					if state.onAuraExpiryState then
						state.progressType = state.onAuraExpiryState.progressType
						state.expirationTime = state.onAuraExpiryState.expirationTime
						state.duration = state.onAuraExpiryState.duration
						state.onAuraExpiryState = nil

						local id = aura_env.id
						local customEventName = aura_env.CUSTOM_EVENT_CD_READY
						local remainingTime = state.expirationTime - GetTime()

						aura_env.scheduledCooldownEvents[key] = C_Timer.NewTimer(remainingTime, function()
							WeakAuras.ScanEvents(customEventName, id, key, nil, "removedAura")
						end, 1)
					end

					print(unit, "removed " .. C_Spell.GetSpellLink(states[key].spellId))
				end
			end
		end

		return hasChanges
	end

	if event == "TRAIT_CONFIG_UPDATED" or event == "PLAYER_EQUIPMENT_CHANGED" then
		local specId = GetSpecializationInfo(GetSpecialization())
		DevTool:AddData({ specId }, event)

		if specId == nil or specId == 0 then
			return false
		end

		local activeConfigId = C_ClassTalents.GetActiveConfigID()

		if not activeConfigId then
			return false
		end

		local talents, talentsSuccess = aura_env.getTalents(activeConfigId)

		if not talentsSuccess or not talents then
			return false
		end

		local gear, gearSuccess = aura_env.getGear("player")

		if not gearSuccess then
			return false
		end

		aura_env.log(event, specId, activeConfigId, talentsSuccess, gearSuccess)

		aura_env.setupState(states, {
			guid = WeakAuras.myGUID,
			unit = "player",
			talents = talents,
			gear = gear,
			specId = specId,
		})

		return true
	end

	if event == "PLAYER_SPECIALIZATION_CHANGED" then
		local unit = ...
		DevTool:AddData({ unit }, event)

		aura_env.enqueueInspect(unit)

		return false
	end

	if event == aura_env.CUSTOM_EVENT_CD_READY then
		local id, key, stacks, source = ...
		DevTool:AddData({ id, key, stacks, source }, event)

		if stacks ~= nil then
			key = string.gsub(key, "|" .. stacks, "")
		end

		local state = states[key]

		print(event, key, source)

		if id ~= aura_env.id or state == nil or state.progressType == "static" then
			return false
		end

		state.changed = true

		if state.maxStacks ~= nil then
			if state.stacks < state.maxStacks then
				state.stacks = state.stacks + 1
			end

			if state.stacks < state.maxStacks then
				if state.auraActive then
					local expirationTime = state.cooldown + GetTime()
					local duration = state.cooldown

					state.onAuraExpiryState = {
						progressType = "timed",
						expirationTime = expirationTime,
						duration = duration,
					}

					DevTool:AddData(state, "aura active, gained stack")
				else
					state.progressType = "timed"
					state.duration = state.cooldown
					state.expirationTime = GetTime() + state.duration

					aura_env.scheduledCooldownEvents[key] = C_Timer.NewTimer(state.duration, function()
						WeakAuras.ScanEvents(event, id, key, nil, event)
					end, 1)

					DevTool:AddData(state, "not max stacks yet, recharging")
				end

				return true
			end
		end

		state.progressType = "static"
		state.duration = nil
		state.expirationTime = nil
		state.value = 1
		state.total = 1

		DevTool:AddData(state, "resetting entirely, reached max stacks or never had any")

		return true
	end

	if event == aura_env.CUSTOM_EVENT_AURA_EXPIRED then
		local id, key, duration, expirationTime, source = ...
		DevTool:AddData({}, event)

		print(event, id, key, source)
		local state = states[key]

		if id ~= aura_env.id or state == nil or state.progressType == "static" then
			return false
		end

		print(GetTime(), "restoring cooldown expiration for " .. key .. " in " .. duration, expirationTime - GetTime())

		aura_env.scheduledAuraEvents[key] = nil

		state.changed = true
		state.progressType = "timed"
		state.duration = duration
		state.expirationTime = expirationTime

		return true
	end

	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		DevTool:AddData({}, event)
		local unit, _, spellId = ...

		local guid = UnitGUID(unit)

		if not guid then
			return false
		end

		local key = guid .. "|" .. spellId
		local state = states[key]

		if state == nil then
			return false
		end

		if state.progressType ~= "timed" then
			state.changed = true
			state.show = true
			state.progressType = "timed"
			state.duration = state.cooldown
			-- todo: ongoing buff may be present
			state.expirationTime = GetTime() + state.duration
		end

		if state.maxStacks ~= nil then
			state.changed = true
			state.stacks = state.stacks - 1

			-- don't queue repeated stack consumption as cd recuperates chained, not in parallel
			if state.stacks < state.maxStacks - 1 then
				return true
			end

			key = key .. "|" .. state.stacks
		end

		local stacks = state.stacks
		local customEventName = aura_env.CUSTOM_EVENT_CD_READY
		local id = aura_env.id

		print("queued" .. customEventName, key, stacks, event)

		aura_env.scheduledCooldownEvents[key] = C_Timer.NewTimer(state.cooldown, function()
			WeakAuras.ScanEvents(customEventName, id, key, stacks, event)
		end, 1)

		return true
	end

	if event == "INSPECT_READY" then
		DevTool:AddData({}, event)
		local guid = ...

		if guid == WeakAuras.myGUID then
			return false
		end

		aura_env.log(event, guid)

		local unit = UnitTokenFromGUID(guid)

		if not unit then
			aura_env.log(format("[%s] could not get a unit for guid %s", event, guid))
			return false
		end

		local specId = GetInspectSpecialization(unit)

		if not specId or specId == 0 then
			aura_env.log(format("[%s] spec id is either 0 or nil for %s", event, unit))
			return false
		end

		local className = UnitClassBase(unit)
		local _, specName, _, icon = GetSpecializationInfo(specId, true)

		aura_env.log(
			format(
				"[%s] observed %s",
				event,
				aura_env.formattedSpecIconWithName(specName, icon, className, UnitName(unit))
			)
		)

		local talents, talentsSuccess = aura_env.getTalents(Constants.TraitConsts.INSPECT_TRAIT_CONFIG_ID)

		if not talentsSuccess or not talents then
			return false
		end

		local gear, gearSuccess = aura_env.getGear(unit)

		if not gearSuccess then
			return false
		end

		aura_env.setupState(states, {
			guid = guid,
			unit = unit,
			talents = talents,
			gear = gear,
			specId = specId,
		})

		if aura_env.inspect[guid] and not aura_env.inspect[guid]:IsCancelled() then
			aura_env.inspect[guid]:Cancel()
			aura_env.inspect[guid] = nil
			aura_env.log(format("[%s] cleared up ticker", event))
		end

		ClearInspectPlayer()

		return true
	end

	return false
end
