-- UNIT_AURA, UNIT_SPELLCAST_SUCCEEDED:player
--- @class T31_PrescienceState
--- @field show boolean
--- @field changed boolean
--- @field stacks number
--- @field autoHide boolean
--- @field progressType "static"

--- @param states table<"", T31_PrescienceState>
--- @param event "OPTIONS" | "STATUS" | "UNIT_AURA" | "UNIT_SPELLCAST_SUCCEEDED" | "TRIGGER" | "STATUS"
--- @return boolean
function (states, event, ...)
    if event == "STATUS" and not states[""] then
        states[""] = {
            stacks = 2,
            show = true,
            changed = true,
            autoHide = false,
            progressType = "static"
        }

        return true
    end

    if event == "TRIGGER" then
        local updatedTriggerStates = select(2, ...)

        if updatedTriggerStates then
            for _, state in pairs(updatedTriggerStates) do
                aura_env.active = state.equipped >= 2
            end
        end

        return false
    end

    if not aura_env.active then
        return false
    end

    if event == "UNIT_SPELLCAST_SUCCEEDED" then
        local spellId = select(3, ...)

        if spellId == 409311 then
            aura_env.intercept = true
        end

        return false
    end

    if not aura_env.intercept then
        return false
    end

    if event == "UNIT_AURA" then
        local unit, info = ...

        if info.isFullUpdate then
            return false
        end

        if info.addedAuras then
            for _, aura in pairs(info.addedAuras) do
                if aura_env.maybeUpdateState(states, aura) then
                    return true
                end
            end
        end

        if info.updatedAuraInstanceIDs then
            for _, id in pairs(info.updatedAuraInstanceIDs) do
                if aura_env.maybeUpdateState(states, C_UnitAuras.GetAuraDataByAuraInstanceID(unit, id)) then
                    return true
                end
            end
        end
    end

    return false
end
