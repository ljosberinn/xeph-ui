--- @param spellId number
--- @return boolean
function aura_env.isIncarn(spellId)
	return spellId == 102560 or spellId == 390414
end

--- @param spellId number
--- @return boolean
function aura_env.isEclipse(spellId)
	return spellId == 48517 or spellId == 48518
end

--- @param states table<number, EclipseState>
--- @return boolean
function aura_env.isStillInIncarn(states)
	if
		states[""].expirationTime
		and states[""].expirationTime > GetTime()
		and states[""].spellId
		and aura_env.isIncarn(states[""].spellId)
	then
		return true
	end

	return false
end
