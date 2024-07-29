-- CHAT_MSG_PARTY, CHAT_MSG_RAID, CHAT_MSG_PARTY_LEADER, CHAT_MSG_RAID_LEADER, CHAT_MSG_RAID_WARNING, CHAT_MSG_SAY, CHAT_MSG_YELL, CHAT_MSG_WHISPER
--- @param event "CHAT_MSG_PARTY" | "CHAT_MSG_RAID" | "CHAT_MSG_PARTY_LEADER" | "CHAT_MSG_RAID_LEADER" | "CHAT_MSG_RAID_WARNING" | "CHAT_MSG_SAY" | "CHAT_MSG_YELL" | "CHAT_MSG_WHISPER" | "STATUS" | "OPTIONS"
--- @return boolean
function f(event, ...)
	if event == "OPTIONS" or event == "STATUS" then
		return false
	end

	local text, _, _, _, _, _, _, _, _, _, _, guid = ...

	return guid ~= WeakAuras.myGUID and aura_env.isTriggerPhrase(text)
end
