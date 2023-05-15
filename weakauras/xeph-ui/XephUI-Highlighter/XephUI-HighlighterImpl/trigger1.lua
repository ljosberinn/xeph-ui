-- CLEU:SPELL_MISSED, CLEU:SPELL_PERIODIC_MISSED, CLEU:SPELL_AURA_REMOVED, CLEU:SPELL_AURA_APPLIED, CLEU:SPELL_DAMAGE, CLEU:SPELL_HEAL, CLEU:SPELL_PERIODIC_DAMAGE, CLEU:SPELL_PERIODIC_HEAL, UNIT_SPELLCAST_SUCCEEDED:player, XEPHUI_Highlighter, CLEU:SPELL_AURA_APPLIED_DOSE, CLEU:SPELL_AURA_REMOVED_DOSE, PLAYER_REGEN_ENABLED

--- @class HighlighterState
--- @field show boolean
--- @field changed boolean
--- @field stacks number
--- @field duration number
--- @field expirationTime number
--- @field autoHide true
--- @field progressType "timed"
--- @field icon number

--- @param states table<number, HighlighterState>
--- @param event "COMBAT_LOG_EVENT_UNFILTERED" | "STATUS" | "OPTIONS" | "UNIT_SPELLCAST_SUCCEEDED" | "XEPHUI_Highlighter" | "PLAYER_REGEN_ENABLED"
--- @return boolean
function (states, event, ...)
    if not aura_env.active then
        return false
    end

    if event == "PLAYER_REGEN_ENABLED" then
        return aura_env.onPlayerRegenEnabled()
    end

    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local subEvent = select(2, ...)
        local handler = aura_env.cleuMap[subEvent]

        if handler then
            local hasChanges = handler(...)

            if hasChanges then
                aura_env.queue()
            end
        end

        return false
    end

    if event == "UNIT_SPELLCAST_SUCCEEDED" then
        local spellId = select(3, ...)
        local hasChanges = aura_env.onSpellCastSuccess(spellId)

        if hasChanges then
            aura_env.queue()
        end

        return false
    end

    if event == aura_env.customEventName then
        local id = ...

        if id ~= aura_env.id then
            return false
        end

        aura_env.nextFrame = nil

        local hasChanges = aura_env.expireOutdatedData(aura_env.dirtyIndices, false)
        local now = GetTime()

        for index in pairs(aura_env.dirtyIndices) do
            local total, icon = aura_env.getDisplayDataForIndex(index)

            if states[index] then
                if states[index].stacks ~= total then
                    hasChanges = true

                    states[index].changed = true
                    states[index].stacks = total

                    -- on successful spellcast, this may be empty, so expire instantly in order to hide the icon while no value is shown anyways
                    if total == 0 then
                        states[index].show = false
                        states[index].expirationTime = now
                    else
                        states[index].expirationTime = now + aura_env.config.duration
                    end
                end
            elseif total > 0 then
                hasChanges = true

                states[index] = {
                    show = true,
                    changed = true,
                    stacks = total,
                    duration = aura_env.config.duration,
                    expirationTime = now + aura_env.config.duration,
                    autoHide = true,
                    progressType = "timed",
                    icon = icon
                }
            end
        end

        return hasChanges
    end

    return false
end
