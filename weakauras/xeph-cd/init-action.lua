--[[
- add active ability support in general (which includes aura & summon)
  - listen on cast
    - special case empowers
  - dont forget to cleanup if unit dies

  - categorize spells
    - interrupts
	- aoe stops
	- defensives
	- offensives
  - add potion support
    - combat
	- healthstone
	- defensive/health potion	
]]
--

aura_env.CUSTOM_EVENT_CD_READY = "XephCD_CD_READY"
aura_env.CUSTOM_EVENT_AURA_EXPIRED = "XephCD_AURA_EXPIRED"
aura_env.scheduledCooldownEvents = {}
aura_env.scheduledAuraEvents = {}

---@type table<string, number>
local EnumClass = {
	Warrior = 1,
	Hunter = 2,
	Mage = 3,
	Rogue = 4,
	Priest = 5,
	Warlock = 6,
	Paladin = 7,
	Druid = 8,
	Shaman = 9,
	Monk = 10,
	DemonHunter = 11,
	DeathKnight = 12,
	Evoker = 13,
}

---@type table<string, number>
local EnumSpec = {
	MageArcane = 62,
	MageFire = 63,
	MageFrost = 64,
	PaladinHoly = 65,
	PaladinProtection = 66,
	PaladinRetribution = 70,
	WarriorArms = 71,
	WarriorFury = 72,
	WarriorProtection = 73,
	DruidBalance = 102,
	DruidFeral = 103,
	DruidGuardian = 104,
	DruidRestoration = 105,
	DeathknightBlood = 250,
	DeathknightFrost = 251,
	DeathknightUnholy = 252,
	HunterBeastmastery = 253,
	HunterMarksmanship = 254,
	HunterSurvival = 255,
	PriestDiscipline = 256,
	PriestHoly = 257,
	PriestShadow = 258,
	RogueAssassination = 259,
	RogueOutlaw = 260,
	RogueSubtlety = 261,
	ShamanElemental = 262,
	ShamanEnhancement = 263,
	ShamanRestoration = 264,
	WarlockAffliction = 265,
	WarlockDemonology = 266,
	WarlockDestruction = 267,
	MonkBrewmaster = 268,
	MonkWindwalker = 269,
	MonkMistweaver = 270,
	DemonhunterHavoc = 577,
	DemonhunterVengeance = 581,
	EvokerDevastation = 1467,
	EvokerPreservation = 1468,
	EvokerAugmentation = 1473,
}

local specIdToClassId = {
	[EnumSpec.MageArcane] = EnumClass.Mage,
	[EnumSpec.MageFire] = EnumClass.Mage,
	[EnumSpec.MageFrost] = EnumClass.Mage,
	[EnumSpec.PaladinHoly] = EnumClass.Paladin,
	[EnumSpec.PaladinProtection] = EnumClass.Paladin,
	[EnumSpec.PaladinRetribution] = EnumClass.Paladin,
	[EnumSpec.WarriorArms] = EnumClass.Warrior,
	[EnumSpec.WarriorFury] = EnumClass.Warrior,
	[EnumSpec.WarriorProtection] = EnumClass.Warrior,
	[EnumSpec.DruidBalance] = EnumClass.Druid,
	[EnumSpec.DruidFeral] = EnumClass.Druid,
	[EnumSpec.DruidGuardian] = EnumClass.Druid,
	[EnumSpec.DruidRestoration] = EnumClass.Druid,
	[EnumSpec.DeathknightBlood] = EnumClass.DeathKnight,
	[EnumSpec.DeathknightFrost] = EnumClass.DeathKnight,
	[EnumSpec.DeathknightUnholy] = EnumClass.DeathKnight,
	[EnumSpec.HunterBeastmastery] = EnumClass.Hunter,
	[EnumSpec.HunterMarksmanship] = EnumClass.Hunter,
	[EnumSpec.HunterSurvival] = EnumClass.Hunter,
	[EnumSpec.PriestDiscipline] = EnumClass.Priest,
	[EnumSpec.PriestHoly] = EnumClass.Priest,
	[EnumSpec.PriestShadow] = EnumClass.Priest,
	[EnumSpec.RogueAssassination] = EnumClass.Rogue,
	[EnumSpec.RogueOutlaw] = EnumClass.Rogue,
	[EnumSpec.RogueSubtlety] = EnumClass.Rogue,
	[EnumSpec.ShamanElemental] = EnumClass.Shaman,
	[EnumSpec.ShamanEnhancement] = EnumClass.Shaman,
	[EnumSpec.ShamanRestoration] = EnumClass.Shaman,
	[EnumSpec.WarlockAffliction] = EnumClass.Warlock,
	[EnumSpec.WarlockDemonology] = EnumClass.Warlock,
	[EnumSpec.WarlockDestruction] = EnumClass.Warlock,
	[EnumSpec.MonkBrewmaster] = EnumClass.Monk,
	[EnumSpec.MonkWindwalker] = EnumClass.Monk,
	[EnumSpec.MonkMistweaver] = EnumClass.Monk,
	[EnumSpec.DemonhunterHavoc] = EnumClass.DemonHunter,
	[EnumSpec.DemonhunterVengeance] = EnumClass.DemonHunter,
	[EnumSpec.EvokerDevastation] = EnumClass.Evoker,
	[EnumSpec.EvokerPreservation] = EnumClass.Evoker,
	[EnumSpec.EvokerAugmentation] = EnumClass.Evoker,
}

