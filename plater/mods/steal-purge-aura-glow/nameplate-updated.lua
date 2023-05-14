function (self, unitId, unitFrame, envTable, modTable)
    if not unitFrame.healthBar:IsShown() then
        return
    end

    local buffSpecialGlow = true
    local color = modTable.config.SPglowcolor

    -- functions --
    local auraContainers = {unitFrame.BuffFrame.PlaterBuffList}

    if (Plater.db.profile.buffs_on_aura2) then
        auraContainers[2] = unitFrame.BuffFrame2.PlaterBuffList
    end

    for containerID = 1, #auraContainers do
        local auraContainer = auraContainers[containerID]

        for _, auraIcon in ipairs(auraContainer) do
            if (auraIcon:IsShown() and auraIcon.CanStealOrPurge and not modTable.doNotPurge(auraIcon.SpellId)) then
                Plater.StartGlow(auraIcon, nil, modTable.options)
            else
                Plater.StopGlow(auraIcon, modTable.options.glowType, modTable.options.key)
            end
        end
    end

    if buffSpecialGlow then
        for _, auraIcon in ipairs(unitFrame.ExtraIconFrame.IconPool) do
            if auraIcon:IsShown() then
                if (auraIcon.canStealOrPurge and not modTable.doNotPurge(auraIcon.SpellId)) then
                    Plater.StartGlow(auraIcon, nil, modTable.options)
                else
                    Plater.StopGlow(auraIcon, modTable.options.glowType, modTable.options.key)
                end
            end
        end
    end
end
