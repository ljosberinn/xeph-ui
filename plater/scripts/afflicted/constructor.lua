function (scriptTable)
    local spells = {
        [409465] = scriptTable.config.curseColor, -- Cursed Spirit
        [409472] = scriptTable.config.diseaseColor, -- Diseased Spirit
        [409470] = scriptTable.config.poisonColor, -- Poisoned Spirit
    }

    --- @param unit string
    --- @return string|nil
    scriptTable.determineDebuffColor = function(unit)
        for i = 0, 30 do
            local _, _, _, _, _, _, _, _, _, spellId = UnitAura(unit, i, "HARMFUL")

            if spellId and spells[spellId] ~= nil then
                return spells[spellId]
            end
        end

        return nil
    end
end
