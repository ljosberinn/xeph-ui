-- CLEU:SPELL_AURA_APPLIED, CLEU:SPELL_AURA_REFRESH, TRIGGER:3
--- @class T31_PrescienceState
--- @field show boolean
--- @field changed boolean
--- @field stacks number
--- @field autoHide boolean
--- @field progressType "static"

--- @param states table<"", T31_PrescienceState>
--- @param event "OPTIONS" | "STATUS" | "COMBAT_LOG_EVENT_UNFILTERED"
--- @return boolean
function (states, event, ...)
    if event == "TRIGGER" then
        local updatedTriggerStates = select(2, ...)

        if updatedTriggerStates then
            for _, state in pairs(updatedTriggerStates) do
                aura_env.active = state.equipped >= 2
            end
        end
    end

    if not aura_env.active then
        return false
    end

    if event == "UNIT_DIED" then
        if states[""].stacks == 2 then
            return false
        end
        
        states[""].stacks = 2
        states[""].changed = true
        states[""].show = false

        return true
    end

    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local _, _, _, sourceGUID, _, _, _, targetGUID, _, _, _, spellId = ...

        if spellId ~= 410089 or sourceGUID ~= WeakAuras.myGUID then
            return false
        end

        local unit = UnitTokenFromGUID(targetGUID)

        if not unit then
            return false
        end

        local duration = 0

        for i = 1, 255 do
            local _, _, _, _, dur, _, source, _, _, spellId = UnitBuff(unit, i)
            if spellId == 410089 and source == "player" then
                duration = dur
                break
            end
        end

        if not states[""] then
            states[""] = {
                stacks = 2,
                show = true,
                changed = true,
                autoHide = false,
                progressType = "static"
            }
        end

        states[""].stacks = duration > 30 and 2 or states[""].stacks - 1
        states[""].changed = true
        states[""].show = true

        return true
    end

    return false
end
