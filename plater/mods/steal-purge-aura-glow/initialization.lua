function (modTable)
    local options1 = {
        glowType = "button",
        frequency = modTable.config.SPglowfreq
    }

    local options2 = {
        glowType = "pixel",
        N = modTable.config.SPglowparticle,
        frequency = modTable.config.SPglowfreq,
        length = modTable.config.SPpixellength,
        th = modTable.config.SPpixelth,
        xOffset = modTable.config.SPglowxoff,
        yOffset = modTable.config.SPglowyoff,
        border = modTable.config.SPpixelborder
    }

    local options3 = {
        glowType = "ants",
        N = modTable.config.SPglowparticle,
        frequency = modTable.config.SPglowfreq,
        scale = modTable.config.SPantsscale,
        xOffset = modTable.config.SPglowxoff,
        yOffset = modTable.config.SPglowyoff
    }

    modTable.options =
        (modTable.config.SPglownum == 1 and options1) or (modTable.config.SPglownum == 2 and options2) or
        (modTable.config.SPglownum == 3 and options3)

    local doNotPurgeList = {
        [385063] = true, -- Burning Ambition, Ruby Life Pools
        [392454] = true, -- Burning Veins, Ruby Life Pools
        [396020] = true, -- Golden Barrier, Temple of the Jade Serpent
        [383161] = true -- Decay Infusion, Brackenhide Hollow
    }

    for _, id in pairs(modTable.config.doNotPurge) do
        doNotPurgeList[tonumber(id)] = true
    end

    modTable.doNotPurge = function(id)
        return doNotPurgeList[id] ~= nil
    end
end
