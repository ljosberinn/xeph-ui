-- UNIT_POWER_UPDATE:player, UNIT_SPELLCAST_CHANNEL_START:player, UNIT_SPELLCAST_CHANNEL_STOP:player, CLEU:SPELL_EMPOWER_START:SPELL_EMPOWER_INTERRUPT:SPELL_EMPOWER_END:SPELL_CAST_START:SPELL_CAST_SUCCESS:SPELL_CAST_FAILED:SPELL_PERIODIC_DAMAGE:SPELL_AURA_APPLIED:SPELL_AURA_REFRESH, PLAYER_DEAD, UNIT_SPELLCAST_SUCCEEDED:player
--- @class GCDHistoryState
--- @field show boolean
--- @field changed boolean
--- @field name string
--- @field icon number
--- @field progressType "timed"
--- @field duration number
--- @field expirationTime number
--- @field autoHide true
--- @field spellId number
--- @field paused boolean
--- @field start number
--- @field desaturated boolean
--- @field interrupted boolean
--- @field specialNumber number
--- @field isPet boolean
--- @field remaining number | nil

--- @param states table<number, GCDHistoryState>
--- @param event "STATUS" | "OPTIONS" | "COMBAT_LOG_EVENT_UNFILTERED" | "UNIT_POWER_UPDATE" | "UNIT_SPELLCAST_CHANNEL_START" | "UNIT_SPELLCAST_CHANNEL_STOP" | "PLAYER_DEAD" | "UNIT_SPELLCAST_SUCCEEDED"
--- @return boolean
function f(states, event, ...)
	local handler = aura_env.eventHandlers[event]

	return handler and handler(states, ...) or false
end
