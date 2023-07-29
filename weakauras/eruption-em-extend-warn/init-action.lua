local eruptionCastId = 395160

-- not using party buff intentionally here as the application is slightly delayed
-- technically it would be more relevant/accurate however
local ebonMightSelfBuffId = 395296

--- @return number
aura_env.getRemainingEbonMightDuration = function()
    local expirationTime = select(6, WA_GetUnitBuff("player", ebonMightSelfBuffId))

    if expirationTime == nil then
        return 0
    end

    return expirationTime - GetTime()
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
