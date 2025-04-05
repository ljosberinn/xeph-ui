local ignorelist = {
	[75] = true, --Auto Shot
	[5374] = true, -- Mutilate
	[7268] = true, -- Arcane Missiles
	[27576] = true, -- Mutilate
	[32175] = true, -- Stormstrike
	[32176] = true, -- Stormstrike (Off-Hand)
	[50622] = true, -- Bladestorm
	[52174] = true, -- Heroic Leap
	[57794] = true, -- Heroic Leap
	[61391] = true, -- Typhoon
	[84721] = true, -- Frozen Orb
	[85384] = true, -- Raging Blow
	[88263] = true, -- Hammer of the Righteous
	[96103] = true, -- Raging Blow
	[102794] = true, -- Ursol's Vortex
	[107270] = true, -- Spinning Crane Kick
	[110745] = true, -- Divine Star
	[114089] = true, -- Windlash
	[114093] = true, -- Windlash Off-Hand
	[115357] = true, -- Windstrike
	[115360] = true, -- Windstrike Off-Hand
	[115464] = true, -- Healing Sphere
	[120692] = true, -- Halo
	[120696] = true, -- Halo
	[121473] = true, -- Shadow Blade
	[121474] = true, -- Shadow Blade Off-hand
	[122128] = true, -- Divine Star
	[127797] = true, -- Ursol's Vortex
	[132951] = true, -- Flare
	[135299] = true, -- Tar Trap
	[184707] = true, -- Rampage
	[184709] = true, -- Rampage
	[198928] = true, -- Cinderstorm
	[199672] = true, -- Rupture
	[201363] = true, -- Rampage
	[201364] = true, -- Rampage
	[204255] = true, -- Soul Fragments
	[213241] = true, -- Felblade
	[213243] = true, -- Felblade
	[218617] = true, -- Rampage
	[225919] = true, -- Fracture
	[225921] = true, -- Fracture
	[228354] = true, -- Flurry
	[228537] = true, -- Shattered Souls
	[228597] = true, -- Frostbolt
	[272790] = true, -- Frenzy; BM hunter buff
	[276245] = true, -- Env; envenom buff
	[346665] = true, -- Throw Glaive
	[361195] = true, -- Verdant Embrace friendly heal
	[361509] = true, -- Living Flame friendly heal
	[367230] = true, -- Spiritbloom
	[370966] = true, -- The Hunt Impact (DH Class Tree Talent)
	[383313] = true, -- Abomination Limb periodical
	[385060] = true, -- Odyn's Fury
	[385061] = true, -- Odyn's Fury
	[385062] = true, -- Odyn's Fury
	[385954] = true, -- Shield Charge
	[408385] = true, -- Crusading Strikes
	[429826] = true, -- Hammer of Light
	[431398] = true, -- Empyrean Hammer
	[434144] = true, -- Infliction of Sorrow fake cast
	[441426] = true, -- Exterminate cleave
	[456640] = true, -- Consuming Fire fake cast
}

for _, spell in pairs(aura_env.config.ignorelist) do
	ignorelist[spell.id] = true
end

aura_env.spellcasts = 0

local isRogue = false
-- in cata, Envenom does not send cast events. instead, we use the aura
-- applying/being refreshed as indicator of the cast.
-- additionally, combo points updates are sent in a different order
local isCataclysm = WOW_PROJECT_CATACLYSM_CLASSIC and WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC or false
local isEvoker = false

local lastComboPoints = 0
local currentComboPoints = 0

local empowers = {}
local rogueSpenders = {}

local function getComboPoints()
	return UnitPower("player", Enum.PowerType.ComboPoints)
end

---@param spellId number
---@return string, number, number
local function getSpellMeta(spellId)
	if C_Spell.GetSpellInfo then
		local info = C_Spell.GetSpellInfo(spellId)
		if not info.icon then
			info.icon = C_Spell.GetSpellTexture(spellId)
		end

		return info.name, info.icon, info.castTime
	end

	local name, _, icon, castTime = GetSpellInfo(spellId)
	return name, icon, castTime
