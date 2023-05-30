function (allstates)
    if not aura_env.last or GetTime() - aura_env.last > aura_env.config.throttle then
        aura_env.last = GetTime()

        local count = 0

        for i = 1, 40 do
            local unit = "nameplate" .. i

            if
                UnitCanAttack("player", unit) and aura_env.unitIsIrrelevant(unit) == false and
                    (not aura_env.config.combat or UnitAffectingCombat(unit)) and
                    WeakAuras.CheckRange(unit, aura_env.config.range, "<=")
             then
                count = count + 1
            end
        end

        if count >= aura_env.config.trigger then
            allstates[""] = allstates[""] or {show = true}
            allstates[""].stacks = count
            allstates[""].changed = true
            return true
        elseif allstates[""] then
            allstates[""].show = false
            allstates[""].changed = true
            return true
        end
    end

    return false
end
