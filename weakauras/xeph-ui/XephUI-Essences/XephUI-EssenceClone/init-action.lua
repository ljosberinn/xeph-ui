--- @return number
aura_env.getCurrentPower = function()
    return UnitPower("player", Enum.PowerType.Essence)
end

--- @return number
aura_env.getMaxPower = function()
    return UnitPowerMax("player", Enum.PowerType.Essence)
end

--- @return number
aura_env.getCurrentRegenerationRate = function()
    local rate = GetPowerRegenForPowerType(Enum.PowerType.Essence)
    
    if rate == nil or rate == 0 then
        rate = 0.2
    end
    
    return 5 / (5 / (1 / rate))
end

--- @param state table<number, State>
--- @param changes table
--- @return boolean
aura_env.updateState = function(state, changes)
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

aura_env.lastPower = 0
aura_env.lastMaxPower = 0

-- Hide SHadowedUnitFrames Essence dot display on player frame which cannot be hidden via settings
if SUFUnitplayer and SUFUnitplayer.essence then
    SUFUnitplayer.essence:Hide()
end