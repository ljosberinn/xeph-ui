aura_env.furySpent = 0
aura_env.threshold = 175
aura_env.seethingFuryBuffId = 408737

aura_env.seethingFuryActive = WA_GetUnitBuff("player", aura_env.seethingFuryBuffId) ~= nil

aura_env.abilities = {
    [342817] = { -- glaive tempest
        determineCost = function()
            return 30
        end,
    },
    [185123] = { -- throw glaive
        determineCost = function()
            if IsPlayerSpell(393029) then -- Furious Throws
                return 25
            end

            return 0
        end
    },
    [162794] = { -- chaos strike
        determineCost = function()
            return 40
        end,
    },
    [201427] = { -- annihilation
        determineCost = function()
            return 40
        end,
    },
    [210152] = { --death sweep
        determineCost = function()
            return 35
        end,
    },
    [188499] = { -- blade dance
        determineCost = function()
            return 35
        end,
    },
    [198013] = { -- eye beam
        determineCost = function()
            return 30
        end,
    },
    [211881] = { -- fel eruption
        determineCost = function()
            return 10
        end,
    },
    [179057] = { -- chaos nova
        determineCost = function()
            if IsPlayerSpell(206477) then -- Unrestrained Fury
                return 15
            end

            return 30
        end
    }
}