function aura_env.log(...)
	print(aura_env.id, ...)
end

---@table<number, cbObject>
aura_env.inspect = {}

---@param unit string
function aura_env.enqueueInspect(unit)
	if unit == "player" or UnitIsUnit(unit, "player") then
		aura_env.log(format("[enqueueInspect] unit %s is myself, skipping", unit))
		return
	end

	-- offline
	if not UnitIsConnected(unit) then
		aura_env.log(format("[enqueueInspect] unit %s is offline", unit))
		return
	end

	-- phased or zoned
	if select(4, UnitPosition(unit)) ~= select(4, UnitPosition("player")) then
		aura_env.log(format("[enqueueInspect] unit %s is phased or zoned", unit))
		return
	end

	local guid = UnitGUID(unit)

	if guid == nil then
		aura_env.log(format("[enqueueInspect] could not establish guid for %s", unit))
		return
	end

	if aura_env.inspect[guid] == nil then
		aura_env.inspect[guid] = C_Timer.NewTicker(1, function()
			NotifyInspect(unit)
			print("tick", unit)
		end)

		aura_env.log(format("[enqueueInspect] enqueued inpect for %s", unit))

		NotifyInspect(unit)
	end
end

---@param configId number
---@return table<number, number>|nil ,boolean
function aura_env.getTalents(configId)
	local configInfo = C_Traits.GetConfigInfo(configId)

	if not configInfo then
		return nil, false
	end

	---@type table<number, number>
	local talentsMap = {}

	for _, treeId in ipairs(configInfo.treeIDs) do
		local nodes = C_Traits.GetTreeNodes(treeId)

		for _, treeNodeId in ipairs(nodes) do
			local treeNode = C_Traits.GetNodeInfo(configId, treeNodeId)

			if treeNode.activeEntry and treeNode.activeRank > 0 then
				local entryInfo = C_Traits.GetEntryInfo(configId, treeNode.activeEntry.entryID)

				if entryInfo.definitionID then
					local definitionInfo = C_Traits.GetDefinitionInfo(entryInfo.definitionID)

					if definitionInfo.spellID then
						talentsMap[definitionInfo.spellID] = treeNode.activeRank
					end
				end
			end
		end
	end

	return talentsMap, true
end

---@class ItemInfo
---@field name string
---@field id number
---@field cooldown number
---@field icon number

---@param unit		string
---@return table<number, ItemInfo>, boolean
function aura_env.getGear(unit)
	local gear = {}

	if not aura_env.config.includeItems then
		return gear, true
	end

	local sawAtLeastOneItem = false

	for i = INVSLOT_HEAD, INVSLOT_TABARD do
		local itemLink = GetInventoryItemLink(unit, i)

		if itemLink then
			sawAtLeastOneItem = true
			local itemId, _, _, _, itemIcon = C_Item.GetItemInfoInstant(itemLink)

			if itemId then
				local spellName, spellId = C_Item.GetItemSpell(itemLink)

				if spellName and spellId then
					local cooldown = GetSpellBaseCooldown(spellId) / 1000
					-- spells from items may have a different icon people aren't familiar with
					-- this forces us to use the item icon instead
					local usesItemIcon = i == INVSLOT_TRINKET1 or i == INVSLOT_TRINKET2

					gear[itemId] = {
						name = spellName,
						id = spellId,
						cooldown = cooldown,
						icon = usesItemIcon and itemIcon or C_Spell.GetSpellTexture(spellId),
					}
				end
			end
		end
	end

	return gear, sawAtLeastOneItem
end

