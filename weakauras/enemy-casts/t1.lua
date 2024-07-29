---@param event "STATUS"|"OPTIONS"|"UNIT_SPELLCAST_START"|"UNIT_SPELLCAST_CHANNEL_START"|"UNIT_SPELLCAST_FAILED"|"UNIT_SPELLCAST_FAILED_QUIET"|"UNIT_SPELLCAST_CHANNEL_STOP"|"COMBAT_LOG_EVENT_UNFILTERED"
function f(states, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local subEvent = select(2, event)

		if subEvent == "SPELL_CAST_START" then
			-- do sourceFlags comparison for hostility
		end

		return false
	end

	local unit, castGUID, spellId = ...

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

	if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" then
		local spellName, spellIcon

		if event == "UNIT_SPELLCAST_CHANNEL_START" then
			local name, _, icon = UnitChannelInfo(unit)
			spellName = name
			spellIcon = icon
		elseif event == "UNIT_SPELLCAST_START" then
			local name = nil
			local icon = nil
			if C_Spell.GetSpellInfo then
				local info = C_Spell.GetSpellInfo(spellId)
				name = info.name
				icon = info.icon
			else
				local n, _, i = GetSpellInfo(spellId)
				name = n
				icon = i
			end

			spellName = name
			spellIcon = icon
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
