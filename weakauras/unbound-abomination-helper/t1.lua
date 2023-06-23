-- CLEU:SPELL_PERIODIC_DAMAGE, CLEU:SPELL_AURA_APPLIED, CLEU:SPELL_CAST_START, CLEU:SPELL_AURA_REMOVED
--- @class UnboundAbominationHelperState
--- @field show boolean
--- @field changed boolean
--- @field spellId number
--- @field progressType "timed"
--- @field duration number
--- @field expirationTime number
--- @field name string
--- @field icon number
--- @field index number
--- @field autoHide boolean

--- @param states table<string, UnboundAbominationHelperState>
--- @param event "COMBAT_LOG_EVENT_UNFILTERED" | "OPTIONS" | "STATUS"
function f(states, event, ...)
    if event ~= "COMBAT_LOG_EVENT_UNFILTERED" then
        return false
    end

    local _, subEvent, _, _, _, _, _, targetGUID, targetName, _, _, spellId = ...

    if subEvent == "SPELL_CAST_START" and spellId == 269310 then
        local expirationTime = GetTime() + 5
        local key = "cleansing-light"

        if not states[key] then
            states[key] = {
                show = true,
                changed = true,
                spellId = spellId,
                expirationTime = expirationTime,
                duration = 5,
                progressType = "timed",
                autoHide = true,
                index = 0,
                name = "Cleansing Light",
                icon = 237541
            }
        else
            states[key].show = true
            states[key].changed = true
            states[key].expirationTime = expirationTime
        end

        return true
    end

    if spellId ~= 269301 then
        return false
    end

    if subEvent == "SPELL_PERIODIC_DAMAGE" or subEvent == "SPELL_AURA_APPLIED" then
        local expirationTime = GetTime() + 4

        if not states[targetGUID] then
            states[targetGUID] = {
                changed = true,
                show = true,
                spellId = 269301,
                expirationTime = expirationTime,
                progressType = "timed",
                duration = 4,
                autoHide = true,
                index = #states + 1,
                name = targetName,
                icon = 1035037
            }
        else
            states[targetGUID].changed = true
            states[targetGUID].expirationTime = expirationTime
            states[targetGUID].show = true
        end

        return true
    elseif subEvent == "SPELL_AURA_REMOVED" then
        states[targetGUID].changed = true
        states[targetGUID].show = false

        return true
    end

    return false
end