end

local id = select(3, C_PlayerInfo.GetClass({ unit = "player" }))

if id == 13 then
	isEvoker = true

	empowers = {
		[357208] = 3, -- FB
		[382266] = 4, -- FB font
		[359073] = 3, -- ES
		[382411] = 4, -- ES font
		[396286] = 3, -- Upheaval
		[408092] = 4, -- Upheaval font
		[355936] = 3, -- Dream Breath
		[382614] = 4, -- Dream Breath font
		[367226] = 3, -- Spiritbloom
		[382731] = 4, -- Spiritbloom font
	}
elseif id == 4 then
	isRogue = true
	currentComboPoints = getComboPoints()
	lastComboPoints = currentComboPoints

	rogueSpenders = {
		-- common
		[1943] = true, -- rupture
		[315496] = true, -- slice and dice
		[5171] = true, -- slice and dice classic
		[408] = true, -- kidney shot
		-- assa
		[32645] = true, -- envenom
		[121411] = true, -- crimson tempest
		-- sub
		[196819] = true, -- eviscerate
		[280719] = true, -- secret technique
		[319175] = true, -- black powder
		-- outlaw
		[2098] = true, -- dispatch
		[315341] = true, -- between the eyes
	}
end

--- @type table<string, boolean>
local unknownGuidIsMyPet = {}

--- @param guid string
--- @param sourceFlags number
--- @return boolean
local function isMyPet(guid, sourceFlags)
	if unknownGuidIsMyPet[guid] == nil then
		unknownGuidIsMyPet[guid] = CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_MY_PET)
	end

	return unknownGuidIsMyPet[guid]
end

--- @param guid string
--- @param sourceFlags number
--- @return boolean
local function isBasicallyMe(guid, sourceFlags)
	if guid == WeakAuras.myGUID then
		return true
	end

	if aura_env.config.petActions then
		return isMyPet(guid, sourceFlags)
	end

	return false
end

--- @param guid string
--- @return boolean
local function isPet(guid)
	return aura_env.config.petActions and unknownGuidIsMyPet[guid] == true or false
end

---@param states table<number, GCDHistoryState>
---@return boolean
local function OnPlayerDeath(states, ...)
	local hasChanges = false
	local now = GetTime()

	for _, state in pairs(states) do
		if state.paused then
			hasChanges = true
			state.paused = false
			state.changed = true
			state.desaturated = false
			state.remaining = now - state.start
		end
	end

	return hasChanges
end

---@param states table<number, GCDHistoryState>
---@return boolean
local function OnUnitSpellcastSucceeded(states, ...)
	if not isEvoker then
		return false
	end

	local unit, _, spellId = ...

	if unit ~= "player" or not spellId or empowers[spellId] == nil then
		return false
	end

	local previousCast = states[aura_env.spellcasts - 1]

	if previousCast ~= nil and previousCast.spellId == spellId then
		return false
	end

	local now = GetTime()
	local name, icon = getSpellMeta(spellId)

	-- unpause everything paused
	for _, state in pairs(states) do
		if state.show and state.paused then
			state.paused = false
			state.changed = true
			state.desaturated = false
			state.remaining = now - state.start
		end
	end

	local specialNumber = empowers[spellId]

	states[aura_env.spellcasts] = {
		show = true,
		changed = true,
		name = name,
		icon = icon,
		progressType = "timed",
		duration = aura_env.config.general.duration,
		expirationTime = now + aura_env.config.general.duration,
		autoHide = true,
		spellId = spellId,
		paused = false,
		start = now,
		desaturated = false,
		specialNumber = specialNumber,
		interrupted = false,
		isPet = false,
	}

	aura_env.spellcasts = aura_env.spellcasts + 1

	return true
end

