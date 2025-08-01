---PLAYER_REGEN_ENABLED, XEPHUI_BigWigs_StartBar, XEPHUI_BigWigs_StartNameplate, XEPHUI_BigWigs_StopNameplate, XEPHUI_BigWigs_StopBars, XEPHUI_BigWigs_OnBossDisable, XEPHUI_BigWigs_OnBossWipe
---@class NameplateSpellCDBar
---@field show boolean
---@field changed boolean
---@field progressType string
---@field duration number
---@field name string
---@field expirationTime number
---@field icon number
---@field autoHide boolean
---@field guid string?
---@field mark number?
---@field unit string?
---@field interruptable boolean
---@field aoe boolean
---@field stoppable boolean
---@field isBossBar boolean

---@param states table<string, NameplateSpellCDBar>
---@param event  "XEPHUI_BigWigs_StartBar" | "XEPHUI_BigWigs_StartNameplate" | "XEPHUI_BigWigs_StopNameplate" | "XEPHUI_BigWigs_StopBars" | "XEPHUI_BigWigs_OnBossDisable" | "XEPHUI_BigWigs_OnBossWipe"
function f(states, event, ...)
	if event == "XEPHUI_BigWigs_StartBar" then
		local id, eventName, bossMod, spellId, name, cooldown, icon = ...

		if id ~= aura_env.id then
			return false
		end

		if cooldown > 10 then
			local diff = cooldown - 10

			table.insert(
				aura_env.timers,
				C_Timer.NewTimer(diff, function()
					WeakAuras.ScanEvents(event, id, eventName, bossMod, spellId, name, 10, icon)
				end)
			)
			return false
		end

		states[spellId] = {
			show = true,
			changed = true,
			progressType = "timed",
			duration = cooldown,
			name = name,
			expirationTime = GetTime() + cooldown,
			icon = icon,
			autoHide = true,
			interruptable = false,
			aoe = false,
			stoppable = false,
			isBossBar = true,
		}

		return true
	elseif event == "XEPHUI_BigWigs_StartNameplate" then
		local id, eventName, bossMod, guid, spellId, cooldown = ...

		if id ~= aura_env.id then
			return false
		end

		local spell = aura_env.spells[spellId]

		if not spell then
			return false
		end

		if cooldown > 10 then
			local diff = cooldown - 10

			print(event, "queueing " .. spell.name .. " for " .. diff)

			table.insert(
				aura_env.timers,
				C_Timer.NewTimer(diff, function()
					WeakAuras.ScanEvents("BWSPELLS_ADD", id, eventName, bossMod, guid, spellId, 10)
				end)
			)

			return false
		end

		local key = guid .. spellId

		print(event, "instantly showing " .. spell.name)

		local nextState = {
			show = true,
			changed = true,
			progressType = "timed",
			duration = cooldown,
			name = spell.name,
			expirationTime = cooldown + GetTime(),
			icon = spell.icon,
			autoHide = true,
			guid = guid,
			interruptable = spell.interruptable,
			aoe = spell.aoe,
			stoppable = spell.stoppable,
			glowBelow = spell.glowBelow,
			isBossBar = false,
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
	elseif event == "XEPHUI_BigWigs_StopNameplate" then
		local id, _, _, guid = ...

		if id ~= aura_env.id then
			return false
		end

		local changed = false

		for _, state in pairs(states) do
			if state.show and state.guid == guid then
				state.show = false
				state.changed = true
				changed = true
			end
		end

		if guid then
			aura_env.unitsByGuid[guid] = nil
		end

		return changed
	elseif
		event == "XEPHUI_BigWigs_OnBossDisable"
		or event == "XEPHUI_BigWigs_OnBossWipe"
		or event == "XEPHUI_BigWigs_StopBars"
	then
		local id = ...

		if id ~= aura_env.id then
			return false
		end

		local changed = false

		for _, state in pairs(states) do
			if state.isBossBar and state.show then
				state.show = false
				state.changed = true
				changed = true
			end
		end

		return changed
	end

	-- if event == "BWSPELLS_ADD_BAR" then
	-- 	local id, eventName, bossMod, spellId, name, cooldown, icon = ...

	-- 	if id ~= aura_env.id then
	-- 		return false
	-- 	end

	-- 	if cooldown > 10 then
	-- 		local diff = cooldown - 10

	-- 		table.insert(
	-- 			aura_env.timers,
	-- 			C_Timer.NewTimer(diff, function()
	-- 				WeakAuras.ScanEvents("BWSPELLS_ADD_BAR", id, eventName, bossMod, spellId, name, 10, icon)
	-- 			end)
	-- 		)
	-- 		return false
	-- 	end

	-- 	states[spellId] = {
	-- 		show = true,
	-- 		changed = true,
	-- 		progressType = "timed",
	-- 		duration = cooldown,
	-- 		name = name,
	-- 		expirationTime = GetTime() + cooldown,
	-- 		icon = icon,
	-- 		autoHide = true,
	-- 		interruptable = false,
	-- 		aoe = false,
	-- 		stoppable = false,
	-- 		isBossBar = true,
	-- 	}

	-- 	return true
	-- end

	-- if event == "BWSPELLS_REMOVE_BAR" then
	-- 	local id = ...

	-- 	if id ~= aura_env.id then
	-- 		return false
	-- 	end

	-- 	for _, timer in pairs(aura_env.timers) do
	-- 		timer:Cancel()
	-- 	end

	-- 	table.wipe(aura_env.timers)

	-- 	return false
	-- end

	-- if event == "BWSPELLS_ADD" then
	-- 	local id, eventName, bossMod, guid, spellId, cd = ...

	-- 	if id ~= aura_env.id then
	-- 		return false
	-- 	end

	-- 	local spell = aura_env.spells[spellId]

	-- 	if not spell then
	-- 		return false
	-- 	end

	-- 	if cd > 10 then
	-- 		local diff = cd - 10

	-- 		print("queueing " .. spell.name .. " for " .. diff)

	-- 		table.insert(
	-- 			aura_env.timers,
	-- 			C_Timer.NewTimer(diff, function()
	-- 				WeakAuras.ScanEvents("BWSPELLS_ADD", id, eventName, bossMod, guid, spellId, 10)
	-- 			end)
	-- 		)

	-- 		return false
	-- 	end

	-- 	local key = guid .. spellId

	-- 	if aura_env.unitsByGuid[guid] == nil then
	-- 		aura_env.unitsByGuid[guid] = UnitTokenFromGUID(guid)

	-- 		if not aura_env.unitsByGuid[guid] then
	-- 			return false
	-- 		end
	-- 	end

	-- 	local unit = aura_env.unitsByGuid[guid]

	-- 	print("instantly showing " .. spell.name)

	-- 	local nextState = {
	-- 		show = true,
	-- 		changed = true,
	-- 		progressType = "timed",
	-- 		duration = cd,
	-- 		name = spell.name,
	-- 		expirationTime = cd + GetTime(),
	-- 		icon = spell.icon,
	-- 		autoHide = true,
	-- 		guid = guid,
	-- 		mark = GetRaidTargetIndex(unit),
	-- 		unit = unit,
	-- 		interruptable = spell.interruptable,
	-- 		aoe = spell.aoe,
	-- 		stoppable = spell.stoppable,
	-- 		glowBelow = spell.glowBelow,
	-- 		isBossBar = false,
	-- 	}

	-- 	if states[key] then
	-- 		local changed = false
	-- 		local currentState = states[key]

	-- 		for k, v in pairs(nextState) do
	-- 			if currentState[k] ~= v then
	-- 				currentState[k] = v
	-- 				changed = true
	-- 			end
	-- 		end

	-- 		return changed
	-- 	end

	-- 	states[key] = nextState

	-- 	return true
	-- end

	-- if event == "BWSPELLS_REMOVE" then
	-- 	local id, _, _, guid = ...

	-- 	if id ~= aura_env.id then
	-- 		return false
	-- 	end

	-- 	local changed = false

	-- 	for _, state in pairs(states) do
	-- 		if (state.guid == guid or state.isBossBar) and state.show then
	-- 			state.show = false
	-- 			state.changed = true
	-- 			changed = true
	-- 		end
	-- 	end

	-- 	if guid then
	-- 		aura_env.unitsByGuid[guid] = nil
	-- 	end

	-- 	return changed
	-- end

	-- if event == "BWSPELLS_DISABLE" then
	-- 	local id = ...

	-- 	if id ~= aura_env.id then
	-- 		return false
	-- 	end

	-- 	table.wipe(aura_env.unitsByGuid)

	-- 	local changed = false

	-- 	for _, state in pairs(states) do
	-- 		if state.show then
	-- 			state.show = false
	-- 			state.changed = true
	-- 			changed = true
	-- 		end
	-- 	end

	-- 	return changed
	-- end

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
				autoHide = true,
				guid = index,
				mark = math.random(0, 8),
				unit = index,
				interruptable = spell.interruptable,
				aoe = spell.aoe,
				stoppable = spell.stoppable,
				isBossBar = false,
			}
		end

		return true
	end

	return false
end
