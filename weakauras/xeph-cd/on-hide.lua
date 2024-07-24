for key in pairs(aura_env.scheduledCooldownEvents) do
	local timer = aura_env.scheduledCooldownEvents[key]

	if not timer:IsCancelled() then
		timer:Cancel()
	end
end

for key in pairs(aura_env.scheduledAuraEvents) do
	local timer = aura_env.scheduledAuraEvents[key]

	if not timer:IsCancelled() then
		timer:Cancel()
	end
end

for key in pairs(aura_env.inspect) do
	local timer = aura_env.inspect[key]

	if not timer:IsCancelled() then
		timer:Cancel()
	end
end
