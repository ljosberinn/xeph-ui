-- CLEU:SPELL_CAST_START, CLEU:SPELL_AURA_APPLIED, CLEU:SPELL_AURA_REMOVED, CLEU:SPELL_AURA_REFRESH, XEPHUI_AugmentationCastCheck, CLEU:SPELL_EMPOWER_START
--- @param event "OPTIONS" | "STATUS" | "COMBAT_LOG_EVENT_UNFILTERED" | "XEPHUI_AugmentationCastCheck"
--- @return boolean
function (event, ...)
    if event == aura_env.customEventName then
        local id, expectedCastEnd, previousExpirationTime, count = ...

        if id ~= aura_env.id then
            return false
        end

        aura_env.nextFrame = nil

        local spellId = select(9, UnitCastingInfo("player"))

        -- cast that triggered the queue may be aborted by now
        if not aura_env.isExtender(spellId) then
            return false
        end

        aura_env.expirationTime = aura_env.getExpirationTime()

        -- buff faded since then. unlikely but possible
        if aura_env.expirationTime == nil then
            return true
        end

        local now = GetTime()
        local result = expectedCastEnd > aura_env.expirationTime

        -- after 10 attempts OR the update indicates we can savely extend
        if count == 10 or not result then
            return result
        end

        -- no changes observed, the remaining expirationTime is still within 1s
        if previousExpirationTime == aura_env.expirationTime and aura_env.expirationTime - now < 1 then
            aura_env.queue(expectedCastEnd, previousExpirationTime, count + 1)
            return false
        end

        return result
    end

    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local _, subEvent, _, sourceGUID = ...

        if sourceGUID ~= WeakAuras.myGUID then
            return false
        end

        local now = GetTime()

        if subEvent == "SPELL_CAST_START" or subEvent == "SPELL_EMPOWER_START" then
            local spellId = select(12, ...)

            if not aura_env.isExtender(spellId) then
                return false
            end

            if aura_env.expirationTime == nil then
                return true
            end

            local castTime = aura_env.getCastTime(spellId)
            -- the game does not send SPELL_AURA_REFRESH when you extend so we 
            -- have to poll for the latest expiration time. luckily, this 
            -- appears to be cheap
            aura_env.expirationTime = aura_env.getExpirationTime()

            local result = now + castTime > aura_env.expirationTime

            if result and aura_env.expirationTime - now < 1 then
                -- forward the castTime since between this and the next check, an
                -- aura change may lead to haste changes
                aura_env.queue(now + castTime, aura_env.expirationTime, 1)
                return false
            end

            return result
        end

        local _, _, _, _, _, _, _, targetGUID, _, _, _, spellId = ...

        if targetGUID ~= WeakAuras.myGUID or spellId ~= 395296 then
            return false
        end

        if subEvent == "SPELL_AURA_APPLIED" or subEvent == "SPELL_AURA_REFRESH" then
            aura_env.expirationTime = aura_env.getExpirationTime()
        elseif subEvent == "SPELL_AURA_REMOVED" then
            aura_env.expirationTime = nil
        end
    end

    return false
end
