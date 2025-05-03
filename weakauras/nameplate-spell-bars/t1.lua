---BWSPELLS_ADD, BWSPELLS_REMOVE, BWSPELLS_DISABLE, NAME_PLATE_UNIT_ADDED, NAME_PLATE_UNIT_REMOVED,RAID_TARGET_UPDATE, PLAYER_REGEN_ENABLED
---@class NameplateSpellCDBar
---@field show boolean
---@field changed boolean
---@field progressType string
---@field duration number
---@field name string
---@field expirationTime number
---@field icon number
---@field autoHide false
---@field guid string
---@field mark number?
---@field unit string
---@field interruptable boolean
---@field aoe boolean
---@field stoppable boolean
---@field glowBelow number?

---@param states table<string, NameplateSpellCDBar>
---@param event "BWSPELLS_ADD" | "BWSPELLS_REMOVE" | "BWSPELLS_DISABLE" | "NAME_PLATE_UNIT_ADDED" | "NAME_PLATE_UNIT_REMOVED" | "RAID_TARGET_UPDATE" | "PLAYER_REGEN_ENABLED"
function f(states, event, ...)
	if event == "NAME_PLATE_UNIT_ADDED" then
		local unit = ...

		if not unit then
			return false
		end

		local guid = UnitGUID(unit)

		if guid then
			aura_env.unitsByGuid[guid] = unit
		end

		return false
	end

	if event == "NAME_PLATE_UNIT_REMOVED" then
		local unit = ...

		if not unit then
			return false
		end

		local guid = UnitGUID(unit)

		if guid then
			aura_env.unitsByGuid[guid] = unit
		end

		return false
	end

	if event == "BWSPELLS_ADD" then
		local id, _, _, guid, spellId, cd = ...

		if id ~= aura_env.id then
			return false
		end

		local spell = aura_env.spells[spellId]

		if not spell then
			return false
		end

		local key = guid .. spellId

		if aura_env.unitsByGuid[guid] == nil then
			aura_env.unitsByGuid[guid] = UnitGUID(guid)

			if not aura_env.unitsByGuid[guid] then
				return false
			end
		end

		local unit = aura_env.unitsByGuid[guid]

		local nextState = {
			show = true,
			changed = true,
			progressType = "timed",
			duration = cd,
			name = spell.name,
			expirationTime = cd + GetTime(),
			icon = spell.icon,
			autoHide = false,
			guid = guid,
			mark = GetRaidTargetIndex(unit),
			unit = unit,
			interruptable = spell.interruptable,
			aoe = spell.aoe,
			stoppable = spell.stoppable,
			glowBelow = spell.glowBelow,
		}

		if states[key] then
			local changed = false
			local currentState = states[key]

			for k, v in pairs(nextState) do
				if currentState[k] ~= v then
					currentState[k] = v
					changed = true
				end
			end

			return changed
		end

		states[key] = nextState

		return true
	end

	if event == "BWSPELLS_REMOVE" then
		local id, _, _, guid = ...

		if id ~= aura_env.id then
			return false
		end

		local changed = false

		for _, state in pairs(states) do
			if state.guid == guid and state.show then
				state.show = false
				state.changed = true
				changed = true
			end
		end

		aura_env.unitsByGuid[guid] = nil

		return changed
	end

	if event == "BWSPELLS_DISABLE" then
		local id = ...

		if id ~= aura_env.id then
			return false
		end

		table.wipe(aura_env.unitsByGuid)

		local changed = false

		for _, state in pairs(states) do
			if state.show then
				state.show = false
				state.changed = true
				changed = true
			end
		end

		return changed
	end

	if event == "RAID_TARGET_UPDATE" then
		local changed = false

		for _, state in pairs(states) do
			local currentMarkIdx = GetRaidTargetIndex(state.unit)

			if currentMarkIdx ~= state.mark then
				state.mark = currentMarkIdx
				state.changed = true
				changed = true
			end
		end

		return changed
	end

	if event == "PLAYER_REGEN_ENABLED" and aura_env.config.clearAfterCombat then
		local changed = false

		for _, state in pairs(states) do
			if state.show then
				state.show = false
				state.changed = true
				changed = true
			end
		end

		return changed
	end

	if WeakAuras.IsOptionsOpen() then
		for index, spell in pairs(aura_env.config.spells) do
			local key = index .. spell.id

			local spellInfo = C_Spell.GetSpellInfo(spell.id)
			local cd = spell.id / 10000

			states[key] = {
				show = true,
				changed = true,
				progressType = "timed",
				duration = cd,
				name = spellInfo.name,
				expirationTime = cd + GetTime(),
				icon = spellInfo.iconID,
				autoHide = false,
				guid = index,
				mark = math.random(0, 8),
				unit = index,
				interruptable = spell.interruptable,
				aoe = spell.aoe,
				stoppable = spell.stoppable,
			}
		end

		return true
	end

	return false
end
