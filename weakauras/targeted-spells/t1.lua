-- UNIT_TARGET, NAME_PLATE_UNIT_ADDED, DELAYED_UNIT_SPELLCAST_START, DELAYED_UNIT_SPELLCAST_CHANNEL_START, UNIT_SPELLCAST_START, UNIT_SPELLCAST_CHANNEL_START, XEPHUI_TARGETED_SPELLS, NAME_PLATE_UNIT_REMOVED, UNIT_SPELLCAST_STOP, UNIT_SPELLCAST_CHANNEL_STOP
---@class TargetedSpellsState
---@field show boolean
---@field changed boolean
---@field progressType "timed"
---@field duration number
---@field expirationTime number
---@field spellID number
---@field icon string
---@field autoHide true
---@field unit string

---@param states table<string, TargetedSpellsState>
---@param event "OPTIONS" | "STATUS" | "UNIT_TARGET" | "NAME_PLATE_UNIT_ADDED" | "DELAYED_UNIT_SPELLCAST_START" | "DELAYED_UNIT_SPELLCAST_CHANNEL_START" | "UNIT_SPELLCAST_START" | "UNIT_SPELLCAST_CHANNEL_START" | "XEPHUI_TARGETED_SPELLS" | "NAME_PLATE_UNIT_REMOVED" | "UNIT_SPELLCAST_STOP" | "UNIT_SPELLCAST_CHANNEL_STOP"
function f(states, event, ...)
	if
		event == "DELAYED_UNIT_SPELLCAST_START"
		or event == "DELAYED_UNIT_SPELLCAST_CHANNEL_START"
		or event == "UNIT_TARGET"
		or event == "NAME_PLATE_UNIT_ADDED"
	then
		local unit = ...

		if event == "UNIT_TARGET" and unit == "player" then
			return false
		end

		if UnitInParty(unit) or not UnitExists(unit) or not UnitIsUnit(unit .. "target", "player") then
			return false
		end

		local guid = UnitGUID(unit)

		if guid == nil then
			return false
		end

		local _, _, icon, startTime, endTime, _, _, _, spellId = UnitCastingInfo(unit)

		if not startTime or not endTime then
			_, _, icon, startTime, endTime, _, _, spellId = UnitChannelInfo(unit)
		end

		if not startTime or not endTime or not spellId or aura_env.blockList[spellId] ~= nil then
			return false
		end

		local duration = (endTime - startTime) / 1000
		local expirationTime = endTime / 1000

		if aura_env.allowList[spellId] then
			WeakAuras.ScanEvents(aura_env.customEventName, unit, guid, icon, spellId, duration, expirationTime)
			return false
		end

		local description = C_Spell.GetSpellDescription(spellId)

		if description ~= nil and description ~= "" then
			if not aura_env.descriptionImpliesDamage(description) then
				aura_env.blockList[spellId] = true
				return
			end

			aura_env.allowList[spellId] = true

			WeakAuras.ScanEvents(aura_env.customEventName, unit, guid, icon, spellId, duration, expirationTime)

			return false
		end

		local spell = Spell:CreateFromSpellID(spellId)

		if not spell or spell:IsSpellEmpty() then
			return false
		end

		local aura_env = aura_env

		spell:ContinueOnSpellLoad(function()
			local description = C_Spell.GetSpellDescription(spell.spellID)

			if not aura_env.descriptionImpliesDamage(description) then
				aura_env.blockList[spellId] = true
				return
			end

			aura_env.allowList[spellId] = true

			WeakAuras.ScanEvents(aura_env.customEventName, unit, guid, icon, spellId, duration, expirationTime)
		end)

		return false
	end

	if event == "UNIT_SPELLCAST_START" then
		local unit = ...

		C_Timer.After(aura_env.config.delay, function()
			WeakAuras.ScanEvents("DELAYED_UNIT_SPELLCAST_START", unit)
		end)

		return false
	end

	if event == "UNIT_SPELLCAST_CHANNEL_START" then
		local unit = ...

		C_Timer.After(aura_env.config.delay, function()
			WeakAuras.ScanEvents("DELAYED_UNIT_SPELLCAST_CHANNEL_START", unit)
		end)

		return false
	end

	if event == aura_env.customEventName and ... then
		local unit, guid, icon, spellId, duration, expirationTime = ...

		local nextState = {
			show = true,
			changed = true,
			progressType = "timed",
			duration = duration,
			expirationTime = expirationTime,
			spellID = spellId,
			icon = icon,
			autoHide = true,
			unit = unit,
		}

		if states[guid] then
			local changed = false

			for k, v in pairs(nextState) do
				if states[guid][k] ~= v then
					states[guid][k] = v
					changed = true
				end
			end

			return changed
		end

		states[guid] = nextState

		return true
	end

	if
		event == "NAME_PLATE_UNIT_REMOVED"
		or event == "UNIT_SPELLCAST_STOP"
		or event == "UNIT_SPELLCAST_CHANNEL_STOP"
	then
		local unit = ...
		local guid = UnitGUID(unit)

		if guid == nil then
			return false
		end

		local state = states[guid]

		if state then
			state.show = false
			state.changed = true

			return true
		end

		return false
	end

	if WeakAuras.IsOptionsOpen() then
		local dummyIds = { 294961, 1217821, 473440 }

		for _, spellId in ipairs(dummyIds) do
			states[spellId] = {
				show = true,
				changed = true,
				progressType = "timed",
				duration = 15,
				expirationTime = GetTime() + 15,
				spellID = spellId,
				icon = C_Spell.GetSpellTexture(spellId),
				autoHide = true,
				unit = "player",
			}
		end
	end

	return false
end
