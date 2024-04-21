--- UNIT_SPELLCAST_SUCCEEDED, PLAYER_STOPPED_MOVING, GROUP_LEFT, GROUP_JOINED
--- @param event "UNIT_SPELLCAST_SUCCEEDED" | "OPTIONS" | "STATUS" | "PLAYER_STOPPED_MOVING" | "GROUP_JOINED" | "GROUP_LEFT"
function (event, ...)
    if event == "GROUP_JOINED" then
        aura_env.isInParty = true
    elseif event == "GROUP_LEFT" then
        aura_env.isInParty = false
    end
    
    if not aura_env.isInParty then
        return false
    end
    
    if event == "UNIT_SPELLCAST_SUCCEEDED" or event == "PLAYER_STOPPED_MOVING" then
        local now = GetTime()
        
        if event == "UNIT_SPELLCAST_SUCCEEDED" then
            if aura_env.zephyrOnCooldown(now) then
                return false
            end
            
            local castingActor, _, spellId = ...
            
            -- disable when seen casting zephyr
            if castingActor == "player" and spellId == 374227 then
                aura_env.closePlayers = 0
                aura_env.lastZephyrCast = now
                aura_env.lastCheck = now
                return true
            end
        end
        
        -- ignore events until briefly before Zephyr is ready again
        -- only check twice per second in general tops
        if aura_env.zephyrOnCooldown(now) or aura_env.lastCheck and now - aura_env.lastCheck < 0.5 then
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
            IsSpellInRange(aura_env.verdantEmbraceSpellInfo, unit)
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