---@param states table<number, GCDHistoryState>
---@return boolean
local function OnUnitSpellcastChannelStart(states, ...)
	local unit, _, spellId = ...

	if unit ~= "player" or not spellId then
		return false
	end

	for _, state in pairs(states) do
		-- pause everything that isn't already paused
		if state and state.show then
			if not state.paused then
				state.paused = true
				state.changed = true
			end

			-- chain channeling by eg skipping ticks of Disintegrate leaves the previous cast still desaturated, so correct this here
			if state.desaturated then
				state.desaturated = false
				state.changed = true
			end
		end
	end

	local _, _, _, channelStartTime, channelEndTime = UnitChannelInfo("player")
	local castTime = channelEndTime - channelStartTime
	local castTimeInSeconds = castTime / 1000
	local name, icon = getSpellMeta(spellId)

	local now = GetTime()
	local duration = aura_env.config.general.duration + castTimeInSeconds

	states[aura_env.spellcasts] = {
		show = true,
		changed = true,
		name = name,
		icon = icon,
		progressType = "timed",
		duration = duration,
		expirationTime = now + duration,
		autoHide = true,
		spellId = spellId,
		paused = true,
		start = now,
		desaturated = true,
		specialNumber = 0,
		interrupted = false,
		isPet = false,
	}

	aura_env.spellcasts = aura_env.spellcasts + 1

	return true
end

---@param states table<number, GCDHistoryState>
---@return boolean
local function OnUnitSpellcastChannelStop(states, ...)
	local unit, _, spellId = ...

	if unit ~= "player" or not spellId then
		return false
	end

	local previousIndex = aura_env.spellcasts - 1
	local previousCast = states[previousIndex]

	if not previousCast then
		return false
	end

	local now = GetTime()

	-- unpause everything paused
	for index, state in pairs(states) do
		if state.show and state.paused and index ~= previousIndex then
			state.paused = false
			state.changed = true
			state.desaturated = false
			state.remaining = now - state.start

			if index == previousIndex then
				state.interrupted = true
			end
		end
	end

	previousCast.changed = true
	previousCast.paused = false
	previousCast.desaturated = false
	-- initial duration is based on max channel, but we don't always fully channel
	previousCast.duration = aura_env.config.general.duration + GetTime() - previousCast.start
	previousCast.expirationTime = previousCast.start + previousCast.duration

	return true
end