--- @param specName string
--- @param icon string
--- @param className string
--- @param name string
--- @return string
function aura_env.formattedSpecIconWithName(specName, icon, className, name)
	local classColor = className and RAID_CLASS_COLORS[className] and RAID_CLASS_COLORS[className].colorStr or ""

	return format(
		"|T%s:0|t %s|c%s %s|r",
		icon or "Interface\\Icons\\INV_Misc_QuestionMark",
		name,
		classColor,
		specName or "Unknown"
	)
end

---@param unitInfo UnitInfo
---@param spellId number
local function getCooldownForSpell(unitInfo, spellId)
	local baseCooldown = GetSpellBaseCooldown(spellId)

	if baseCooldown == 0 then
		return 0
	end

	baseCooldown = baseCooldown / 1000

	if
		unitInfo.specId == EnumSpec.EvokerAugmentation
		or unitInfo.specId == EnumSpec.EvokerDevastation
		or unitInfo.specId == EnumSpec.EvokerPreservation
	then
		if spellId == 363916 then -- base cooldown for obsidian scales reports as 1
			baseCooldown = 90
		elseif spellId == 358267 then -- base cooldown for hover reports as 1
			baseCooldown = 30
		elseif spellId == 374348 then -- renewing blaze + fire within
			if unitInfo.talents[375577] == 1 then
				baseCooldown = baseCooldown - 30
			end
		elseif spellId == 368970 then -- tailswipe + clobbering sweep
			if unitInfo.talents[375443] == 1 then
				baseCooldown = baseCooldown - 45
			end
		elseif spellId == 357214 then -- wing buffet + heavy wingbeats
			if unitInfo.talents[368838] == 1 then
				baseCooldown = baseCooldown - 45
			end
		elseif spellId == 357208 then -- fire breath + font of magic interaction
			if unitInfo.talents[408083] == 1 then
				return 0
			end
		end

		-- deva & aug
		if unitInfo.specId ~= EnumSpec.EvokerPreservation then
			if spellId == 351338 then -- quell + imposing presence
				if unitInfo.talents[371016] == 1 then
					baseCooldown = baseCooldown - 20
				end
			end
		end

		-- augmentation
		if unitInfo.specId == EnumSpec.EvokerAugmentation then
			if spellId == 355913 and unitInfo.talents[414969] == 1 then -- emerald blossom has no cd with dream of spring
				return 0
			end

			if spellId == 404977 and unitInfo.talents[412713] == 1 then -- time skip becomes passive through interwoven threads
				return 0
			end

			if unitInfo.talents[412713] == 1 then -- interwoven threads, must come last
				return baseCooldown * 0.9
			end
		end

		return baseCooldown
	end

	return baseCooldown
end

---@param unitInfo UnitInfo
---@return number[]
local function getBaselineAbilities(unitInfo)
	local classId = specIdToClassId[unitInfo.specId]

	if classId == EnumClass.Warrior then
		return {}
	end

	if classId == EnumClass.Hunter then
		return {}
	end

	if classId == EnumClass.Mage then
		return {}
	end

	if classId == EnumClass.Rogue then
		return {}
	end

	if classId == EnumClass.Priest then
		return {}
	end

	if classId == EnumClass.Warlock then
		return {}
	end

	if classId == EnumClass.Paladin then
		return {}
	end

	if classId == EnumClass.Druid then
		return {}
	end

	if classId == EnumClass.Shaman then
		return {}
	end

	if classId == EnumClass.Monk then
		return {}
	end

	if classId == EnumClass.DemonHunter then
		return {}
	end

	if classId == EnumClass.DeathKnight then
		return {}
	end

	if classId == EnumClass.Evoker then
		local abilities = {
			355913, -- Emerald Blossom
			358267, -- Hover
			364342, -- Blessing of the Bronze
			368970, -- Tail Swipe
			357214, -- Wing Buffet
			390386, -- Fury of the Aspects
		}

		table.insert(abilities, unitInfo.talents[408083] == 1 and 382266 or 357208) -- fire breath with / without font of magic

		return abilities
	end

	return {}
end

---@class UnitInfo
---@field specId number
---@field guid string
---@field unit string
---@field talents table<number, number>
---@field gear table<number, ItemInfo>

---@param unitInfo UnitInfo
---@return table<number, number>
local function getSpells(unitInfo)
	local tbl = {}

	for spellId in pairs(unitInfo.talents) do
		local cooldown = getCooldownForSpell(unitInfo, spellId)

		if cooldown > 0 and cooldown >= aura_env.config.minCd and cooldown <= aura_env.config.maxCd then
			tbl[spellId] = cooldown
		end
	end

	local baselineAbilities = getBaselineAbilities(unitInfo)

	for i = 1, #baselineAbilities do
		local abilityId = baselineAbilities[i]
		local cooldown = getCooldownForSpell(unitInfo, abilityId)

		if cooldown > 0 and cooldown >= aura_env.config.minCd and cooldown <= aura_env.config.maxCd then
			tbl[abilityId] = cooldown
		end
	end

	return tbl
