function ()
    if aura_env.currentFragments == 0 then
        return aura_env.maxHealth - 1, aura_env.maxHealth, true
    end

    local recentDamageTaken = aura_env.getSumOfRecentDamageTaken()

    if recentDamageTaken == 0 then
        return aura_env.maxHealth - 1, aura_env.maxHealth, true
    end

    local percent =
        math.max(0.06 * recentDamageTaken / aura_env.maxHealth, 0.01) * 1.1 * aura_env.getCurrentVersatilityFactor()

    if aura_env.divineHymnStacks > 0 then
        percent = percent * (1 + aura_env.divineHymnStacks * 4 / 100)
    end

    if aura_env.luckyOfTheDrawStacks > 0 then
        percent = percent * (1 + aura_env.luckyOfTheDrawStacks * 5 / 100)
    end

    if aura_env.guardianSpiritActive then
        percent = percent * 1.6
    end

    if aura_env.blessingOfSpringActive then
        percent = percent * 1.3
    end

    if aura_env.hasT302SetEquipped then
        percent = percent * 1.1
    end

    local expectedHeal = percent * aura_env.maxHealth * aura_env.currentFragments
    local postHeal = aura_env.currentHealth + expectedHeal

    if postHeal >= aura_env.maxHealth then
        return aura_env.maxHealth, aura_env.maxHealth, true
    end

    return postHeal, aura_env.maxHealth, true
end
