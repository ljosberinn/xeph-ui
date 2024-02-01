--- @return number
local function getHolyPower()
    return UnitPower("player", Enum.PowerType.HolyPower)
end

local currentHolyPower = getHolyPower()
local lastCrusadingStrikesDamage = nil
local ignoreNextCrusadingStrike = false
local customEventName = "XEPHUI_CRUSADING_STRIKES"
--- @type cbObject|nil
local timer = nil

local function getAttackSpeed()
    return UnitAttackSpeed("player")
end

local function cancelTimer()
    if timer and not timer:IsCancelled() then
        timer:Cancel()
        timer = nil
    end
end

--- @param states table<number, table>
--- @return boolean
function aura_env.maybeInitState(states)
    if states[1] ~= nil then
        return false
    end

    local nextValue = getHolyPower()
    local transparent = nextValue < 3

    for i = 1, 5 do
        local value = nextValue >= i and 1 or 0

        states[i] = {
            show = true,
            index = i,
            progressType = "static",
            value = value,
            total = 1,
            changed = true,
            transparent = transparent,
            power = nextValue
        }
    end

    return true
end

--- @param states table<number, table>
--- @return boolean
local function onUnitPowerUpdate(states, ...)
    local hasChanges = false
    local unit, powerType = ...

    if unit ~= "player" or powerType ~= "HOLY_POWER" then
        return false
    end

    local nextValue = getHolyPower()

    if nextValue == currentHolyPower then
        return false
    end

    local progressData = {
        duration = nil,
        expirationTime = nil,
        index = nil
    }

    -- check whether Crusading Strikes data is in progress
    -- if so, we store it in progressData and reset the entry to initial state

    for i = 1, 5 do
        if states[i].progressType == "timed" then
            progressData.expirationTime = states[i].expirationTime
            progressData.duration = states[i].duration

            if nextValue < currentHolyPower then
                progressData.index = nextValue + 1
            else
                progressData.index = (i == 5 or nextValue == 5) and 5 or nextValue + 1
            end

            states[i].progressType = "static"
            states[i].duration = nil
            states[i].expirationTime = nil
            states[i].changed = true
            states[i].value = nextValue >= i and 1 or 0
            states[i].total = 1
            states[i].inverse = false

            hasChanges = true
            break
        end
    end

    local transparent = nextValue < 3

    for i = 1, 5 do
        local individualStackChanged = false
        local value = nextValue >= i and 1 or 0

        if states[i].transparent ~= transparent then
            individualStackChanged = true
            states[i].transparent = transparent
        end

        if states[i].value ~= value then
            individualStackChanged = true
            states[i].value = value
        end

        if states[i].power ~= nextValue then
            individualStackChanged = true
            states[i].power = nextValue
        end

        -- moving over possibly stored Crusading Strikes
        if progressData.index == i then
            individualStackChanged = true
            states[i].progressType = "timed"
            states[i].duration = progressData.duration
            states[i].expirationTime = progressData.expirationTime
            states[i].inverse = true
            states[i].paused = false
        end

        states[i].changed = individualStackChanged

        if individualStackChanged then
            hasChanges = true
        end
    end

    currentHolyPower = nextValue

    return hasChanges
end

--- @return boolean
local function onCLEU(states, ...)
    local hasChanges = false
    local timestamp, _, _, sourceGUID, _, _, _, _, _, _, _, spellId = ...

    if sourceGUID ~= WeakAuras.myGUID then
        return false
    end

    if spellId == 406834 then
        ignoreNextCrusadingStrike = false

        return false
    end

    if spellId == 408385 and timestamp ~= lastCrusadingStrikesDamage then
        if ignoreNextCrusadingStrike then
            cancelTimer()

            for i = 1, 5 do
                if states[i].progressType == "timed" then
                    local swingTimer = getAttackSpeed()

                    states[i].changed = true
                    states[i].paused = false
                    states[i].expirationTime = GetTime() + swingTimer

                    return true
                end
            end

            return false
        end

        ignoreNextCrusadingStrike = true
        lastCrusadingStrikesDamage = timestamp

        for i = 1, 5 do
            if states[i].value == 0 then
                local swingTimer = getAttackSpeed()
                local duration = swingTimer * 2

                states[i].changed = true
                states[i].progressType = "timed"
                states[i].duration = duration
                states[i].expirationTime = GetTime() + duration
                states[i].value = nil
                states[i].total = nil
                states[i].inverse = true

                timer =
                    C_Timer.NewTimer(
                    swingTimer + 0.1,
                    function()
                        WeakAuras.ScanEvents(customEventName, aura_env.id)
                    end
                )

                hasChanges = true
                break
            end
        end

        return hasChanges
    end

    return false
end

local function onCustomEvent(states, ...)
    local id = ...

    if id ~= aura_env.id then
        return false
    end

    for i = 1, 5 do
        if states[i].progressType == "timed" then
            states[i].changed = true
            states[i].paused = true
            states[i].remaining = getAttackSpeed()

            return true
        end
    end

    return false
end

aura_env.handlers = {
    ["COMBAT_LOG_EVENT_UNFILTERED"] = function(states, ...)
        return onCLEU(states, ...)
    end,
    ["UNIT_POWER_UPDATE"] = function(states, ...)
        return onUnitPowerUpdate(states, ...)
    end,
    [customEventName] = function(states, ...)
        return onCustomEvent(states, ...)
    end
}
