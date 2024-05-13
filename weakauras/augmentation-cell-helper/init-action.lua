aura_env.active = false
--- @type table<string, number>
aura_env.tokenToSpecIdMap = {}
---@type Frame|nil
local setUnitNameButton = nil
---@type Frame|nil
local clearButton = nil
local isAug = GetSpecialization() == 3
---@type string|nil
local lastSpotlightGroup = nil

local function maybeToggleState(env)
	env.active = CellDB.layouts[Cell.vars.currentLayout].spotlight.enabled
end

if Cell and CellDB then
	local env = aura_env

	local function callback()
		maybeToggleState(env)
	end

	Cell:RegisterCallback("GroupTypeChanged", "XephUI_GroupTypeChanged_Postcall", callback)
	Cell:RegisterCallback("ActiveTalentGroupChanged", "XephUI_ActiveTalentGroupChanged_Postcall", callback)

	if not _G["XEPHUI_CELL_AUTOLAYOUT_HOOKED"] then
		_G["XEPHUI_CELL_AUTOLAYOUT_HOOKED"] = true
		hooksecurefunc(Cell.funcs, "UpdateLayout", callback)
	end

	-- see Cell/RaidFrames/Groups/SpotlightFrame
	for i, button in pairs({ CellSpotlightAssignmentMenu:GetChildren() }) do
		if i == 5 then
			setUnitNameButton = button
		end

		if i == 11 then
			clearButton = button
			break
		end
	end
end

if aura_env.config.dev.log then
	WeakAuras.ScanEvents("UNIT_SPEC_CHANGED", "raid1")
	WeakAuras.ScanEvents("UNIT_SPEC_CHANGED", "raid2")
end

local function clearSpotlights()
	if clearButton == nil then
		return
	end

	-- see RaidFrames/Groups/SpotlightFrame -> clear button _onclick attr
	local menu = clearButton:GetParent()

	for index, spotlight in pairs(Cell.unitButtons.spotlight) do
		local currentUnit = spotlight:GetAttribute("unit")

		if currentUnit ~= nil then
			if aura_env.config.dev.log then
				aura_env.log("clearing spotlight " .. index .. " => " .. currentUnit)
			end
			spotlight:SetAttribute("unit", nil)
			spotlight:SetAttribute("refreshOnUpdate", nil)
			menu:Save(index, nil)
		end
	end
end

function aura_env.log(...)
	if aura_env.config.dev.log then
		print("|cffFF8000[Aug Cell Helper]|r", ...)
	end
end

--- @param specName string
--- @param icon string
--- @param className string
--- @param name string
--- @return string
function aura_env.formattedSpecIconWithName(specName, icon, className, name)
	local classColor = className and RAID_CLASS_COLORS[className] and RAID_CLASS_COLORS[className].colorStr or ""

	return "|T" .. icon .. ":0|t" .. " " .. ("|c%s%s|r"):format(classColor, specName .. " " .. name)
end

function aura_env.onGroupLeave()
	lastSpotlightGroup = nil
end

--- @param event string
function aura_env.onPlayerSpecChange(event)
	local specId = GetSpecialization()

	if specId == 3 then
		isAug = true
		aura_env.setup(event)
		return
	end

	isAug = false
	lastSpotlightGroup = nil

	aura_env.log("clearing spotlight. reason: no longer aug")

	clearSpotlights()
end

function aura_env.onLoginOrReload()
	isAug = GetSpecialization() == 3
end

--- @param event string
--- @param tokens table<number, string>
local function setupSpotlight(event, tokens)
	local nextSpotlightGroup = table.concat(tokens, ",")

	if nextSpotlightGroup == lastSpotlightGroup and event ~= "OPTIONS" then
		aura_env.log("setup identical to previous. skipping")
		return
	end

	lastSpotlightGroup = nextSpotlightGroup

	if aura_env.config.dev.log then
		local eventExplanationMap = {
			["WA_DELAYED_PLAYER_ENTERING_WORLD"] = "login or reload",
			["READY_CHECK"] = "ready check",
			["UNIT_SPEC_CHANGED"] = "spec update received",
			["GROUP_ROSTER_UPDATE"] = "roster change",
		}

		aura_env.log("clearing spotlights. reason: " .. (eventExplanationMap[event] or event))
	end

	clearSpotlights()

	if nextSpotlightGroup == "" then
		aura_env.log("next spotlights empty, doing nothing.")
		return
	end

	aura_env.log("Setting up spotlights:")
	if aura_env.config.dev.log then
		for _, token in pairs(tokens) do
			local specId = aura_env.tokenToSpecIdMap[token]
			local str = token
			if specId then
				local name = UnitName(token)
				local _, specName, _, icon, _, className = GetSpecializationInfoByID(specId)
				str = aura_env.formattedSpecIconWithName(specName, icon, className, name)
			end

			aura_env.log("--> " .. str)
		end
	end

	for t = 1, #tokens do
		setUnitNameButton:SetUnit(t, tokens[t])
	end
