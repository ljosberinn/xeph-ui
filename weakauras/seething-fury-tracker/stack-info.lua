function()
    local value = aura_env.threshold - aura_env.furySpent

    aura_env.log("pseudo stacks: " .. value)
    
    if value < 0 then
        return aura_env.threshold - math.abs(value)
    end
    
    return value
end

