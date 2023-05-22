aura_env.lastPower = -1

--- @return number
local function GetEssenceCooldown()
    local rechargeRate = GetPowerRegenForPowerType(Enum.PowerType.Essence)

    if rechargeRate == nil or rechargeRate == 0 then
        rechargeRate = 0.2
    end

    return 1 / rechargeRate
end


--- @class EssenceState
--- @field show boolean
--- @field value number
--- @field total number
--- @field progressType "static" | "timed"
--- @field expirationTime number
--- @field duration number
--- @field changed boolean
--- @field power number

--- @param state EssenceState
--- @param changes table
--- @return boolean
local function UpdateState(state, changes)
    local updated = false
    for key, value in pairs(changes) do
        if state[key] ~= value then
            state[key] = value
            state.changed = true
            updated = true
        end
    end

    return updated
end

--- @param essence number
--- @param power number
--- @param state EssenceState
--- @return boolean
local function UpdateProgress(essence, power, state)
    if essence == power + 1 then
        local duration = GetEssenceCooldown()

        return UpdateState(
            state,
            {
                duration = duration,
                expirationTime = GetTime() + duration,
                progressType = "timed",
                show = true,
                power = power,
            }
        )
    end

    if essence <= power then
        return UpdateState(
            state,
            {
                value = 1,
                total = 1,
                progressType = "static",
                show = true,
                power = power,
            }
        )
    end

    return UpdateState(
        state,
        {
            value = 0,
            total = 1,
            progressType = "static",
            show = true,
            power = power,
        }
    )
end

--- @param states table<number, EssenceState>
--- @return boolean
local function Initialize(states, maxPower)
    for essence = 1, 6 do
        if states[essence] == nil then
            states[essence] = {
                progressType = "timed",
                index = essence
            }
        end
    end

    if maxPower == 5 and states[6].show then
        states[6].show = false

        return true
    end

    return false
end

--- @param states table<number, EssenceState>
--- @param power number
--- @param maxPower number
--- @return boolean
local function Update(states, power, maxPower)
    local didUpdate = false
    for essence = 1, maxPower do
        if UpdateProgress(essence, power, states[essence]) then
            didUpdate = true
        end
    end

    return didUpdate
end

--- @param states table<number, EssenceState>
--- @return boolean
function aura_env.trigger(states)
    local maxPower = UnitPowerMax("player", Enum.PowerType.Essence)
    local power = UnitPower("player", Enum.PowerType.Essence)

    if power == aura_env.lastPower and #states ~= 0 then
        return false
    end

    aura_env.lastPower = power

    return Initialize(states, maxPower) or Update(states, power, maxPower)
end

-- Hide SHadowedUnitFrames Essence dot display on player frame which cannot be hidden via settings
if SUFUnitplayer and SUFUnitplayer.essence then
    SUFUnitplayer.essence:Hide()
end

