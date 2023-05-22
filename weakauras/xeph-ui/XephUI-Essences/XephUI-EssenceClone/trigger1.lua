-- UNIT_POWER_FREQUENT:player, UNIT_MAXPOWER:player

--- @param states table<number, EssenceState>
--- @param powerType nil | string
--- @return boolean
function (states, _, _, powerType)
    if powerType and powerType ~= "ESSENCE" then
        return false
    end
        
    return aura_env.trigger(states)
end
