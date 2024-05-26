function f(event, ...)
	if event == "TRIGGER" then
		if not ... then
			return false
		end

		local _, updatedTriggerStates = ...

		for _, trigger in pairs(updatedTriggerStates) do
			if
				trigger
				and trigger.triggernum == 2
				and trigger.value
				and trigger.value >= 1800
				and aura_env.doUpgradeCheck() > 0
			then
				local msg =
					format("You have %s flightstones, consider spending some before overcapping!", trigger.value)
				print(msg)
				return false
			end
		end

		return false
	end

	if event == "PLAYER_EQUIPMENT_CHANGED" then
		aura_env.doUpgradeCheck()
	end
end
