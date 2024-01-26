-- CLEU:SPELL_AURA_APPLIED, CLEU:SPELL_AURA_REFRESH, TRIGGER:2, PLAYER_DEAD, XEPHUI_PRESCIENCE_T31
--- @class T31_PrescienceState
--- @field show boolean
--- @field changed boolean
--- @field stacks number
--- @field autoHide boolean
--- @field progressType "static"

--- @param states table<"", T31_PrescienceState>
--- @param event "OPTIONS" | "STATUS" | "COMBAT_LOG_EVENT_UNFILTERED" | "PLAYER_DEAD" | "XEPHUI_PRESCIENCE_T31"
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

    if event == "PLAYER_DEAD" and states[""] ~= nil then
        states[""].changed = states[""].stacks ~= 0
        states[""].stacks = 0
        states[""].show = false

        return true
    end

    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local _, _, _, sourceGUID, _, _, _, targetGUID, _, _, _, spellId = ...

        if spellId ~= 410089 or sourceGUID ~= WeakAuras.myGUID or string.find(targetGUID, "Pet") ~= nil then
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

        if duration == 0 then
            aura_env.queue(unit, 1)
            return false
        end

        aura_env.performUpdate(states, duration)

        return true
    end

    if event == aura_env.customEventName then
        local id, unit, count = ...

        if id ~= aura_env.id then
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

        if duration == 0 then
            aura_env.queue(unit, count + 1)
            return false
        end

        aura_env.performUpdate(states, duration)

        return true
    end

    return false
end
