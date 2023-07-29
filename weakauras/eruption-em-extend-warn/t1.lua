--- @param event "OPTIONS" | "STATUS" | "UNIT_SPELLCAST_START" | "UNIT_SPELLCAST_EMPOWER_START"
function f(event, ...)
    if event ~= "UNIT_SPELLCAST_START" and event ~= "UNIT_SPELLCAST_EMPOWER_START" then
        return false
    end

    local spellId = select(3, ...)

    if not aura_env.isExtender(spellId) then
        return false
    end

    return aura_env.getCastTime(spellId) > aura_env.getRemainingEbonMightDuration()
end

