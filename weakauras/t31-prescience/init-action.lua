aura_env.active = false
aura_env.intercept = false

--- @param states T31_PrescienceState
--- @param aura AuraData|nil
--- @return boolean
aura_env.maybeUpdateState = function(states, aura)
    if not aura or aura.sourceUnit ~= "player" or aura.spellId ~= 410089 then
        return false
    end
    
    states[""].stacks = aura.duration > 30 and 2 or states[""].stacks - 1
    states[""].changed = true
    states[""].show = true
    
    aura_env.intercept = false
    
    return true
end