end

--- @param tbl table<number, string>
--- @param limit number|nil
--- @param players table<number, string>
local function populateTable(tbl, limit, players)
	for _, name in pairs(players) do
		if limit and #tbl == limit then
			return
		end

		tbl[#tbl + 1] = name
	end
end

--- @param event string
function aura_env.setup(event)
	if not isAug then
		return
	end

	if not IsInRaid() then
		clearSpotlights()
		return
	end

	--- @type number
	local limit = aura_env.config.raid.limit
	--- @type table<string, boolean>
	local playersSeen = {}
	--- @type table<number, string>
	local highPriority = {}
	--- @type table<number, string>
	local mediumPriority = {}
	--- @type table<number, string>
	local lowPriority = {}
	--- @type table<string, string>
	local unitNameToTokenMap = {}

	-- THIS LIST NEEDS TO BE KEPT IN SYNC WITH CUSTOM OPTIONS
	local specializationIds = {
		250, -- dk blood 1
		251, -- dk frost 2
		252, -- dk unholy 3
		--
		577, -- dh havoc 4
		581, -- dh vengeance 5
		--
		102, -- druid balance 6
		103, -- druid feral 7
		104, -- druid guardian 8
		105, -- druid restoration 9
		--
		1467, -- evoker devastation 10
		1468, -- evoker preservation 11
		1473, -- evoker augmentation 12
		--
		253, -- hunter bm 13
		254, -- hunter mm 14
		255, -- hunter survival 15
		--
		62, -- mage arcane 16
		63, -- mage fire 17
		64, -- mage frost 18
		--
		268, -- monk brew 19
		270, -- monk mw 20
		269, -- monk ww 21
		--
		65, -- pala holy 22
		66, -- pala prot 23
		70, -- pala ret 24
		--
		256, -- priest disc 25
		257, -- priest holy 26
		258, -- priest shadow 27
		--
		259, -- rogue assa 28
		260, -- rogue outlaw 29
		261, -- rogue sub 30
		--
		262, -- shaman elemental 31
		263, -- shaman enhancement 32
		264, -- shaman resto 33
		--
		265, -- wl affl 34
		266, -- wl demo 35
		267, -- wl destru 36
		--
		71, -- warr arms 37
		72, -- warr fury 38
		73, -- warr prot 39
	}

	for unit in WA_IterateGroupMembers() do
		if not UnitIsUnit(unit, "player") then
			local name = UnitName(unit)

			if name then
				unitNameToTokenMap[name] = unit
			end
		end
	end

	local playerInstanceId = select(4, UnitPosition("player"))

	for _, dataset in pairs(aura_env.config.raid.priority) do
		if dataset.active and playersSeen[dataset.name] == nil then
			local token = unitNameToTokenMap[dataset.name]

			if token and UnitIsConnected(token) then
				local wantedSpecId = specializationIds[dataset.spec]
				local observedSpecId = aura_env.tokenToSpecIdMap[token]

				if observedSpecId == wantedSpecId then
					local isPhasedOrZoned = select(4, UnitPosition(token)) ~= playerInstanceId

					if isPhasedOrZoned and aura_env.config.dev.log then
						local _, specName, _, icon = GetSpecializationInfoByID(wantedSpecId)
						local className = UnitClassBase(token)

						aura_env.log(
							aura_env.formattedSpecIconWithName(specName, icon, className, dataset.name)
								.. " matches criteria but is in a different zone/phase and will be skipped."
						)
					else
						local targetTable = dataset.priority == 3 and highPriority
							or dataset.priority == 2 and mediumPriority
							or lowPriority
						targetTable[#targetTable + 1] = token
						playersSeen[dataset.name] = true
					end
				end
			end
		end
	end

	--- @type table<number, string>
	local players = {}

	populateTable(players, limit, highPriority)
	populateTable(players, limit, mediumPriority)
	populateTable(players, limit, lowPriority)

	setupSpotlight(event, players)
end
