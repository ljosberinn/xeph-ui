-- CHAT_MSG_WHISPER, CHALLENGE_MODE_END, CHALLENGE_MODE_START, CHAT_MSG_BN_WHISPER, ENCOUNTER_START, ENCOUNTER_END
--- @param event "CHAT_MSG_WHISPER" | "CHALLENGE_MODE_END" | "CHALLENGE_MODE_START" | "OPTIONS" | "STATUS" | "CHAT_MSG_BN_WHISPER" | "ENCOUNTER_START" | "ENCOUNTER_END"
--- @return boolean
function f(event, ...)
    local handler = aura_env.handlers[event]

    if handler then
        return handler(...)
    end

    return false
end
