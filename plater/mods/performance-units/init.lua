function (modTable)
    if not Plater.AddPerformanceUnits then
        return
    end

    local units = {
        -- Raids
        [189706] = true, --Chaotic Essence
        [189707] = true, -- Chaotic mote
        [176920] = true, -- Domination Arrow
        [196679] = true, -- Frozen Shroud -- Broodkeeper
        [194999] = true, -- Volatile Spark -- Raszageth
        [191714] = true, -- Seeking Stormling -- Raszageth
        [210231] = true, -- Tainted Lasher -- Gnarlroot
        [211306] = true, -- Fiery Veins -- Tindral Sageswift
        [214441] = true, -- Scorched Treant, Tindral
        -- Dungeons
        [196642] = false, -- Hungry Lasher (Boss add)
        [197398] = false, -- Hungry Lasher
        [208994] = true, -- Infected Lasher
        [189363] = true, -- Infected Lasher
        [96247] = true, -- Vileshard Crawler
        [100991] = true -- Strangling Roots

        --Testing
        --[198594] = false, -- Testing target dummy
        --[161890] = false, -- testing
    }

    for unit, flag in pairs(units) do
        if flag then
            if flag and modTable.config.performance then
                Plater.AddPerformanceUnits(unit)
            else
                Plater.RemovePerformanceUnits(unit)
            end
            if flag and modTable.config.forceBlizz then
                Plater.AddForceBlizzardNameplateUnits(unit)
            else
                Plater.RemoveForceBlizzardNameplateUnits(unit)
            end
        end
    end
end
