aura_env.expirationTime = nil

local eruptionCastId = 395160

local extenders = {
    [eruptionCastId] = true,
    [408092] = true, -- font upheaval
    [382266] = true, -- font fire breath
    [396286] = true, -- upheaval
    [357208] = true -- fire breath
}

--- @param id number
--- @return boolean
aura_env.isExtender = function(id)
    return extenders[id] ~= nil
end

--- @param id number
--- @return number
aura_env.getCastTime = function(id)
    if id == eruptionCastId then
        return select(4, GetSpellInfo(id)) / 1000
    end

    local _, _, _, channelStartTime, channelEndTime = UnitChannelInfo("player")
    local castTime = channelEndTime - channelStartTime

    return castTime / 1000
end

--- @return number
aura_env.getExpirationTime = function()
    for i = 1, 255 do
        local _, _, _, _, _, expirationTime, _, _, _, spellId, _, _, _, _, _ = UnitAura("player", i, "HELPFUL PLAYER")

        if spellId == 395296 then
            return expirationTime
        end
    end

    return 0
end

aura_env.customEventName = "XEPHUI_AugmentationCastCheck"
aura_env.nextFrame = nil

--- @param expectedCastEnd number
--- @param previousExpirationTime number
--- @param count number
aura_env.queue = function(expectedCastEnd, previousExpirationTime, count)
    if aura_env.nextFrame then
        return
    end

    aura_env.nextFrame =
        C_Timer.NewTimer(
        0,
        function()
            WeakAuras.ScanEvents(aura_env.customEventName, aura_env.id, expectedCastEnd, previousExpirationTime, count)
        end
    )
end
