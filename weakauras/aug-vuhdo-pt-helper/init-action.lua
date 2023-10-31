local vuhdo = VUHDO_slashCmd

aura_env.customEventName = "XEPHUI_AUG_VUHDO_MANUAL_OVERRIDE_UPDATE"
aura_env.active = vuhdo ~= nil

--- @type table<string, number>
aura_env.nameToSpecIdMap = {}

aura_env.log = function(...)
    if aura_env.config.dev.log then
        print("|cffFF8000[Aug Vuhdo PT Helper]|r", ...)
    end
end

--- @type table<number, string>
local manuallyAddedPlayers = {}
local lastArguments = nil

if aura_env.active and not _G["AugVuhDoHooked"] then
    _G["AugVuhDoHooked"] = true
    local customEventName = aura_env.customEventName
    local id = aura_env.id

    hooksecurefunc(
        "VUHDO_slashCmd",
        function(message)
            local parsed = VUHDO_textParse(message)
            local cmd = strlower(parsed[1])

            if cmd ~= "pt" then
                return
            end

            -- either clearing or adding list of players
            if parsed[2] then
                if parsed[2] == "clear" then
                    table.wipe(manuallyAddedPlayers)
                    return
                end

                if lastArguments == parsed[2] then
                    lastArguments = nil
                end

                -- todo: account for adding a list of players manually?

                return
            end

            -- no list of names given, must be manual toggle
            local target = UnitName("target")

            if not target then
                return
            end

            local removed = false

            for key, name in pairs(manuallyAddedPlayers) do
                if name == target then
                    manuallyAddedPlayers[key] = nil
                    removed = true
                    break
                end
            end

            if not removed then
                manuallyAddedPlayers[#manuallyAddedPlayers + 1] = target
            end

            WeakAuras.ScanEvents(customEventName, id)
        end
    )
end

--- @param specName string
--- @param icon string
--- @param className string
--- @param name string
--- @return string
aura_env.formattedSpecIconWithName = function(specName, icon, className, name)
    return "|T" ..
        icon .. ":0|t" .. " " .. ("|c%s%s|r"):format(RAID_CLASS_COLORS[className].colorStr, specName .. " " .. name)
end

--- @param event string
--- @param names table<number, string>
local function setupPrivateTanks(event, names)
    local eventExplanationMap = {
        ["PLAYER_ENTERING_WORLD"] = "login or reload",
        ["READY_CHECK"] = "ready check",
        [aura_env.customEventName] = "manual override seen"
    }

    aura_env.log("clearing private tanks. reason: " .. (eventExplanationMap[event] or event))
    vuhdo("pt clear")

    local nextPts = table.concat(names, ",")

    if nextPts == "" then
        return
    end

    lastArguments = nextPts

    aura_env.log("Setting up private tanks:")

    for _, name in pairs(names) do
        local specId = aura_env.nameToSpecIdMap[name]
        local str = name
        if specId then
            local _, specName, _, icon, _, _, className = GetSpecializationInfoByID(specId)
            str = aura_env.formattedSpecIconWithName(specName, icon, className, name)
        end

        aura_env.log("--> " .. str)
    end

    vuhdo("pt " .. nextPts)
end

--- @param tbl table<number, string>
--- @param players table<number, string>
--- @param limit number|nil
local function populateTable(tbl, players, limit)
    for _, name in pairs(players) do
        if limit and #tbl == limit then
            return
        end

        tbl[#tbl + 1] = name
    end
end

local function isAugmentationEvoker(name)
    return aura_env.nameToSpecIdMap[name] == 1473
end

local function isHealer(name)
    local specId = aura_env.nameToSpecIdMap[name]
    
    if not specId then
        return false
    end

    return specId == 105 or specId == 1468 or specId == 270 or specId == 65 or specId == 256 or specId == 257 or
        specId == 264
end

--- @param event string
local function doGroupUpdate(event)
    local players = {}

    for unit in WA_IterateGroupMembers() do
        if not UnitIsUnit(unit, "player") then
            local name = UnitName(unit)

            if not isHealer(name) and not isAugmentationEvoker(name) then
                players[#players + 1] = name
            end
        end
    end

    populateTable(players, manuallyAddedPlayers)
    populateTable(players, players)

    setupPrivateTanks(event, players)
end

local function doRaidUpdate(event)
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
        250, -- dk blood
        251, -- dk frost
        252, -- dk unholy
        577, -- dh havoc
        581, -- dh vengeance
        102, -- druid balance
        103, -- druid feral
        104, -- druid guardian
        105, -- druid restoration
        1467, -- evoker devastation
        1468, -- evoker preservation
        1473, -- evoker augmentation
        253, -- hunter bm
        254, -- hunter mm
        255, -- hunter survival
        62, -- mage arcane
        63, -- mage fire
        64, -- mage frost
        268, -- monk brew
        269, -- monk ww
        270, -- monk mw
        65, -- pala holy
        66, -- pala prot
        70, -- pala ret
        256, -- priest disc
        257, -- priest holy
        258, -- priest shadow
        259, -- rogue assa
        260, -- rogue outlaw
        261, -- rogue sub
        262, -- shaman elemental
        263, -- shaman enhancement
        264, -- shaman resto
        265, -- wl affl
        266, -- wl demo
        267, -- wl destru
        71, -- warr arms
        72, -- warr fury
        73 -- warr prot
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
        if playersSeen[dataset.name] == nil then
            local token = unitNameToTokenMap[dataset.name]

            if token and UnitIsConnected(token) and select(4, UnitPosition(token)) == playerInstanceId then
                local wantedSpecId = specializationIds[dataset.spec]
                local observedSpecId = aura_env.nameToSpecIdMap[dataset.name]

                if observedSpecId == wantedSpecId then
                    local targetTable =
                        dataset.priority == 3 and highPriority or dataset.priority == 2 and mediumPriority or
                        lowPriority
                    targetTable[#targetTable + 1] = dataset.name
                    playersSeen[dataset.name] = true
                end
            end
        end
    end

    -- clean up manual overrides to not carry them around when they leave group
    for key, name in pairs(manuallyAddedPlayers) do
        if unitNameToTokenMap[name] == nil then
            manuallyAddedPlayers[key] = nil
        end
    end

    --- @type table<number, string>
    local players = {}

    populateTable(players, manuallyAddedPlayers, limit)
    populateTable(players, highPriority, limit)
    populateTable(players, mediumPriority, limit)
    populateTable(players, lowPriority, limit)

    setupPrivateTanks(event, players)
end

--- @param event string
aura_env.setup = function(event)
    if IsInRaid() then
        doRaidUpdate(event)
    elseif IsInGroup() then
        doGroupUpdate(event)
    end
end
