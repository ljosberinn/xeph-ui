function f()
	if not aura_env.config["rageDisplay"] then
		return aura_env.rageSpent
	end

	local value = 240 - aura_env.rageSpent

	if value < 0 then
		return 240 - math.abs(value)
	end

	return value
end
