aura_env.spells = {}
aura_env.nameplates = {}
aura_env.guids = {}
aura_env.temp = {}
aura_env.units = {}
aura_env.progtime = {}
aura_env.proglast = {}
aura_env.last = {}

local function getSpellInfo(spellId)
	if C_Spell and C_Spell.GetSpellTexture then
		return C_Spell.GetSpellTexture(spellId)
	end

	return GetSpellTexture(spellId)
end

for _, v in ipairs(aura_env.config.spells) do
	if v.spellID ~= 0 and v.active then
		aura_env.spells[v.spellID] = {
			active = v.active,
			icon = select(3, getSpellInfo(v.spellID)),
			duration = v.duration,
			intduration = v.intduration,
			onstart = v.casttype == 1,
			onsuccess = v.casttype == 2,
			tank = v.tank,
			heal = v.heal,
			mdps = v.mdps,
			rdps = v.rdps,
			hide = v.hideafter,
			overwrite = v.overwrite,
			npcID = v.npcID,
			oncombat = v.oncombat,
			combattimer = v.combattimer,
			loop = v.loop,
			progressive = v.progressive,
			repeating = v.repeating,
			other = 0,
			npcIDoffset = v.npcIDoffset,
			offsetnum = v.offsetnum,
			offset = 0,
			desynch = v.desynch,
		}

		if v.npcIDoffset ~= "" and v.offsetnum ~= "" then
			aura_env.spells[v.spellID].offset = {}
			local nilcheck, i = true, 1
			while nilcheck do
				local timer = select(i, strsplit(" ", v.offsetnum))
				timer = tonumber(timer)
				local npcID = select(i, strsplit(" ", v.npcIDoffset))
				if npcID then
					aura_env.spells[v.spellID].offset[npcID] = timer
					if not aura_env.spells[v.spellID].offset[npcID] then
						nilcheck = false
						aura_env.spells[v.spellID].offset[npcID] = nil
					end
				else
					nilcheck = false
				end
				i = i + 1
			end
		end

		if v.spelltrigger ~= "0" and v.spelltrigger ~= "" then
			aura_env.spells[v.spellID].other = {}
			local nilcheck, i = true, 1
			while nilcheck do
				local timer = select(i, strsplit(" ", v.spelltimer))
				timer = tonumber(timer)
				local sid = select(i, strsplit(" ", v.spelltrigger)) or 0
				sid = tonumber(sid)
				aura_env.spells[v.spellID].other[sid] = timer
				if not aura_env.spells[v.spellID].other[sid] then
					nilcheck = false
					aura_env.spells[v.spellID].other[sid] = nil
				end
				i = i + 1
			end
		end

		if v.progressive ~= "0" and v.progressive ~= "" then
			aura_env.spells[v.spellID].progressive = {}
			local nilcheck, i = true, 1
			while nilcheck do
				local timer = select(i, strsplit(" ", v.progressive))
				timer = tonumber(timer)
				aura_env.spells[v.spellID].progressive[i] = timer
				if not aura_env.spells[v.spellID].progressive[i] then
					nilcheck = false
					aura_env.spells[v.spellID].progressive[i] = nil
				end
				i = i + 1
			end
		end
	end
end

function aura_env.rolecheck(spell)
	local spec, role, pos = WeakAuras.SpecRolePositionForUnit("player")

	if role == "HEALER" and spell.heal then
		return true
	end

	if role == "TANK" and spell.tank then
		return true
	end

	if pos == "RANGED" and spell.rdps then
		return true
	end

	return (role ~= "TANK" and spell.mdps and (pos == "MELEE" or spec == 105))
end

---@param guid string
---@return boolean
function aura_env.bossunit(guid)
	for i = 1, 10 do
		local unit = "boss" .. i
		if not UnitExists(unit) then
			break
		end

		if guid == UnitGUID(unit) then
			return true
		end
	end

	return false
end

---@param spellId number
---@param guid string
function aura_env.oninterrupt(spellId, guid)
	local spell, key = aura_env.spells[spellId], guid .. spellId
	if
		spell
		and spell.intduration > 0
		and aura_env.rolecheck(spell)
		and ((not aura_env.last[key]) or GetTime() > aura_env.last[key] + 0.1)
	then
		aura_env.last[key] = GetTime()
		WeakAuras.ScanEvents(
			"RELOE_SPELLCD_STATE_UPDATE",
			spell,
			guid,
			spellId,
			spell.intduration,
			false,
			false,
			0,
			guid .. spellId,
			aura_env.id
		)
	end
