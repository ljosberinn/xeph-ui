aura_env.customEventName = "XEPHUI_AUG_VUHDO_MANUAL_OVERRIDE_UPDATE"

local vuhdo = VUHDO_slashCmd

aura_env.active = vuhdo ~= nil

--- @type table<string, number>
aura_env.inspectedSpecMap = {}

--- @type table<string, number>
aura_env.awaitingInspect = {}

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

--- @param name string
--- @param className string|nil
--- @param specId number|nil
--- @param token string|nil
aura_env.getColoredLabelFor = function(name, className, specId, token)
    if token then
        specId = GetInspectSpecialization(token)
        className = select(2, UnitClass(token))
    else
        className = string.upper(className)
    end

    local _, specName, _, icon = GetSpecializationInfoByID(specId)

    return "|T" ..
        icon .. ":0|t" .. " " .. ("|c%s%s|r"):format(RAID_CLASS_COLORS[className].colorStr, specName .. " " .. name)
end

--- @param event string
--- @param names table<number, string>
local function setupPrivateTanks(event, names)
    if not aura_env.active then
        return
    end

    local eventExplanationMap = {
        ["GROUP_ROSTER_UPDATE"] = "roster changed",
        ["INSPECT_READY"] = "received spec information",
        [aura_env.customEventName] = "manual override observed"
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
        local specId = aura_env.inspectedSpecMap[name]
        local str = name
        if specId then
            str = aura_env.getColoredLabelFor(name, select(7, GetSpecializationInfoByID(specId)), specId)
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

--- @param unit string
--- @param force boolean
--- @return boolean
aura_env.maybeQueueForInspect = function(unit, force)
    local name = UnitName(unit)

    -- debounce
    if aura_env.awaitingInspect[name] ~= nil then
        return false
    end

    -- unless forced, dont do anything if we already know a spec
    if aura_env.inspectedSpecMap[name] ~= nil and aura_env.inspectedSpecMap ~= -1 and not force then
        return false
    end

    NotifyInspect(unit)
    aura_env.awaitingInspect[name] = GetTime()
    aura_env.log("requesting spec for " .. WA_ClassColorName(name))

    return true
end

--- @param event string
local function doGroupUpdate(event)
    local tankName
    local dpsNames = {}
    local delaySetup = false

    for unit in WA_IterateGroupMembers() do
        if not UnitIsUnit(unit, "player") then
            local role = UnitGroupRolesAssigned(unit)
            local name = UnitName(unit)

            local queued = aura_env.maybeQueueForInspect(unit, false)

            if queued then
                delaySetup = true
            else
                if aura_env.config.group.includeTank and role == "TANK" then
                    tankName = name
                elseif role == "DAMAGER" then
                    dpsNames[#dpsNames + 1] = name
                end
            end
        end
    end

    if delaySetup then
        return
    end

    local players = {}

    populateTable(players, manuallyAddedPlayers)
    populateTable(players, dpsNames)

    if tankName then
        players[#players + 1] = tankName
    end

    setupPrivateTanks(event, players)
end

--- @param event string
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
    --- @type table<string, number>
    local unitNameToSpecIdMap = {}

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

    local delaySetup = false
    
    for unit in WA_IterateGroupMembers() do
        if not UnitIsUnit(unit, "player") then
            local name = UnitName(unit)

            if name then
                unitNameToTokenMap[name] = unit
                unitNameToSpecIdMap[name] = aura_env.inspectedSpecMap[name] or -1

                local queued = aura_env.maybeQueueForInspect(unit, false)

                if queued then
                    delaySetup = true
                end
            else
                -- clean up manual overrides to not carry them around when they leave group
                for key, value in pairs(manuallyAddedPlayers) do
                    if value == manuallyAddedPlayers then
                        manuallyAddedPlayers[key] = nil
                    end
                end
            end
        end
    end

    if delaySetup then
        return false
    end

    local playerInstanceId = select(4, UnitPosition("player"))

    for _, dataset in pairs(aura_env.config.raid.priority) do
        if playersSeen[dataset.name] == nil then
            local token = unitNameToTokenMap[dataset.name]

            if token and UnitIsConnected(token) and select(4, UnitPosition(token)) == playerInstanceId then
                local wantedSpecId = specializationIds[dataset.spec]
                local observedSpecId = unitNameToSpecIdMap[dataset.name]

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
