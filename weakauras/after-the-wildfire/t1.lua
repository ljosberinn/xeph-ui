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

        if subEvent == "SPELL_AURA_APPLIED" then
            local _, _, _, sourceGUID, _, _, _, _, _, _, _, spellId = ...

            if sourceGUID ~= WeakAuras.myGUID then
                return hasChanges
            end

            if spellId == aura_env.buffs.incarn.id then
                aura_env.buffs.incarn.active = true
            elseif spellId == aura_env.buffs.toothAndClaws.id then
                aura_env.buffs.toothAndClaws.active = true
            elseif spellId == aura_env.buffs.goryFur.id then
                aura_env.buffs.goryFur.active = true
            end

            return hasChanges
        elseif subEvent == "SPELL_AURA_REMOVED" then
            local _, _, _, sourceGUID, _, _, _, _, _, _, _, spellId = ...

            if sourceGUID ~= WeakAuras.myGUID then
                return hasChanges
            end

            if spellId == aura_env.buffs.incarn.id then
                aura_env.buffs.incarn.active = false
            elseif spellId == aura_env.buffs.toothAndClaws.id then
                aura_env.buffs.toothAndClaws.active = false
            elseif spellId == aura_env.buffs.goryFur.id then
                aura_env.buffs.goryFur.active = false
            end

            return hasChanges
        elseif subEvent == "SPELL_HEAL" then
            -- heal fires once per target hit, guard against only the first event
            if states[""].value < 150 then
                return hasChanges
            end

            local _, _, _, sourceGUID, _, _, _, _, _, _, _, spellId = ...

            if sourceGUID ~= WeakAuras.myGUID or spellId ~= 371982 then
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
        local cost = 0

        if spellId == 400254 and not aura_env.buffs.toothAndClaws.active then
            if aura_env.buffs.incarn.active then
                cost = 20
            else
                cost = 40
            end
        elseif spellId == 6807 and not aura_env.buffs.toothAndClaws.active then
            if aura_env.buffs.incarn.active then
                cost = 20
            else 
                cost = 40
            end
        elseif spellId == 192081 then
            if aura_env.buffs.incarn.active then
                if aura_env.buffs.goryFur.active then
                    cost = 15
                else
                    cost = 20
                end
            elseif aura_env.buffs.goryFur.active then
                cost = 30
            else
                cost = 40
            end
        end

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