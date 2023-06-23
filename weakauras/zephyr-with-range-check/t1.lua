--- PLAYER_DEAD, UNIT_SPELLCAST_SUCCEEDED, GROUP_JOINED, GROUP_LEFT, PLAYER_STARTED_MOVING, PLAYER_STOPPED_MOVING
--- @param event "PLAYER_DEAD" | "UNIT_SPELLCAST_SUCCEEDED" | "OPTIONS" | "STATUS" | "GROUP_JOINED" | "GROUP_LEFT" | "PLAYER_STARTED_MOVING" | "PLAYER_STOPPED_MOVING"
function (event, ...)
    if event == "GROUP_JOINED" then
        aura_env.isInParty = true
        return false
    end

    if event == "GROUP_LEFT" then
        aura_env.isInParty = false
        aura_env.closePlayers = 0
        return true
    end

    if not aura_env.isInParty then
        return false
    end

    if event == "UNIT_SPELLCAST_SUCCEEDED" or event == "PLAYER_STOPPED_MOVING" or event == "PLAYER_STARTED_MOVING" then
        local now = GetTime()

        if event == "UNIT_SPELLCAST_SUCCEEDED" then
            local castingActor, _, spellId = ...

            -- disable when seen casting zephyr
            if castingActor == "player" and spellId == 374227 then
                aura_env.rangeCheckEnabled = false
                aura_env.closePlayers = 0
                aura_env.lastZephyrCast = now
                return true
            end
        end

        -- re-enable 115s after the last cast
        if not aura_env.lastZephyrCast or (aura_env.lastZephyrCast and now - aura_env.lastZephyrCast > 115) then
            aura_env.rangeCheckEnabled = true
        end

        if not aura_env.rangeCheckEnabled or (aura_env.lastCheck and now - aura_env.lastCheck < 0.5) then
            return false
        end

        aura_env.lastCheck = now

        local playerInstanceId = select(4, UnitPosition("player"))
        local units = IsInRaid() and aura_env.raidList or aura_env.partyList
        local closePlayers = 0

        for i = 1, GetNumGroupMembers() do
            local unit = units[i]

            -- unit must exist, be alive, not phased, not myself, in the same zone and within range of... mistletoe
            if
                UnitExists(unit) and not UnitIsDead(unit) and not UnitPhaseReason(unit) and
                    WeakAuras.myGUID ~= UnitGUID(unit) and
                    select(4, UnitPosition(unit)) == playerInstanceId and
                    IsItemInRange(21519, unit)
             then
                closePlayers = closePlayers + 1

                if closePlayers == 4 then
                    aura_env.closePlayers = 4

                    return true
                end
            end
        end

        aura_env.closePlayers = closePlayers

        return true
    end

    return false
end
