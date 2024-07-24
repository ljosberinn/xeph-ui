--[[
- add active ability support in general (which includes aura & summon)
  - listen on cast
    - special case empowers
  - dont forget to cleanup if unit dies
]]
--

aura_env.CUSTOM_EVENT_CD_READY = "XephCD_CD_READY"
aura_env.CUSTOM_EVENT_AURA_EXPIRED = "XephCD_AURA_EXPIRED"
aura_env.scheduledCooldownEvents = {}
aura_env.scheduledAuraEvents = {}

---@type table<string, number[]>
local abilities = {
	[13] = {
		355913, -- Emerald Blossom
		358267, -- Hover
		364342, -- Blessing of the Bronze
		357208, -- Fire Breath without Font of Magic
		382266, -- Fire Breath with Font of Magic
		368970, -- Tail Swipe
		357214, -- Wing Buffet
	},
}

local specIdToClassId = {
	[1467] = 13,
	[1468] = 13,
	[1473] = 13, -- augmentation
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

---@param id number
---@return number
local function getSpellIcon(id)
	return C_Spell.GetSpellTexture and C_Spell.GetSpellTexture(id) or select(3, GetSpellInfo(id))
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

	for i = 0, 30 do
		local itemLink = GetInventoryItemLink(unit, i)

		if itemLink then
			local itemId, _, _, _, icon = C_Item.GetItemInfoInstant(itemLink)
			local usesItemIcon = i == INVSLOT_TRINKET1 or i == INVSLOT_TRINKET2

			if itemId then
				local spellName, spellId = C_Item.GetItemSpell(itemLink)

				if spellName and spellId then
					local cooldown = GetSpellBaseCooldown(spellId) / 1000

					gear[itemId] = {
						name = spellName,
						id = spellId,
						cooldown = cooldown,
						icon = usesItemIcon and icon or getSpellIcon(spellId),
					}
				end
			end
		end
	end

	return gear, true
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

	-- evoker
	if unitInfo.specId == 1468 or unitInfo.specId == 1473 or unitInfo.specId == 1467 then
		if spellId == 363916 then -- base cooldown for obsidian scales reports as 1
			baseCooldown = 90
		elseif spellId == 358267 then -- base cooldown for hover reports as 1
			baseCooldown = 30
		end

		if spellId == 374348 then -- renewing blaze + fire within
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
		if unitInfo.specId ~= 1468 then
			if spellId == 351338 then -- quell + imposing presence
				if unitInfo.talents[371016] == 1 then
					baseCooldown = baseCooldown - 20
				end
			end
		end

		-- augmentation
		if unitInfo.specId == 1473 then
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

	local classId = specIdToClassId[unitInfo.specId]

	if classId then
		for i = 1, #abilities[classId] do
			local abilityId = abilities[classId][i]
			local cooldown = getCooldownForSpell(unitInfo, abilityId)

			if cooldown > 0 and cooldown >= aura_env.config.minCd and cooldown <= aura_env.config.maxCd then
				tbl[abilityId] = cooldown
			end
		end
	end

	return tbl
end

---@param unitInfo UnitInfo
---@return table<number, number>
local function getStacksMapForUnitInfo(unitInfo)
	local tbl = {}

	if unitInfo.specId == 1468 or unitInfo.specId == 1473 or unitInfo.specId == 1467 then -- evoker
		tbl[358267] = 2 -- hover

		if unitInfo.talents[375406] then -- obsidian bulwark
			tbl[363916] = 2 -- obsidian scales
		end
	end

	return tbl
end

local function getSpellName(spellId)
	return C_Spell.GetSpellName and C_Spell.GetSpellName(spellId) or select(1, GetSpellInfo(spellId))
end

---@param states table<string, XephCDState>
---@param unitInfo UnitInfo
function aura_env.setupState(states, unitInfo)
	local spells = getSpells(unitInfo)
	local stacksMap = getStacksMapForUnitInfo(unitInfo)

	for key, state in pairs(states) do
		if state.unit == unitInfo.unit then
			states[key].show = false
			states[key].changed = true
		end
	end

	for spellId, cooldown in pairs(spells) do
		local key = unitInfo.guid .. "|" .. spellId

		local aura = C_UnitAuras.GetAuraDataBySpellName(unitInfo.unit, getSpellName(spellId))

		states[key] = {
			show = true,
			changed = true,
			progressType = "static",
			spellId = spellId,
			unit = unitInfo.unit,
			cooldown = cooldown,
			icon = getSpellIcon(spellId),
			duration = nil,
			expirationTime = nil,
			value = 1,
			total = 1,
			stacks = stacksMap[spellId],
			maxStacks = stacksMap[spellId],
			kind = "spell",
			spellName = getSpellName(spellId),
			auraActive = aura ~= nil,
			auraInstanceId = aura and aura.auraInstanceID or nil,
		}
	end

	for _, spellInfo in pairs(unitInfo.gear) do
		local key = unitInfo.guid .. "|" .. spellInfo.id

		states[key] = {
			show = true,
			changed = true,
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
	end
end
