--- @class EssenceState2
--- @field show boolean
--- @field value number
--- @field total number
--- @field progressType "static" | "timed"
--- @field expirationTime number
--- @field duration number
--- @field changed boolean
--- @field power number

function aura_env.getEssences()
    return UnitPower("player", Enum.PowerType.Essence)
end

function aura_env.getMaxEssences()
    return UnitPowerMax("player", Enum.PowerType.Essence)
end

--- @return number
function aura_env.getEssenceRegenerationSpeed()
    local peace = GetPowerRegenForPowerType(Enum.PowerType.Essence)

    if peace == nil or peace == 0 then
        peace = 0.2
    end

    return 5 / (5 / (1 / peace))
end

aura_env.currentEssences = 0
aura_env.maxEssences = aura_env.getMaxEssences()

--- @param state EssenceState2
--- @param changes table<string, boolean|number|string>
--- @return boolean
function aura_env.updateState(state, changes)
    local changed = false

    for key, value in pairs(changes) do
        if state[key] ~= value then
            state[key] = value
            state.changed = true

            changed = true
        end
    end

    return changed
end