end

---@param spellId number
---@param guid string
function aura_env.onstart(spellId, guid)
	local spell, key = aura_env.spells[spellId], guid .. spellId

	if not spell or not spell.onstart then
		return
	end

	local npcID = select(6, strsplit("-", guid))

	if (not aura_env.last[key]) or GetTime() > aura_env.last[key] + 0.1 then
		aura_env.last[key] = GetTime()
		local count, duration = -1, aura_env.rolecheck(spell) and spell.duration

		if type(spell.other) == "table" then
			for k, v in pairs(spell.other) do
				local spello = aura_env.spells[k] or spell
				local active = aura_env.spells[k] and aura_env.spells[k].active

				if active then
					WeakAuras.ScanEvents(
						"RELOE_SPELLCD_STATE_UPDATE",
						spello,
						guid,
						k,
						v,
						false,
						false,
						0,
						guid .. k,
						aura_env.id
					)
				end
			end
		end

		if type(spell.progressive) == "table" then
			duration, count = aura_env.getprogressivetimer(spell, duration, key)
		end

		if duration then
			duration = type(spell.offset) == "table" and spell.offset[npcID] or duration
			WeakAuras.ScanEvents(
				"RELOE_SPELLCD_STATE_UPDATE",
				spell,
				guid,
				spellId,
				duration,
				false,
				false,
				count + 1,
				key,
				aura_env.id
			)
		end

		if spell.desynch ~= 0 then
			WeakAuras.ScanEvents("RELOE_SPELLCD_DESYNCH", spell, spell.desynch, aura_env.id)
		end
	end
end

-- spell_cast_success / unit_spellcast_succeeded
---@param spellId number
---@param guid string
function aura_env.onsuccess(spellId, guid)
	local spell, key = aura_env.spells[spellId], guid .. spellId

	if not spell or not spell.onsuccess then
		return
	end

	local npcID = select(6, strsplit("-", guid))

	if (not aura_env.last[key]) or GetTime() > aura_env.last[key] + 0.1 then
		aura_env.last[key] = GetTime()

		local count, duration = -1, aura_env.rolecheck(spell) and aura_env.spells[spellId].duration

		if type(spell.other) == "table" then
			for k, v in pairs(spell.other) do
				local spello = aura_env.spells[k] or spell
				local active = aura_env.spells[k] and aura_env.spells[k].active

				if active then
					WeakAuras.ScanEvents(
						"RELOE_SPELLCD_STATE_UPDATE",
						spello,
						guid,
						k,
						v,
						false,
						false,
						0,
						guid .. k,
						aura_env.id
					)
				end
			end
		end

		if duration and type(spell.progressive) == "table" then
			duration, count = aura_env.getprogressivetimer(spell, duration, key)
		end

		if duration then
			duration = type(spell.offset) == "table" and spell.offset[npcID] or duration
			WeakAuras.ScanEvents(
				"RELOE_SPELLCD_STATE_UPDATE",
				spell,
				guid,
				spellId,
				duration,
				false,
				true,
				count + 1,
				key,
				aura_env.id
			)
		end
	end
end

---@param spellId number
---@param guid string
function aura_env.oncombat(spellId, guid)
	local spell = aura_env.spells[spellId]

	if not spell or not spell.oncombat or not aura_env.rolecheck(spell) then
		return
	end

	WeakAuras.ScanEvents(
		"RELOE_SPELLCD_STATE_UPDATE",
		spell,
		guid,
		spellId,
		spell.combattimer,
		true,
		spell.onsuccess,
		0,
		guid .. spellId,
		aura_env.id
	)
end

---@param spell
---@param duration number
---@param key string
---@return number, number
function aura_env.getprogressivetimer(spell, duration, key)
	if not aura_env.progtime[key] then
		aura_env.progtime[key] = 1
	else
		aura_env.progtime[key] = aura_env.progtime[key] + 1
	end

	local timer = -1

	if aura_env.progtime[key] > #spell.progressive then
		if spell.repeating then
			aura_env.progtime[key] = 1
			timer = spell.progressive[1]
		else
			for i = 1, #spell.progressive do
				timer = (spell.progressive[i] and (spell.progressive[i] < timer or timer == 0) and spell.progressive[i])
					or timer
			end
		end
	else
		timer = spell.progressive[aura_env.progtime[key]]
	end

	if timer and timer ~= -1 then
		return tonumber(timer), aura_env.progtime[key]
	end

	return duration, -1
end
