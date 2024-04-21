---@param event "STATUS"|"OPTIONS"|"UNIT_SPELLCAST_START"|"UNIT_SPELLCAST_CHANNEL_START"|"UNIT_SPELLCAST_FAILED"|"UNIT_SPELLCAST_FAILED_QUIET"|"UNIT_SPELLCAST_CHANNEL_STOP"
function (states, event, unit, castGUID, spellId)
	if not unit then
		return false
	end

	if aura_env.spells[spellId] ~= true then
		return false
	end

	if string.find(unit, "nameplate") == nil then
		return false
	end

	local spellName, spellIcon, castTime

	if not castGUID then
		castGUID = unit .. "|" .. spellId
	end

	if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" then
		if event == "UNIT_SPELLCAST_CHANNEL_START" then
			local name, _, icon, _, endTimeMs = UnitChannelInfo(unit)
			spellName = name
			spellIcon = icon
			castTime = endTimeMs / 1000 - GetTime()
            print(spellName, castTime)
		elseif event == "UNIT_SPELLCAST_START" then
			local GetSpellInfo = C_Spell.GetSpellInfo or GetSpellInfo
			spellName, _, spellIcon, castTime = GetSpellInfo(spellId)
            castTime = castTime / 1000
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
