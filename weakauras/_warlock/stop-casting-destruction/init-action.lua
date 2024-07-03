aura_env.incinerateCastId = 29722
aura_env.immolateDebuffId = 157736
aura_env.havocDebuffId = 80240

local havocableSpells = {
    [17982] = true, -- conflagrate
    [116858] = true, -- chaos bolt
    [aura_env.incinerateCastId] = true,
    [348] = true -- immolate
}

aura_env.isHavocableSpell = function(id)
    return havocableSpells[id] == true
end