---@param states table<number, GCDHistoryState>
---@return boolean
local function OnCombatLogEventUnfiltered(states, ...)
	local _, subEvent, _, sourceGUID, _, sourceFlags, _, _, _, _, _, spellId, _, _, stage = ...
	--- @cast subEvent "SPELL_EMPOWER_START" | "SPELL_EMPOWER_INTERRUPT" | "SPELL_EMPOWER_END" | "SPELL_CAST_START" | "SPELL_CAST_SUCCESS" | "SPELL_CAST_FAILED"
	--- @cast sourceGUID string
	--- @cast spellId number
	--- @cast stage number

	if not subEvent or ignorelist[spellId] ~= nil or not isBasicallyMe(sourceGUID, sourceFlags) then
		return false
	end

	if subEvent == "SPELL_AURA_APPLIED" or subEvent == "SPELL_AURA_REFRESH" then
		if not isCataclysm or spellId ~= 32645 then
			return false
		end

		local name, icon = getSpellMeta(spellId)
		local now = GetTime()

		states[aura_env.spellcasts] = {
			show = true,
			changed = true,
			name = name,
			icon = icon,
			progressType = "timed",
			duration = aura_env.config.general.duration,
			expirationTime = now + aura_env.config.general.duration,
			autoHide = true,
			spellId = spellId,
			paused = false,
			start = now,
			desaturated = false,
			specialNumber = 0,
			interrupted = false,
			isPet = false,
		}

		aura_env.spellcasts = aura_env.spellcasts + 1

		return true
	elseif subEvent == "SPELL_PERIODIC_DAMAGE" then
		-- disintegrate
		if not isEvoker or spellId ~= 356995 then
			return false
		end

		local previousCast = states[aura_env.spellcasts - 1]

		if not previousCast then
			return false
		end

		local now = GetTime()

		if previousCast.lastTick ~= nil and now - previousCast.lastTick < 0.25 then
			return false
		end

		previousCast.lastTick = now
		previousCast.specialNumber = previousCast.specialNumber + 1
		previousCast.changed = true

		return true
	elseif subEvent == "SPELL_CAST_START" then
		local now = GetTime()
		local name, icon, castTime = getSpellMeta(spellId)
		local paused = false

		if castTime == 0 then
			local _, _, _, channelStartTime, channelEndTime = UnitChannelInfo("player")

			if channelStartTime ~= nil then
				castTime = channelEndTime - channelStartTime
			end
		end

		local castTimeInSeconds = castTime / 1000
		local duration = aura_env.config.general.duration + castTimeInSeconds

		if castTime > 0 then
			paused = true

			for _, state in pairs(states) do
				-- pause everything that isn't already paused
				if state then
					if not state.paused then
						state.paused = true
						state.changed = true
					end

					-- chain channeling by eg skipping ticks of Disintegrate leaves the previous cast still desaturated, so correct this here
					if state.desaturated then
						state.desaturated = false
						state.changed = true
					end
				end
			end
		end

		states[aura_env.spellcasts] = {
			show = true,
			changed = true,
			name = name,
			icon = icon,
			progressType = "timed",
			duration = duration,
			expirationTime = now + duration,
			autoHide = true,
			spellId = spellId,
			paused = paused,
			start = now,
			desaturated = paused,
			specialNumber = 0,
			interrupted = false,
			isPet = isPet(sourceGUID),
		}

		aura_env.spellcasts = aura_env.spellcasts + 1

		return true
	elseif subEvent == "SPELL_CAST_SUCCESS" then
		local name, icon, castTime = getSpellMeta(spellId)

		if castTime > 0 then
			local now = GetTime()
			local hasChanges = false

			local previousIndex = aura_env.spellcasts - 1
			local previousCast = states[previousIndex]

			-- revert marking item use as interrupted when trying to use an
			-- item that was already being casted
			if previousCast and previousCast.spellId == spellId and previousCast.interrupted then
				hasChanges = true
				previousCast.interrupted = false
				previousCast.changed = true
			end

			-- unpause everything paused
			for _, state in pairs(states) do
				if state.paused then
					hasChanges = true
					state.paused = false
					state.changed = true
					state.desaturated = false
					state.remaining = now - state.start
				end
			end

			return hasChanges
		end

		local channelStartTime = select(4, UnitChannelInfo("player"))

		-- channels are handled separately due to sending SPELL_CAST_SUCCESS at channel start
		if channelStartTime ~= nil then
			return false
		end

		local now = GetTime()

		-- unpause everything paused
		for _, state in pairs(states) do
			if state.show and state.paused then
				state.paused = false
				state.changed = true
				state.desaturated = false
				state.remaining = now - state.start
			end
		end

		local specialNumber = 0

		if isRogue and rogueSpenders[spellId] then
			specialNumber = isCataclysm and currentComboPoints or lastComboPoints
		end

		states[aura_env.spellcasts] = {
			show = true,
			changed = true,
			name = name,
			icon = icon,
			progressType = "timed",
			duration = aura_env.config.general.duration,
			expirationTime = now + aura_env.config.general.duration,
			autoHide = true,
			spellId = spellId,
			paused = false,
			start = now,
			desaturated = false,
			specialNumber = specialNumber,
			interrupted = false,
			isPet = isPet(sourceGUID),
		}

		aura_env.spellcasts = aura_env.spellcasts + 1

		return true
	elseif subEvent == "SPELL_CAST_FAILED" then
		local previousIndex = aura_env.spellcasts - 1
		local previousCast = states[previousIndex]

		if not previousCast or not previousCast.paused then
			return false
		end

		-- ignore spamcasting an ability you currently cannot cast
		-- for whichever reason (already casting, cd, range, line of sight, missing resources)
		if previousCast.spellId ~= spellId then
			return false
		end

		local now = GetTime()

		-- ignore spamming buttons but be sensible enough about instant aborts
		if now - previousCast.start < 0.05 then
			return false
		end

		local _, _, _, channelStartTime, _, _, _, channelSpellId = UnitChannelInfo("player")

		-- ignore spamming channels. why would you anyways?
		if channelStartTime ~= nil and channelSpellId == spellId then
			return false
		end

		local hasChanges = false

		-- unpause everything paused
		for index, state in pairs(states) do
			if state.show and state.paused then
				hasChanges = true
				state.paused = false
				state.changed = true
				state.desaturated = false
				state.remaining = now - state.start

				if index == previousIndex then
					state.interrupted = true
				end
			end
		end

		return hasChanges
	elseif subEvent == "SPELL_EMPOWER_START" then
		local now = GetTime()
		local _, _, _, channelStartTime, channelEndTime = UnitChannelInfo("player")
		local name, icon = getSpellMeta(spellId)
		local castTimeInSeconds = (channelEndTime - channelStartTime) / 1000
		local duration = aura_env.config.general.duration + castTimeInSeconds

		states[aura_env.spellcasts] = {
			show = true,
			changed = true,
			name = name,
			icon = icon,
			progressType = "timed",
			duration = duration,
			expirationTime = now + duration,
			autoHide = true,
			spellId = spellId,
			paused = true,
			start = now,
			desaturated = true,
			specialNumber = 0,
			interrupted = false,
			isPet = isPet(sourceGUID),
		}

		aura_env.spellcasts = aura_env.spellcasts + 1

		return true
	elseif subEvent == "SPELL_EMPOWER_INTERRUPT" then
		local previousCast = states[aura_env.spellcasts - 1]

		if not previousCast then
			return false
		end

		local now = GetTime()
		local previousIndex = aura_env.spellcasts - 1

		-- unpause everything paused
		for index, state in pairs(states) do
			if state.show and state.paused then
				state.paused = false
				state.changed = true
				state.desaturated = false
				state.remaining = now - state.start

				if index == previousIndex then
					state.interrupted = true
				end
			end
		end

		return true
	elseif subEvent == "SPELL_EMPOWER_END" then
		local previousCast = states[aura_env.spellcasts - 1]

		if not previousCast then
			return false
		end

		previousCast.changed = true
		previousCast.paused = false
		previousCast.desaturated = false
		previousCast.specialNumber = stage
		-- initial duration is based on max channel, but we don't always fully empower
		previousCast.duration = aura_env.config.general.duration + GetTime() - previousCast.start
		previousCast.expirationTime = previousCast.start + previousCast.duration

		return true
	end

	return false
end

---@param states table<number, GCDHistoryState>
---@return boolean
local function OnUnitPowerUpdate(states, ...)
	if not isRogue then
		return false
	end

	local unit, powerType = ...

	if unit ~= "player" or powerType ~= "COMBO_POINTS" then
		return false
	end

	local next = getComboPoints()

	if next == currentComboPoints then
		return false
	end

	lastComboPoints = currentComboPoints
	currentComboPoints = next

	return false
end

aura_env.eventHandlers = {
	["PLAYER_DEAD"] = OnPlayerDeath,
	["UNIT_SPELLCAST_SUCCEEDED"] = OnUnitSpellcastSucceeded,
	["UNIT_SPELLCAST_CHANNEL_START"] = OnUnitSpellcastChannelStart,
	["UNIT_SPELLCAST_CHANNEL_STOP"] = OnUnitSpellcastChannelStop,
	["COMBAT_LOG_EVENT_UNFILTERED"] = OnCombatLogEventUnfiltered,
	["UNIT_POWER_UPDATE"] = OnUnitPowerUpdate,
}
