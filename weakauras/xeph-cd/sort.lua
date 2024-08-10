function f(a, b)
	local kindOrder = { consumable = 3, item = 2, spell = 1 }

	local aKind = a.region.state.kind
	local bKind = b.region.state.kind

	if aKind == bKind then
		if a.region.state.cooldown == b.region.state.cooldown then
			return a.region.state.spellName < b.region.state.spellName
		end

		return a.region.state.cooldown < b.region.state.cooldown
	else
		return kindOrder[aKind] < kindOrder[bKind]
	end
end
