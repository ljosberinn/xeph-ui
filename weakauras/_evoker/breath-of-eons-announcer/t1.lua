-- CLEU:SPELL_DAMAGE:SPELL_MISSED, XEPHUI_BREATH_OF_EONS_ANNOUNCER
function f(event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, subEvent = ...
		local key = nil
		local addition = 0

		if subEvent == "SPELL_DAMAGE" then
			local _, _, _, sourceGUID, _, _, _, _, _, _, _, spellId, _, _, amount, _, _, _, _, absorbed = ...

			if spellId == 409632 then -- Temporal Wounds detonation
				key = sourceGUID
				addition = amount + (absorbed or 0)
			end
		elseif subEvent == "SPELL_MISSED" then
			local _, _, _, sourceGUID, _, _, _, _, _, _, _, spellId, _, _, missType, _, amount = ...

			if spellId == 409632 and missType == "ABSORB" then
				key = sourceGUID
				addition = amount
			end
		end

		if addition > 0 and key then
			aura_env.bySource[key] = aura_env.bySource[key] or 0
			aura_env.bySource[key] = aura_env.bySource[key] + addition
			aura_env.enqueue()
		end

		return false
	end

	if event == aura_env.customEventName then
		local id = ...

		if id ~= aura_env.id then
			return false
		end

		aura_env.timer = nil

		local message = aura_env.getMessage()

		if aura_env.config.announce then
			SendChatMessage(message, "SAY")
		else
			print(message)
		end

		return false
	end

	return false
end
