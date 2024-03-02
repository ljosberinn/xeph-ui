-- UNIT_SPELLCAST_START:focus, UNIT_SPELLCAST_DELAYED:focus, UNIT_SPELLCAST_STOP:focus, UNIT_SPELLCAST_CHANNEL_START:focus, UNIT_SPELLCAST_CHANNEL_UPDATE:focus, UNIT_SPELLCAST_CHANNEL_STOP:focus, UNIT_SPELLCAST_INTERRUPTIBLE:focus, UNIT_SPELLCAST_NOT_INTERRUPTIBLE:focus, UNIT_SPELLCAST_INTERRUPTED:focus, UNIT_SPELLCAST_EMPOWER_START:focus, UNIT_SPELLCAST_EMPOWER_STOP:focus

--- @class FocusKickState
--- @field show boolean
--- @field changed boolean
--- @field expirationTime number
--- @field autoHide true
--- @field progressType "timed"
--- @field icon number|string
--- @field spellId number
--- @field duration number
--- @field remaining number
--- @field interruptible boolean
--- @field name string
--- @field additionalProgress table<number, { min: number; max: number }> | nil
--- @field interruptOnCooldown boolean
--- @field isChannel boolean

--- @param states table<"", FocusKickState>
--- @param event "UNIT_SPELLCAST_START" | "UNIT_SPELLCAST_DELAYED" | "UNIT_SPELLCAST_STOP" | "UNIT_SPELLCAST_CHANNEL_START" | "UNIT_SPELLCAST_CHANNEL_UPDATE" | "UNIT_SPELLCAST_CHANNEL_STOP" | "UNIT_SPELLCAST_INTERRUPTIBLE" | "UNIT_SPELLCAST_NOT_INTERRUPTIBLE" | "UNIT_SPELLCAST_INTERRUPTED" | "UNIT_SPELLCAST_EMPOWER_START" | "UNIT_SPELLCAST_EMPOWER_STOP"
function (states, event)
    if not UnitExists("focus") or UnitIsFriend("player", "focus") then
        return false
    end

    local handler = aura_env.handlers[event]

    if handler then
        return handler(states)
    end

    return false
end
