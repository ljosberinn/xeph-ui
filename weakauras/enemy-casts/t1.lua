---@param event "STATUS"|"OPTIONS"|"UNIT_SPELLCAST_START"|"UNIT_SPELLCAST_CHANNEL_START"|"UNIT_SPELLCAST_FAILED"|"UNIT_SPELLCAST_FAILED_QUIET"|"UNIT_SPELLCAST_CHANNEL_STOP"|"XEPHUI_SPELL_TEST"
function f(states, event, ...)
	local unit, castGUID, spellId
	if event == "XEPHUI_SPELL_TEST" then
		local kind, testUnit, testCastGuid, testSpellId = ...
		event = kind == "CAST" and "UNIT_SPELLCAST_START" or "UNIT_SPELLCAST_CHANNEL_START"
		unit = testUnit
		castGUID = testCastGuid
		spellId = testSpellId

		-- /run WeakAuras.ScanEvents("XEPHUI_SPELL_TEST", "CAST", "test", 1, 431304)
	else
		unit, castGUID, spellId = ...
	end

	if not unit then
		return false
	end

	local castTime = aura_env.spells[spellId]

	if castTime == nil then
		return false
	end

	if not castGUID then
		castGUID = unit .. "|" .. spellId
	end

	if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" or event == "XEPHUI_SPELL_TEST" then
		local spellName, spellIcon

		if event == "UNIT_SPELLCAST_CHANNEL_START" then
			local name, _, icon = UnitChannelInfo(unit)
			spellName = name
			spellIcon = icon
		elseif event == "UNIT_SPELLCAST_START" then
			local info = C_Spell.GetSpellInfo(spellId)
			spellName = info.name
			spellIcon = info.iconID
		end

		states[castGUID] = {
			show = true,
			changed = true,
			icon = spellIcon,
			unit = unit,
			autoHide = true,
			duration = castTime,
			expirationTime = GetTime() + castTime,
			progressType = "timed",
			spellId = spellId,
			name = spellName,
		}

		return true
	end

	if
		event == "UNIT_SPELLCAST_FAILED"
		or event == "UNIT_SPELLCAST_FAILED_QUIET"
		or event == "UNIT_SPELLCAST_CHANNEL_STOP"
	then
		if states[castGUID] == nil or states[castGUID].show == false then
			return false
		end

		states[castGUID].show = false
		states[castGUID].changed = true

		return true
	end

	return false
end
