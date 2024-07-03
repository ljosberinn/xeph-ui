local vuhdo = VUHDO_slashCmd

aura_env.customEventName = "XEPHUI_AUG_VUHDO_MANUAL_OVERRIDE_UPDATE"
aura_env.active = vuhdo ~= nil
local isAug = GetSpecialization() == 3

--- @type table<string, number>
aura_env.nameToSpecIdMap = {}
local lastPrivateTanks = nil

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
    local classColor = className and RAID_CLASS_COLORS[className] and RAID_CLASS_COLORS[className].colorStr or ""

    return "|T" .. icon .. ":0|t" .. " " .. ("|c%s%s|r"):format(classColor, specName .. " " .. name)
end

aura_env.onGroupLeave = function()
    lastPrivateTanks = nil
end

--- @param event string
aura_env.onPlayerSpecChange = function(event)
    local specId = GetSpecialization()

    if specId == 3 then
        isAug = true
        aura_env.setup(event)
        return
    end

    isAug = false

    lastPrivateTanks = nil
    aura_env.log("clearing private tanks. reason: no longer aug")
    vuhdo("pt clear")
end

aura_env.onLoginOrReload = function()
    isAug = GetSpecialization() == 3
end

--- @type cbObject | nil
aura_env.timer = nil

--- @param event string
--- @param names table<number, string>
local function setupPrivateTanks(event, names)
    local nextPrivateTanks = table.concat(names, ",")

    if nextPrivateTanks == lastPrivateTanks and event ~= "OPTIONS" then
        aura_env.log("setup identical to previous. skipping")
        return
    end

    lastPrivateTanks = nextPrivateTanks

    if aura_env.config.dev.log then
        local eventExplanationMap = {
            ["WA_DELAYED_PLAYER_ENTERING_WORLD"] = "login or reload",
            ["READY_CHECK"] = "ready check",
            [aura_env.customEventName] = "manual override seen",
            ["UNIT_SPEC_CHANGED"] = "spec update received",
            ["GROUP_ROSTER_UPDATE"] = "roster change"
        }

        aura_env.log("clearing private tanks. reason: " .. (eventExplanationMap[event] or event))
    end

    if aura_env.timer and not aura_env.timer:IsCancelled() then
        aura_env.timer:Cancel()
    end

    vuhdo("pt clear")

    if nextPrivateTanks == "" then
        aura_env.log("next private tanks empty, doing nothing.")
        return
    end

    lastArguments = nextPrivateTanks

    aura_env.log("Setting up private tanks:")
    if aura_env.config.dev.log then
        for _, name in pairs(names) do
            local specId = aura_env.nameToSpecIdMap[name]
            local str = name
            if specId then
                local _, specName, _, icon, _, className = GetSpecializationInfoByID(specId)
                str = aura_env.formattedSpecIconWithName(specName, icon, className, name)
            end

            aura_env.log("--> " .. str)
        end
    end

    aura_env.timer =
        C_Timer.NewTimer(
        1,
        function()
            vuhdo("pt " .. nextPrivateTanks)
        end
    )
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

--- @param seenPlayers table<string, string>
local function cleanupOrphanedManualPlayers(seenPlayers)
    -- clean up manual overrides to not carry them around when they leave group
    for key, name in pairs(manuallyAddedPlayers) do
        if seenPlayers[name] == nil then
            manuallyAddedPlayers[key] = nil
        end
    end
end

--- @param event string
local function doGroupUpdate(event)
    --- @type table<number, string>
    local players = {}
    --- @type table<string, string>
    local unitNameToTokenMap = {}

    for unit in WA_IterateGroupMembers() do
        if not UnitIsUnit(unit, "player") then
            local name = UnitName(unit)

            if name then
                unitNameToTokenMap[name] = unit
            end

            local specId = aura_env.nameToSpecIdMap[name]
            local mayAdd = not specId or specId ~= 1473

            if mayAdd then
                local role = UnitGroupRolesAssigned(unit)

                if role == "TANK" and not aura_env.config.group.includeTank then
                    mayAdd = false
                end

                if mayAdd and role == "HEALER" and not aura_env.config.group.includeHealer then
                    mayAdd = false
                end
            end

            if mayAdd then
                players[#players + 1] = name
            end
        end
    end

    local names = {}

    cleanupOrphanedManualPlayers(unitNameToTokenMap)
    populateTable(names, nil, manuallyAddedPlayers)
    populateTable(names, nil, players)
    setupPrivateTanks(event, names)
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
        73 -- warr prot 39
    }

    for unit in WA_IterateGroupMembers() do
        if not UnitIsUnit(unit, "player") then
            local name = UnitName(unit)

            if name then
                unitNameToTokenMap[name] = unit
            end
        end
    end

    cleanupOrphanedManualPlayers(unitNameToTokenMap)

    local playerInstanceId = select(4, UnitPosition("player"))

    for _, dataset in pairs(aura_env.config.raid.priority) do
        if dataset.active and playersSeen[dataset.name] == nil then
            local token = unitNameToTokenMap[dataset.name]
            if token and UnitIsConnected(token) then
                local wantedSpecId = specializationIds[dataset.spec]
                local observedSpecId = aura_env.nameToSpecIdMap[dataset.name]

                if observedSpecId == wantedSpecId then
                    local isPhasedOrZoned = select(4, UnitPosition(token)) ~= playerInstanceId

                    if isPhasedOrZoned and aura_env.config.dev.log then
                        local _, specName, _, icon = GetSpecializationInfoByID(wantedSpecId)
                        local className = UnitClassBase(token)

                        aura_env.log(
                            aura_env.formattedSpecIconWithName(specName, icon, className, dataset.name) ..
                                " matches criteria but is in a different zone/phase and will be skipped."
                        )
                    else
                        local targetTable =
                            dataset.priority == 3 and highPriority or dataset.priority == 2 and mediumPriority or
                            lowPriority
                        targetTable[#targetTable + 1] = dataset.name
                        playersSeen[dataset.name] = true
                    end
                end
            end
        end
    end

    --- @type table<number, string>
    local players = {}

    populateTable(players, limit, manuallyAddedPlayers)
    populateTable(players, limit, highPriority)
    populateTable(players, limit, mediumPriority)
    populateTable(players, limit, lowPriority)

    setupPrivateTanks(event, players)
end

--- @param event string
aura_env.setup = function(event)
    if not isAug then
        return
    end

    if IsInRaid() then
        doRaidUpdate(event)
    elseif IsInGroup() then
        doGroupUpdate(event)
    end
end
