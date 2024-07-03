local buffs = {
    goryFur = {
        active = false,
        id = 201671
    },
    toothAndClaws = {
        active = false,
        id = 135286
    },
    incarn = {
        active = false,
        id = 102558
    }
}

aura_env.leftovers = 0

--- @param id number
aura_env.removeBuff = function(id)
    if id == buffs.incarn.id then
        buffs.incarn.active = false
        return
    end

    if id == buffs.toothAndClaws.id then
        buffs.toothAndClaws.active = false
        return
    end

    if id == buffs.goryFur.id then
        buffs.goryFur.active = false
    end
end

--- @param id number
aura_env.applyBuff = function(id)
    if id == buffs.incarn.id then
        buffs.incarn.active = true
        return
    end

    if id == buffs.toothAndClaws.id then
        buffs.toothAndClaws.active = true
        return
    end

    if id == buffs.goryFur.id then
        buffs.goryFur.active = true
    end
end

--- @param id number
--- @return number
aura_env.getRageCostForSpell = function(id)
    if id == 400254 then
        if buffs.toothAndClaws.active then
            return 0
        end

        return buffs.incarn.active and 20 or 40
    end

    if id == 6807 then
        if buffs.toothAndClaws.active then
            return 0
        end

        return buffs.incarn.active and 20 or 40
    end

    if id == 192081 then
        if buffs.incarn.active then
            return buffs.goryFur.active and 15 or 20
        end

        return buffs.goryFur.active and 30 or 40
    end

    return 0
end
