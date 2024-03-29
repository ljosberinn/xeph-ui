-- UNIT_SPELLCAST_SUCCEEDED, CLEU:SPELL_AURA_APPLIED, CLEU:SPELL_AURA_REFRESH, CLEU:SPELL_AURA_REMOVED, XEPHUI_CD_CHECK
--- @class GroupCDsState
--- @field show boolean
--- @field changed boolean
--- @field duration number
--- @field expirationTime number
--- @field autoHide boolean
--- @field progressType "timed"
--- @field icon number

--- @param states table<number, GroupCDsState>
--- @param event "STATUS" | "OPTIONS" | "UNIT_SPELLCAST_SUCCEEDED" | "COMBAT_LOG_EVENT_UNFILTERED" | "XEPHUI_CD_CHECK"
--- @return boolean
function (states, event, ...)
    if event == "UNIT_SPELLCAST_SUCCEEDED" then
        local unit, castGUID, spellId = ...

        if unit == "player" then
            return false
        end

        local duration = aura_env.trackedCasts[spellId]

        if not duration then
            return false
        end

        if not UnitIsFriend("player", unit) then
            return false
        end

        local icon = select(3, GetSpellInfo(spellId))

        states[castGUID] = {
            show = true,
            changed = true,
            duration = duration,
            expirationTime = GetTime() + duration,
            autoHide = true,
            progressType = "timed",
            icon = icon
        }

        return true
    end

    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local _, subEvent, _, sourceGUID, _, _, _, targetGUID, _, _, _, spellId = ...

        if not aura_env.trackedBuffs[spellId] then
            return false
        end

        local guidToUse, unit = aura_env.getBuffedPlayerGuid(spellId, sourceGUID, targetGUID)

        if not guidToUse or not unit or guidToUse == WeakAuras.myGUID then
            return false
        end

        local duration, expirationTime, icon = aura_env.getAuraMeta(unit, spellId)

        if duration == 0 or expirationTime == 0 or icon == 0 then
            return false
        end

        local key = aura_env.createKey(guidToUse, spellId)

        if subEvent == "SPELL_AURA_APPLIED" then
            states[key] = {
                show = true,
                changed = true,
                duration = duration,
                expirationTime = expirationTime,
                autoHide = true,
                progressType = "timed",
                icon = icon
            }

            aura_env.enqueuePoll(unit, guidToUse, spellId, key)

            return true
        end

        if subEvent == "SPELL_AURA_REFRESH" then
            if not states[key] then
                return false
            end

            local changed = states[key].duration ~= duration or states[key].expirationTime ~= duration

            if not changed then
                return false
            end

            states[key].changed = true
            states[key].duration = duration
            states[key].expirationTime = expirationTime

            aura_env.enqueuePoll(unit, guidToUse, spellId, key)

            return true
        end

        if subEvent == "SPELL_AURA_REMOVED" then
            if not states[key] then
                return false
            end

            states[key].show = false
            states[key].changed = true

            aura_env.clearTickerFor(key)

            return true
        end

        return false
    end

    if event == aura_env.customEventName then
        local id, unit, guid, spellId = ...

        if id ~= aura_env.id then
            return false
        end

        local key = aura_env.createKey(guid, spellId)

        if not states[key] then
            return false
        end

        if UnitIsDead(unit) then
            -- might already be hidden via SPELL_AURA_REMOVED
            if states[key].show == false then
                return false
            end

            states[key].show = false
            states[key].changed = true

            aura_env.clearTickerFor(key)

            return true
        end

        local duration, expirationTime, icon = aura_env.getAuraMeta(unit, spellId)

        if duration == 0 or expirationTime == 0 or icon == 0 then
            return false
        end

        local changed = states[key].duration ~= duration or states[key].expirationTime ~= duration

        if not changed then
            return false
        end

        states[key].changed = true
        states[key].duration = duration
        states[key].expirationTime = expirationTime

        return true
    end

    return false
end
