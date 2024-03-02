aura_env.importantSpellIds = {}
local interruptSpellId = aura_env.config.interruptSpellId
local interruptThreshold = aura_env.config.interruptThreshold

do
    if interruptSpellId == 0 or not IsSpellKnown(interruptSpellId) then
        local name = interruptSpellId == 0 and nil or GetSpellInfo(interruptSpellId)
        local label = name and name or "Spell doesn't exist"
        print(
            "[" ..
                aura_env.id ..
                    "] The given spell id of '" ..
                        interruptSpellId .. "' (" .. label .. ") is not a spell you currently know."
        )
    end
end

if Plater and Plater.db and Plater.db.profile and Plater.db.profile.script_data then
    for _, script in pairs(Plater.db.profile.script_data) do
        if script and script.Name == "Cast - Very Important [Plater]" then
            for _, id in pairs(script.SpellIds) do
                aura_env.importantSpellIds[id] = true
            end
        end
    end
end

--- @param states table<"", FocusKickState>
local function maybeInitializeState(states)
    if not states[""] then
        states[""] = {
            show = false,
            changed = true,
            progressType = "timed",
            autoHide = true,
            duration = 0,
            expirationTime = 0,
            icon = 0,
            interruptible = false,
            name = "",
            remaining = 0,
            spellId = 0,
            additionalProgress = nil,
            interruptOnCooldown = false,
            isChannel = false
        }
    end
end

--- @param states table<"", FocusKickState>
--- @return boolean
local function augmentWithInterruptInfo(states)
    local expirationTime = states[""].expirationTime

    local interruptCastTime, interruptCooldown = GetSpellCooldown(interruptSpellId)
    local interruptOnCooldown = interruptCooldown > 0

    if not states[""].changed and states[""].interruptOnCooldown ~= interruptOnCooldown then
        states[""].changed = true
    end
    states[""].interruptOnCooldown = interruptOnCooldown

    -- not interruptible, no point in checking whether we could eventually
    if not states[""].interruptible then
        return states[""].changed
    end

    -- interrupt currently ready
    if interruptCooldown == 0 then
        return states[""].changed
    end

    local interruptReadyAt = interruptCastTime + interruptCooldown

    -- interrupt ready either after the cast finishes OR too close before
    if interruptReadyAt > expirationTime - interruptThreshold then
        return states[""].changed
    end

    states[""].additionalProgress = {
        {
            min = 0,
            max = expirationTime - interruptReadyAt
        }
    }

    return states[""].changed
end

--- @param states table<"", FocusKickState>
--- @return boolean
local function onUnitSpellCastStart(states)
    maybeInitializeState(states)

    local name, _, icon, startTime, endTime, _, _, notInterruptible, spellId = UnitCastingInfo("focus")

    if not name then
        return false
    end

    local expirationTime = endTime / 1000

    states[""].spellId = spellId
    states[""].show = true
    states[""].changed = true
    states[""].interruptible = not notInterruptible
    states[""].name = name
    states[""].icon = icon
    states[""].expirationTime = expirationTime
    states[""].remaining = expirationTime - GetTime()
    states[""].duration = (endTime - startTime) / 1000
    states[""].isChannel = false

    return augmentWithInterruptInfo(states)
end

--- @param states table<"", FocusKickState>
--- @return boolean
local function onUnitSpellCastDelayed(states)
    return onUnitSpellCastStart(states)
end

--- @param states table<"", FocusKickState>
--- @return boolean
local function onUnitSpellCastStop(states)
    if not states[""] then
        return false
    end

    states[""].changed = states[""].show == true
    states[""].show = false

    return states[""].changed
end

