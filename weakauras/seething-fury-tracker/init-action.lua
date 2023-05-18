aura_env.prevFury = 0
aura_env.currentFury = 0
aura_env.furySpent = 0
aura_env.threshold = 175
aura_env.seethingFuryActive = false

--- @return boolean
local function isSeethingFuryActive()
    return WA_GetUnitBuff("player", 408737) ~= nil
end

--- @return number
local function getCurrentFury()
    return UnitPower("player", 17)
end

do
    local currentFury = getCurrentFury()
    aura_env.prevFury = currentFury
    aura_env.currentFury = currentFury
    aura_env.seethingFuryActive = isSeethingFuryActive()
end

local abilities = {
    [185123] = {
        determineCost = function()
            return 25
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

aura_env.onPlayerAuraUpdate = function()
    local hasBuff = isSeethingFuryActive()

    if hasBuff and not aura_env.seethingFuryActive then
        aura_env.seethingFuryActive = true

        local remainder = aura_env.furySpent - aura_env.threshold

        if remainder <= 0 then
            aura_env.furySpent = 0
        else
            aura_env.furySpent = remainder
        end

    elseif not hasBuff and aura_env.seethingFuryActive then
        aura_env.seethingFuryActive = false
    end
end

aura_env.onPlayerSpellCastSuccess = function(spellId)
    if not abilities[spellId] then
        return
    end
    
    local cost = abilities[spellId].determineCost()
    
    if cost and cost > 0 then
        aura_env.furySpent = aura_env.furySpent + cost
    end
end