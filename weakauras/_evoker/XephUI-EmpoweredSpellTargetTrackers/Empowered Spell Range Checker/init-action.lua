local excludedIds = {
	[120651] = true, -- Explosive
	[174773] = true, -- Spiteful
	[204560] = true, -- Incorporeal
	[204773] = true, -- Afflicted
}

--- @param unit string
--- @return boolean
aura_env.unitIsIrrelevant = function(unit)
	local guid = UnitGUID(unit)

	if not guid then
		return false
	end

	local unitType, _, _, _, _, npcId = strsplit("-", guid)

	if unitType ~= "Creature" then
		return false
	end

	npcId = tonumber(npcId)

	return excludedIds[npcId] == true
end
