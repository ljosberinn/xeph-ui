function f()
	local value = aura_env.threshold - aura_env.furySpent

	if value < 0 then
		return aura_env.threshold - math.abs(value)
	end

	return value
end
