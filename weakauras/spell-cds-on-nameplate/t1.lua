-- STATUS UNIT_THREAT_LIST_UPDATE RELOE_SPELLCD_STATE_CLEAN RELOE_SPELLCD_STATE_UPDATE UNIT_SPELLCAST_SUCCEEDED:nameplate UNIT_SPELLCAST_START:nameplate CLEU:SPELL_CAST_SUCCESS:SPELL_INTERRUPT:SPELL_CAST_START NAME_PLATE_UNIT_ADDED NAME_PLATE_UNIT_REMOVED RELOE_SPELLCD_DESYNCH

---@class SpellCdsState
---@field show boolean
---@field changed boolean
---@field guid string
---@field unit string
---@field progressType "timed" | "static"
---@field duration number
---@field spellID number
---@field spellId number
---@field expirationTime number
---@field icon number
---@field hide boolean
---@field count number
---@field autoHide boolean

---@param states SpellCdsState[]
---@param event "STATUS" | "UNIT_THREAT_LIST_UPDATE" | "RELOE_SPELLCD_STATE_CLEAN" | "RELOE_SPELLCD_STATE_UPDATE" | "UNIT_SPELLCAST_SUCCEEDED" | "UNIT_SPELLCAST_START" | "COMBAT_LOG_EVENT_UNFILTERED" | "NAME_PLATE_UNIT_ADDED" | "NAME_PLATE_UNIT_REMOVED" | "RELOE_SPELLCD_DESYNCH"
---@return boolean
function f(states, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, subEvent, _, sourceGUID, _, sourceFlags, _, destGUID, _, destinationFlags, _, castSpellId, _, _, interruptedSpellId =
			...

		if interruptedSpellId and bit.band(destinationFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) == 0 then
			aura_env.oninterrupt(interruptedSpellId, destGUID)
		elseif
			subEvent == "SPELL_CAST_SUCCESS"
			and bit.band(sourceFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) == 0
			and bit.band(sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) > 0
		then
			aura_env.onsuccess(castSpellId, sourceGUID)
		elseif
			subEvent == "SPELL_CAST_START"
			and bit.band(sourceFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) == 0
			and bit.band(sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) > 0
		then
			aura_env.onstart(castSpellId, sourceGUID)
		end

		return false
	end

	if event == "UNIT_THREAT_LIST_UPDATE" or event == "UNIT_SPELLCAST_SUCCEEDED" or event == "UNIT_SPELLCAST_START" then
		local unit, _, spellId = ...

		local guid = UnitGUID(unit)

		if not guid then
			return false
		end

		local creature, _, _, _, _, npcID = strsplit("-", guid)

		if not npcID then
			return false
		end

		if creature ~= "Creature" and creature ~= "Vehicle" then
			return false
		end

		if event == "UNIT_THREAT_LIST_UPDATE" then
			if not UnitAffectingCombat(unit) or aura_env.units[guid] then
				return false
			end

			aura_env.units[guid] = { guid = guid, time = GetTime() }

			for k, _ in pairs(aura_env.spells) do
				if
					aura_env.spells[k].oncombat
					and aura_env.spells[k].npcID
					and string.find(aura_env.spells[k].npcID, npcID)
				then
					aura_env.oncombat(k, guid)
				end
			end

			return false
		end

		if event == "UNIT_SPELLCAST_SUCCEEDED" and spellId then
			aura_env.onsuccess(spellId, guid)
			return false
		end

		if event == "UNIT_SPELLCAST_START" and spellId then
			aura_env.onstart(spellId, guid)
			return false
		end

		return false
	end

	if event == "STATUS" then
		for i = 1, 40 do
			local unit = "nameplate" .. i

			if UnitExists(unit) then
				local guid = UnitGUID(unit)

				if guid then
					aura_env.nameplates[unit] = guid
					aura_env.guids[guid] = unit
				end
			end
		end

		return false
	end

	if event == "NAME_PLATE_UNIT_ADDED" then
		local u = ...
		local updatestate = false

		if not u then
			return updatestate
		end

		local guid = UnitGUID(u)

		if not guid then
			return updatestate
		end

		aura_env.nameplates[u] = guid
		aura_env.guids[guid] = u

		for k, state in pairs(aura_env.temp) do
			if state.guid == guid then
				if UnitAffectingCombat(u) then
					state.unit = u
					state.show = true
					state.changed = true
					states[k] = state
					aura_env.temp[k] = nil
					updatestate = true
				else
					aura_env.units[guid] = nil
					states[k] = nil
					aura_env.temp[k] = nil
					updatestate = true
				end
			end
		end

		return updatestate
	end

	if event == "NAME_PLATE_UNIT_REMOVED" then
		local u = ...
		local updatestate = false

		if not u then
			return updatestate
		end

		local guid = UnitGUID(u)

		if not guid then
			return updatestate
		end

		aura_env.nameplates[u] = nil
		aura_env.guids[guid] = nil

		for k, state in pairs(states) do
			if state.guid == guid then
				aura_env.temp[k] = state
				state.show = false
				state.changed = true
				updatestate = true
			end
		end

		return updatestate
	end

	if event == "RELOE_SPELLCD_DESYNCH" then
		local spell, spellID, guid, desynch, id = ...

		if aura_env.id ~= id then
			return false
		end

		local now = GetTime()
		for _, v in pairs(states) do
			if v.spellID == spellID and v.guid ~= guid and now >= v.expirationTime - desynch then
				WeakAuras.ScanEvents(
					"RELOE_SPELLCD_STATE_UPDATE",
					spell,
					v.guid,
					spellID,
					desynch,
					false,
					false,
					0,
					v.guid .. spellID
				)
			end
		end
		for _, v in pairs(aura_env.temp) do
			if v.spellID == spellID and v.guid ~= guid and now >= v.expirationTime - desynch then
				v.duration = desynch
				v.expirationTime = GetTime() + desynch
			end
		end

		return false
	end

	if event == "RELOE_SPELLCD_STATE_CLEAN" then
		local key, expires, id = ...

		if aura_env.id ~= id then
			return false
		end

		if
			(states[key] and states[key].expirationTime == expires and states[key].expirationTime < GetTime())
			or (aura_env.temp[key] and aura_env.temp[key].expirationTime < GetTime())
		then
			states[key] = nil
			aura_env.temp[key] = nil
			return true
		end

		return false
	end

	if event == "RELOE_SPELLCD_STATE_UPDATE" then
		local spell, guid, spellID, duration, combat, type, count, key, id = ...

		if aura_env.id ~= id then
			return false
		end

		if not spell or not duration then
			return false
		end

		local spellInfoFn = C_Spell.GetSpellInfo or GetSpellInfo

		local current = GetTime()
		local icon = select(3, spellInfoFn(spell.overwrite ~= 0 and spell.overwrite or spellID))

		if
			(
				(combat and not states[key])
				or not aura_env.last[guid]
				or current > aura_env.last[guid][1]
				or icon ~= aura_env.last[guid][2]
			) or spellID ~= aura_env.last[guid][3]
		then
			if duration <= 0 then
				states[key] = nil
				aura_env.temp[key] = nil
				return true
			end

			local updatestate = false

			local data = {
				show = true,
				changed = true,
				progressType = "timed",
				duration = duration,
				spellID = spellID,
				expirationTime = GetTime() + duration,
				icon = icon,
				hide = spell.hide,
				autoHide = spell.hide == 0 or spell.loop,
				guid = guid,
				count = count,
				unit = aura_env.guids[guid],
				spellId = spellID,
			}

			aura_env.last[guid] = { current, icon, spellID }

			if aura_env.guids[guid] then
				states[key] = data
				updatestate = true
			else
				aura_env.temp[key] = data
			end

			if spell.loop and not combat then
				local aura_env = aura_env

				C_Timer.After(duration, function()
					if aura_env.guids[guid] then
						WeakAuras.ScanEvents(
							"RELOE_SPELLCD_STATE_UPDATE",
							spell,
							guid,
							spellID,
							duration,
							combat,
							type,
							count,
							key
						)
					end
				end)
			end

			return updatestate
		end

		return false
	end

	return false
end
