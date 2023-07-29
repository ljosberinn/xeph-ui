-- TRIGGER:1
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
--- @param event "STATUS" | "OPTIONS" | "TRIGGER"
--- @returns boolean
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

    if event == "TRIGGER" then
        local updatedTriggerNumber, updatedTriggerStates = ...

        if updatedTriggerNumber ~= 1 or not updatedTriggerStates then
            return hasChanges
        end

        local tooltip1 = 0

        for _, state in pairs(updatedTriggerStates) do
            tooltip1 = state.tooltip1
        end

        local nextValue = 200 - tooltip1

        if nextValue ~= states[""].value then
            hasChanges = true
            states[""].value = nextValue
            states[""].changed = true
        end

        return hasChanges
    end

    return hasChanges
end