--- @param states table<"", FocusKickState>
--- @return boolean
local function onUnitSpellCastChannelStart(states)
    maybeInitializeState(states)

    local name, _, icon, startTime, endTime, _, notInterruptible, spellId, _, stageTotal = UnitChannelInfo("focus")

    if not name then
        return false
    end

    if stageTotal ~= nil then
        local empowerHoldAtMaxTime = GetUnitEmpowerHoldAtMaxTime("focus") or 0
        -- endTime on empowered abilities does not account for holding at max
        endTime = endTime + empowerHoldAtMaxTime
    end

    local expirationTime = endTime / 1000

    states[""].spellId = spellId
    states[""].show = true
    states[""].changed = true
    states[""].interruptible = not notInterruptible
    states[""].name = name
    states[""].icon = icon
    states[""].expirationTime = expirationTime
    states[""].remaining = expirationTime - GetTime()
    states[""].duration = (endTime - startTime) / 1000
    states[""].isChannel = stageTotal == nil

    return augmentWithInterruptInfo(states)
end

--- @param states table<"", FocusKickState>
--- @return boolean
local function onUnitSpellCastChannelUpdate(states)
    if not states[""] then
        return false
    end

    -- channel updates fire once per second; re-check interrupt info on each
    return augmentWithInterruptInfo(states)
end

--- @param states table<"", FocusKickState>
--- @return boolean
local function onUnitSpellCastChannelStop(states)
    if not states[""] then
        return false
    end

    states[""].changed = states[""].show == true
    states[""].show = false
    states[""].isChannel = false

    return states[""].changed
end

--- @param states table<"", FocusKickState>
--- @return boolean
local function onUnitSpellCastInterruptible(states)
    if not states[""] then
        return false
    end

    local name, _, _, _, _, _, _, notInterruptible = UnitCastingInfo("focus")

    if not name then
        name, _, _, _, _, _, notInterruptible = UnitChannelInfo("focus")
    end

    if not name then
        return false
    end

    local interruptible = not notInterruptible
    states[""].changed = states[""].interruptible ~= interruptible
    states[""].interruptible = interruptible

    return augmentWithInterruptInfo(states)
end

--- @param states table<"", FocusKickState>
--- @return boolean
local function onUnitSpellCastNotInterruptible(states)
    return onUnitSpellCastInterruptible(states)
end

--- @param states table<"", FocusKickState>
--- @return boolean
local function onUnitSpellCastInterrupted(states)
    if not states[""] then
        return false
    end

    states[""].changed = states[""].show == true
    states[""].show = false

    return states[""].changed
end

--- @param states table<"", FocusKickState>
--- @return boolean
local function onUnitSpellCastEmpowerStart(states)
    return onUnitSpellCastChannelStart(states)
end

--- @param states table<"", FocusKickState>
--- @return boolean
local function onUnitSpellCastEmpowerStop(states)
    return onUnitSpellCastChannelStop(states)
end

aura_env.handlers = {
    ["UNIT_SPELLCAST_START"] = onUnitSpellCastStart,
    ["UNIT_SPELLCAST_DELAYED"] = onUnitSpellCastDelayed,
    ["UNIT_SPELLCAST_STOP"] = onUnitSpellCastStop,
    ["UNIT_SPELLCAST_CHANNEL_START"] = onUnitSpellCastChannelStart,
    ["UNIT_SPELLCAST_CHANNEL_UPDATE"] = onUnitSpellCastChannelUpdate,
    ["UNIT_SPELLCAST_CHANNEL_STOP"] = onUnitSpellCastChannelStop,
    ["UNIT_SPELLCAST_INTERRUPTIBLE"] = onUnitSpellCastInterruptible,
    ["UNIT_SPELLCAST_NOT_INTERRUPTIBLE"] = onUnitSpellCastNotInterruptible,
    ["UNIT_SPELLCAST_INTERRUPTED"] = onUnitSpellCastInterrupted,
    ["UNIT_SPELLCAST_EMPOWER_START"] = onUnitSpellCastEmpowerStart,
    ["UNIT_SPELLCAST_EMPOWER_STOP"] = onUnitSpellCastEmpowerStop
}