end

---@param unitInfo UnitInfo
---@return table<number, number>
local function getStacksMapForUnitInfo(unitInfo)
	local tbl = {}

	if
		unitInfo.specId == EnumSpec.EvokerAugmentation
		or unitInfo.specId == EnumSpec.EvokerDevastation
		or unitInfo.specId == EnumSpec.EvokerPreservation
	then
		tbl[358267] = 2 -- hover

		if unitInfo.talents[375406] then -- obsidian bulwark
			tbl[363916] = 2 -- obsidian scales
		end
	end

	return tbl
end

---@param state XephCDState
---@param newData XephCDState
local function maybeUpdateState(state, newData)
	local changed = false

	for k, v in pairs(newData) do
		if state[k] ~= v then
			state[k] = v
			changed = true
		end
	end

	state.changed = changed
end

---@return table<number, ItemInfo>
local function getConsumables()
	if not aura_env.config.includeConsumables then
		return {}
	end

	return {
		-- Healthstone
		[5512] = {
			name = C_Item.GetItemNameByID(5512),
			id = 6262,
			cooldown = 60,
			icon = C_Spell.GetSpellTexture(6262),
		},
		-- Algari Healing Potion
		[211880] = {
			name = C_Item.GetItemNameByID(211880),
			id = 431416,
			cooldown = 300,
			icon = C_Item.GetItemIconByID(211880),
		},
		-- Combat Potion
		[191914] = {
			name = C_Item.GetItemNameByID(191914),
			id = 371028,
			cooldown = 300,
			icon = C_Item.GetItemIconByID(191914),
		},
	}
end

---@param states table<string, XephCDState>
---@param unitInfo UnitInfo
function aura_env.setupState(states, unitInfo)
	local spells = getSpells(unitInfo)
	local stacksMap = getStacksMapForUnitInfo(unitInfo)
	local consumables = getConsumables()

	for key, state in pairs(states) do
		if state.unit == unitInfo.unit then
			states[key].show = false
			states[key].changed = true
		end
	end

	for spellId, cooldown in pairs(spells) do
		local key = unitInfo.guid .. "|" .. spellId

		local aura = C_UnitAuras.GetAuraDataBySpellName(unitInfo.unit, C_Spell.GetSpellName(spellId))

		local state = {
			show = true,
			progressType = "static",
			spellId = spellId,
			unit = unitInfo.unit,
			cooldown = cooldown,
			icon = C_Spell.GetSpellTexture(spellId),
			duration = nil,
			expirationTime = nil,
			value = 1,
			total = 1,
			stacks = stacksMap[spellId],
			maxStacks = stacksMap[spellId],
			kind = "spell",
			spellName = C_Spell.GetSpellName(spellId),
			auraActive = aura ~= nil,
			auraInstanceId = aura and aura.auraInstanceID or nil,
		}

		if states[key] then
			maybeUpdateState(states[key], state)
		else
			state.changed = true
			states[key] = state
		end
	end

	for _, spellInfo in pairs(unitInfo.gear) do
		local key = unitInfo.guid .. "|" .. spellInfo.id

		local state = {
			show = true,
			progressType = "static",
			spellId = spellInfo.id,
			unit = unitInfo.unit,
			cooldown = spellInfo.cooldown,
			icon = spellInfo.icon,
			duration = nil,
			expirationTime = nil,
			value = 1,
			total = 1,
			kind = "item",
			spellName = spellInfo.name,
			auraActive = false,
			auraInstanceId = nil,
		}

		if states[key] then
			maybeUpdateState(states[key], state)
		else
			state.changed = true
			states[key] = state
		end
	end

	for _, consumable in pairs(consumables) do
		local key = unitInfo.guid .. "|" .. consumable.id

		local state = {
			show = true,
			progressType = "static",
			spellId = consumable.id,
			unit = unitInfo.unit,
			cooldown = consumable.cooldown,
			icon = consumable.icon,
			duration = nil,
			expirationTime = nil,
			value = 1,
			total = 1,
			kind = "consumable",
			spellName = consumable.name,
			auraActive = false,
			auraInstanceId = nil,
		}

		if states[key] then
			maybeUpdateState(states[key], state)
		else
			state.changed = true
			states[key] = state
		end
	end
end
