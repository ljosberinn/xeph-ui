-- STATUS, PLAYER_ENTERING_WORLD, XEPHUI_AUG_VUHDO_MANUAL_OVERRIDE_UPDATE, UNIT_SPEC_CHANGED_party1, UNIT_SPEC_CHANGED_party2, UNIT_SPEC_CHANGED_party3, UNIT_SPEC_CHANGED_party4, UNIT_SPEC_CHANGED_raid1, UNIT_SPEC_CHANGED_raid2, UNIT_SPEC_CHANGED_raid3, UNIT_SPEC_CHANGED_raid4, UNIT_SPEC_CHANGED_raid5, UNIT_SPEC_CHANGED_raid6, UNIT_SPEC_CHANGED_raid7, UNIT_SPEC_CHANGED_raid8, UNIT_SPEC_CHANGED_raid9, UNIT_SPEC_CHANGED_raid10, UNIT_SPEC_CHANGED_raid11, UNIT_SPEC_CHANGED_raid12, UNIT_SPEC_CHANGED_raid13, UNIT_SPEC_CHANGED_raid14, UNIT_SPEC_CHANGED_raid15, UNIT_SPEC_CHANGED_raid16, UNIT_SPEC_CHANGED_raid17, UNIT_SPEC_CHANGED_raid18, UNIT_SPEC_CHANGED_raid19, UNIT_SPEC_CHANGED_raid20, UNIT_SPEC_CHANGED_raid21, UNIT_SPEC_CHANGED_raid22, UNIT_SPEC_CHANGED_raid23, UNIT_SPEC_CHANGED_raid24, UNIT_SPEC_CHANGED_raid25, UNIT_SPEC_CHANGED_raid26, UNIT_SPEC_CHANGED_raid27, UNIT_SPEC_CHANGED_raid28, UNIT_SPEC_CHANGED_raid29, UNIT_SPEC_CHANGED_raid30, UNIT_SPEC_CHANGED_raid31, UNIT_SPEC_CHANGED_raid32, UNIT_SPEC_CHANGED_raid33, UNIT_SPEC_CHANGED_raid34, UNIT_SPEC_CHANGED_raid35, UNIT_SPEC_CHANGED_raid36, UNIT_SPEC_CHANGED_raid37, UNIT_SPEC_CHANGED_raid38, UNIT_SPEC_CHANGED_raid39, UNIT_SPEC_CHANGED_raid40
--- @param event "PLAYER_ENTERING_WORLD" | "UNIT_SPEC_CHANGED" | "XEPHUI_AUG_VUHDO_MANUAL_OVERRIDE_UPDATE"
function (_, event, ...)
    if not aura_env.active or not event then
        return false
    end

    if string.find(event, "UNIT_SPEC_CHANGED") ~= nil then
        local unit = ...
        local specId = WeakAuras.SpecForUnit(unit)
        local name = UnitName(unit)

        if name then
            aura_env.nameToSpecIdMap[name] = specId

            if specId then
                local _, specName, _, icon = GetSpecializationInfoByID(specId)
                local className = UnitClassBase(unit)

                aura_env.log("received spec for " .. aura_env.formattedSpecIconWithName(specName, icon, className, name))
            end

            aura_env.setup("UNIT_SPEC_CHANGED")
        end

        return false
    end

    if event == "STATUS" then
        for unit in WA_IterateGroupMembers() do
            if not UnitIsUnit(unit, "player") then
                local specId = WeakAuras.SpecForUnit(unit)
                local name = UnitName(unit)

                if name then
                    aura_env.nameToSpecIdMap[name] = specId

                    if specId then
                        local _, specName, _, icon = GetSpecializationInfoByID(specId)
                        local className = UnitClassBase(unit)

                        aura_env.log(aura_env.formattedSpecIconWithName(specName, icon, className, name))
                    end
                end
            end
        end

        aura_env.setup("UNIT_SPEC_CHANGED")

        return false
    end

    if event == "READY_CHECK" or event == "PLAYER_ENTERING_WORLD" or event == aura_env.customEventName then
        if event == aura_env.customEventName then
            local id = ...

            if id ~= aura_env.id then
                return false
            end
        end

        aura_env.setup(event)
    end

    return false
end
