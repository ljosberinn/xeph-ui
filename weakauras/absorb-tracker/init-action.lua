function aura_env.getTotalAbsorb()
    return UnitGetTotalAbsorbs("player")
end

function aura_env.getMaxHealth()
    return UnitHealthMax("player")
end

aura_env.ratio = tonumber(aura_env.config.ratio)