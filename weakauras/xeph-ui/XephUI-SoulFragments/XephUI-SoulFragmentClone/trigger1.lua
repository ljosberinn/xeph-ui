-- UNIT_AURA:player,TRIGGER:2
--- @class SoulFragmentCloneState
--- @field show boolean
--- @field total 5
--- @field value number
--- @field index number
--- @field progressType "static"
--- @field changed boolean

--- @param allstates table<number, SoulFragmentCloneState>
--- @param event "UNIT_AURA" | "TRIGGER" | "OPTIONS" | "STATUS"
--- @param updatedTriggerNumber nil | number | string
--- @param updatedTriggerStates table
--- @return boolean
function (allstates, event, updatedTriggerNumber, updatedTriggerStates)
    local stacks = aura_env.getStacks()
    aura_env.currentStacks = stacks

    local shouldPerformFullUpdate, canBail =
        aura_env.shouldPerformFullUpdate(event, updatedTriggerNumber, updatedTriggerStates)

    if canBail then
        return false
    end

    local hasChanges = shouldPerformFullUpdate

    for i = 1, 5, 1 do
        local value = stacks >= i and 1 or 0

        if allstates[i] then
            local changed = shouldPerformFullUpdate or allstates[i].value ~= value
            hasChanges = true

            if changed then
                allstates[i].value = value
                allstates[i].changed = true
            end
        else
            allstates[i] = {
                show = true,
                index = i,
                progressType = "static",
                value = value,
                total = 5,
                changed = true
            }
        end
    end

    aura_env.lastStacks = stacks

    return hasChanges or event == "STATUS"
end
