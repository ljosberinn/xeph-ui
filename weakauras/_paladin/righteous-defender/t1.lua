--- UNIT_SPELLCAST_SUCCEEDED:player
---@param event "UNIT_SPELLCAST_SUCCEEDED"
function f(event, ...)
	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		local spellId = select(3, ...)

		if not aura_env.isSpender(spellId) then
			return false
		end

		if not aura_env.goakOrWingsOnCd() then
			return false
		end

		if aura_env.isFreeWog(spellId) then
			return false
		end

		if aura_env.isFreeSotr(spellId) then
			return false
		end

		if aura_env.isFreeIntercession(spellId) then
			return false
		end

		local now = GetTime()

		if aura_env.lastRighteousDefenderProc and now - aura_env.lastRighteousDefenderProc < 1 then
			return false
		end

		aura_env.lastRighteousDefenderProc = now

		return true
	end

	return false
end
