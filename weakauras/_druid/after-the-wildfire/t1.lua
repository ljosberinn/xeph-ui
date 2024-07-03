-- CLEU:SPELL_AURA_APPLIED, CLEU:SPELL_AURA_REMOVED, CLEU:SPELL_HEAL, UNIT_SPELLCAST_SUCCEEDED:player
--- @class AfterTheWildfireState
--- @field show boolean
--- @field changed boolean
--- @field stacks number
--- @field duration number
--- @field expirationTime number
--- @field autoHide boolean
--- @field progressType "timed"
--- @field icon number

--- @param states table<number, AfterTheWildfireState>
--- @param event "STATUS" | "OPTIONS" | "COMBAT_LOG_EVENT_UNFILTERED" | "UNIT_SPELLCAST_SUCCEEDED"
--- @return boolean
function (states, event, ...)
    local hasChanges = false

    if not states[""] then
        hasChanges = true

        states[""] = {
            show = true,
            changed = true,
            progressType = "static",
            value = 0,
            total = 200,
            autoHide = false
        }
    end

    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local subEvent = select(2, ...)
        local sourceGUID = select(4, ...)

        if sourceGUID ~= WeakAuras.myGUID then
            return hasChanges
        end

        local spellId = select(12, ...)

        if subEvent == "SPELL_AURA_APPLIED" then
            aura_env.applyBuff(spellId)

            return hasChanges
        end

        if subEvent == "SPELL_AURA_REMOVED" then
            aura_env.removeBuff(spellId)

            return hasChanges
        end

        if subEvent == "SPELL_HEAL" then
            -- heal fires once per target hit, guard against only the first event
            if states[""].value < 150 or spellId ~= 371982 then
                return hasChanges
            end

            hasChanges = true

            states[""].value = aura_env.leftovers
            states[""].changed = true
            aura_env.leftovers = 0
        end

        return hasChanges
    end

    if event == "UNIT_SPELLCAST_SUCCEEDED" then
        local spellId = select(3, ...)
        if not spellId then
            return hasChanges
        end

        local cost = aura_env.getRageCostForSpell(spellId)

        if cost == 0 then
            return hasChanges
        end

        hasChanges = true

        local nextValue = states[""].value + cost

        if nextValue > 200 then
            aura_env.leftovers = nextValue - 200
            nextValue = 200
        else
            aura_env.leftovers = 0
        end

        states[""].value = nextValue
        states[""].changed = true
    end

    return hasChanges
end
