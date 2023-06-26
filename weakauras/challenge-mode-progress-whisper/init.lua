--- @param seconds number
--- @return string
local function formatTime(seconds)
    local minutes = floor(mod(seconds, 3600) / 60)
    local sec = floor(mod(seconds, 60))

    return format("%02d:%02d", minutes, sec)
end

--- @type number|nil
local startTime = nil

--- @type string|nil
local formattedMaxTime = nil

--- @type number|nil
local keyLevel = nil

--- @type string|nil
local encounterName = nil

--- @type table<string, number>
local whispers = {}

--- @type string|nil
local difficulty = nil

local function resetEncounterMeta()
    startTime = nil
    formattedMaxTime = nil
    encounterName = nil
    keyLevel = nil
    whispers = {}
    difficulty = nil
end

-- verification step to ignore abandoned keys by zoning out
local function isActuallyInEncounter()
    if keyLevel ~= nil then
        return C_ChallengeMode.IsChallengeModeActive()
    end

    return UnitExists("boss1")
end

--- @return string
local function createResponse()
    local timeSpent = formatTime(GetTime() - startTime)

    if keyLevel ~= nil then
        return "Busy doing " ..
            encounterName .. " +" .. keyLevel .. " - [" .. timeSpent .. "/" .. formattedMaxTime .. "]"
    end

    return "In combat with " .. encounterName .. " [" .. difficulty .. ", " .. timeSpent .. "]"
end

--- @param source string
--- @return boolean
local function mayRespond(source)
    return whispers[source] == nil or GetTime() - whispers[source] > 60
end

aura_env.handlers = {
    --- @return boolean
    ["CHALLENGE_MODE_START"] = function()
        whispers = {}
        difficulty = nil

        local mapId = C_ChallengeMode.GetActiveChallengeMapID()

        if not mapId then
            return false
        end

        startTime = GetTime()
        local name, _, timer = C_ChallengeMode.GetMapUIInfo(mapId)

        encounterName = name
        formattedMaxTime = formatTime(timer)
        keyLevel = C_ChallengeMode.GetActiveKeystoneInfo()

        return false
    end,
    --- @return boolean
    ["CHALLENGE_MODE_END"] = function()
        resetEncounterMeta()

        return false
    end,
    --- @return boolean
    ["CHAT_MSG_WHISPER"] = function(...)
        if not startTime then
            return false
        end

        local source = select(2, ...)

        if not source or not mayRespond(source) or not isActuallyInEncounter() then
            return false
        end

        whispers[source] = GetTime()

        local response = createResponse()

        SendChatMessage(message, "WHISPER", nil, response)

        return false
    end,
    --- @return boolean
    ["CHAT_MSG_BN_WHISPER"] = function(...)
        if not startTime then
            return false
        end

        local source = select(13, ...)

        if not source or not mayRespond(source) or not isActuallyInEncounter() then
            return false
        end

        whispers[source] = GetTime()

        local response = createResponse()

        BNSendWhisper(source, response)

        return false
    end,
    --- @return boolean
    ["ENCOUNTER_START"] = function(...)
        -- ignore dungeon bosses
        if C_ChallengeMode.IsChallengeModeActive() then
            return false
        end

        startTime = GetTime()

        local _, name, difficultyId = ...

        local difficultyName = GetDifficultyInfo(difficultyId)
        difficulty = difficultyName
        encounterName = name

        return false
    end,
    --- @return boolean
    ["ENCOUNTER_END"] = function()
        -- ignore dungeon bosses
        if C_ChallengeMode.IsChallengeModeActive() then
            return false
        end

        resetEncounterMeta()

        return false
    end
}
