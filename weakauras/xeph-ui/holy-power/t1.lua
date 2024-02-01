--- UNIT_POWER_UPDATE:player, CLEU:SPELL_DAMAGE, CLEU:SPELL_MISSED, CLEU:SPELL_ENERGIZE, XEPHUI_CRUSADING_STRIKES
function (states, event, ...)
    local hasChanges = aura_env.maybeInitState(states)
    local handler = aura_env.handlers[event]

    if handler then
        return handler(states, ...)
    end

    return hasChanges
end
