-- GROUP_ROSTER_UPDATE, XEPHUI_AUG_VUHDO_MANUAL_OVERRIDE_UPDATE, PLAYER_SPECIALIZATION_CHANGED, INSPECT_READY
--- @param event "OPTIONS" | "GROUP_ROSTER_UPDATE" | "XEPHUI_AUG_VUHDO_MANUAL_OVERRIDE_UPDATE" | "PLAYER_SPECIALIZATION_CHANGED" | "INSPECT_READY"
function (event, ...)
    if not aura_env.active then
        return false
    end

    if event == "PLAYER_SPECIALIZATION_CHANGED" then
        local unit = ...

        if unit == "player" or not CanInspect(unit) then
            return false
        end

        local name = UnitName(unit) or unit

        if aura_env.awaitingInspect[name] then
            return false
        end

        aura_env.awaitingInspect[name] = GetTime()
        aura_env.log(WA_ClassColorName(unit) .. " switched spec or joined group. requesting info")

        NotifyInspect(unit)

        return false
    end

    if event == "INSPECT_READY" then
        local guid = ...

        if guid == WeakAuras.myGUID then
            return false
        end

        local token = UnitTokenFromGUID(guid)

        if not token then
            return false
        end

        local name = UnitName(token)

        if not name or aura_env.awaitingInspect[name] == nil then
            return false
        end

        local diff = math.floor(GetTime() - aura_env.awaitingInspect[name])

        aura_env.awaitingInspect[name] = nil
        aura_env.inspectedSpecMap[name] = GetInspectSpecialization(token)

        local label = aura_env.getColoredLabelFor(name, nil, nil, token)
        local diff = "(elapsed inspect time: " .. diff .. "s)"

        aura_env.log(label .. " " .. diff)

        if IsInRaid() then
            aura_env.doRaidUpdate(event)
        elseif IsInGroup() then
            aura_env.doGroupUpdate(event)
        end

        return false
    end

    if event == "OPTIONS" or event == "GROUP_ROSTER_UPDATE" or event == aura_env.customEventName then
        if event == aura_env.customEventName then
            local id = ...

            if id ~= aura_env.id then
                return false
            end
        end

        if IsInRaid() then
            aura_env.doRaidUpdate(event)
        elseif IsInGroup() then
            aura_env.doGroupUpdate(event)
        end
    end

    return false
end
