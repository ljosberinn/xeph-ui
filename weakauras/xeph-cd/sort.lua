function f(a, b)
	if a.region.state.kind == "item" and b.region.state.kind == "item" then
		if a.region.state.cooldown == b.region.state.cooldown then
			return a.region.state.spellName < b.region.state.spellName
		end

		return a.region.state.cooldown < b.region.state.cooldown
	end

	if a.region.state.kind == "item" and b.region.state.kind == "spell" then
		return false
	end

	if a.region.state.kind == "spell" and b.region.state.kind == "item" then
		return true
	end

	if a.region.state.cooldown == b.region.state.cooldown then
		return a.region.state.spellName < b.region.state.spellName
	end

	return a.region.state.cooldown < b.region.state.cooldown
end
