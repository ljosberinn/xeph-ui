-- UNIT_POWER_FREQUENT:player, UNIT_MAXPOWER:player, OPTIONS, STATUS
--- @class State
--- @field duration number
--- @field expirationtime number
--- @field progressType "timed" | "static"
--- @field show boolean
--- @field value 0 | 1
--- @field total 1
--- @field power number

--- @param states table<number, State>
--- @param event "STATUS" | "OPTIONS" | "UNIT_POWER_FREQUENT" | "UNIT_MAXPOWER"
--- @param unit nil | string
--- @param powerType nil | string
--- @return boolean
function f(states, event, unit, powerType)
    local isStatusOrOptions = event == "OPTIONS" or event == "STATUS"

    if not isStatusOrOptions and powerType and powerType ~= "ESSENCE" then
        return false
    end

    if not isStatusOrOptions and unit ~= "player" then
        return false
    end

    local power = aura_env.getCurrentPower()
    local maxPower = aura_env.getMaxPower()

    -- skip if power didn't change since last update, events trigger too many times it weird
    if not isStatusOrOptions and power == aura_env.lastPower and maxPower == aura_env.lastMaxPower then
    --return
    end

    local rechargeRate = aura_env.getCurrentRegenerationRate()
    local now = GetTime()

    local anyUpdate = false

    for essence = 1, 6 do
        if essence > maxPower then
            if states[essence] then
                states[essence].show = false
                states[essence].changed = true
            end
        else
            states[essence] =
                states[essence] or
                {
                    progressType = "timed",
                    index = essence
                }

            if essence == power + 1 then
                local lastRemaining = 0

                if aura_env.lastPower and essence < aura_env.lastPower then
                    local lastState = states[aura_env.lastPower + 1]

                    if lastState and lastState.progressType == "timed" then
                        local remaining = lastState.duration - ((lastState.expirationTime or 0) - now)
                        if remaining > 0 then
                            lastRemaining = remaining
                        end
                    end
                end

                local updated =
                    aura_env.updateState(
                    states[essence],
                    {
                        duration = rechargeRate,
                        expirationTime = (rechargeRate - lastRemaining) + now,
                        progressType = "timed",
                        show = true,
                        power = power
                    }
                )
                anyUpdate = anyUpdate or updated
            elseif essence <= power then
                local updated =
                    aura_env.updateState(
                    states[essence],
                    {
                        value = 1,
                        total = 1,
                        progressType = "static",
                        show = true,
                        power = power
                    }
                )
                anyUpdate = anyUpdate or updated
            else
                local updated =
                    aura_env.updateState(
                    states[essence],
                    {
                        value = 0,
                        total = 1,
                        progressType = "static",
                        show = true,
                        power = power
                    }
                )
                anyUpdate = anyUpdate or updated
            end
        end
    end

    aura_env.lastPower = power
    aura_env.lastMaxPower = maxPower

    return anyUpdate
end
