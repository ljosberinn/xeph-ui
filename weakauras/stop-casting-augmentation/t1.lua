-- XEPHUI_AugmentationCastCheck, UNIT_SPELLCAST_START:player, UNIT_SPELLCAST_EMPOWER_START:player, UNIT_AURA:player, UNIT_SPELLCAST_SUCCEEDED:player
--- @param event "OPTIONS" | "STATUS" | "XEPHUI_AugmentationCastCheck" | "UNIT_SPELLCAST_START" | "UNIT_SPELLCAST_EMPOWER_START" | "UNIT_AURA" | "UNIT_SPELLCAST_SUCCEEDED"
--- @return boolean
function (event, ...)
    if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_EMPOWER_START" then
        local spellId = select(3, ...)

        if not aura_env.isExtender(spellId) then
            return false
        end

        local now = GetTime()

        if aura_env.expirationTime == 0 then
            -- queueing up a spell directly after EM will not have the buff yet
            if now == aura_env.lastEbonMightCast then
                return false
            end

            return true
        end

        local castTime = aura_env.getCastTime(spellId)
        -- the game does not send refresh events when you extend so we have to
        -- poll for the latest expiration time. luckily, this appears to be cheap
        aura_env.expirationTime = aura_env.getExpirationTime()

        local result = now + castTime > aura_env.expirationTime

        if result and aura_env.expirationTime - now < 2 then
            -- forward the expected cast end time since between this and the
            -- next check, an aura change may lead to haste changes
            aura_env.queue(now + castTime, aura_env.expirationTime, 1)
            return false
        end

        return result
    end

    if event == "UNIT_SPELLCAST_SUCCEEDED" then
        local spellId = select(3, ...)

        if spellId == 395152 then
            aura_env.lastEbonMightCast = GetTime()
        end

        return false
    end

    if event == "UNIT_AURA" then
        aura_env.expirationTime = aura_env.getExpirationTime()

        return false
    end

    if event == aura_env.customEventName then
        local id, expectedCastEnd, previousExpirationTime, count = ...

        if id ~= aura_env.id then
            return false
        end

        aura_env.nextFrame = nil

        local spellId = select(9, UnitCastingInfo("player")) or select(8, UnitChannelInfo("player"))

        if spellId == nil then
            return false
        end

        -- cast that triggered the queue may be aborted by now
        if not aura_env.isExtender(spellId) then
            return false
        end

        aura_env.expirationTime = aura_env.getExpirationTime()

        -- buff faded since then. unlikely but possible
        if aura_env.expirationTime == 0 then
            return true
        end

        local now = GetTime()
        local result = expectedCastEnd > aura_env.expirationTime

        -- after 5 attempts OR the update indicates we can savely extend
        if count == 5 or not result then
            return result
        end

        -- no changes observed, the remaining expirationTime is still within 2s
        if previousExpirationTime == aura_env.expirationTime and aura_env.expirationTime - now < 2 then
            aura_env.queue(expectedCastEnd, previousExpirationTime, count + 1)
            return false
        end

        return result
    end

    return false
end
