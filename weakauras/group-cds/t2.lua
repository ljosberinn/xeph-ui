-- UNIT_SPELLCAST_SUCCEEDED:player
--- @class GroupCDsState
--- @field show boolean
--- @field changed boolean
--- @field duration number
--- @field expirationTime number
--- @field autoHide boolean
--- @field progressType "timed"
--- @field icon number

--- @param states table<number, GroupCDsState>
--- @param event "STATUS" | "OPTIONS" | "UNIT_SPELLCAST_SUCCEEDED"
--- @return boolean
function (states, event, ...)
    if event == "UNIT_SPELLCAST_SUCCEEDED" then
        local unit, castGUID, spellId = ...

        if unit == "player" then
            return false
        end

        local duration = aura_env.durationForSpell[spellId]

        if not duration then
            return false
        end

        if not UnitIsFriend("player", unit) then
            return false
        end

        local icon = select(3, GetSpellInfo(spellId))

        states[castGUID] = {
            show = true,
            changed = true,
            duration = duration,
            expirationTime = GetTime() + duration,
            autoHide = true,
            progressType = "timed",
            icon = icon
        }

        return true
    end

    return false
end
