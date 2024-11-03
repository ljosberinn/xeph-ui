-- UNIT_SPELLCAST_SUCCEEDED:player, UNIT_AURA:player

---@param states table<"", table>
---@param event "OPTIONS" | "STATUS" | "UNIT_SPELLCAST_SUCCEEDED" | "UNIT_AURA"
---@return boolean
function f(states, event, ...)
	if event == "STATUS" then
		local consecrationBuff = aura_env.getConsecrationBuff()

		states[""] = {
			autoHide = false,
			show = true,
			spellId = aura_env.consecrationCastId,
			unit = "player",
			icon = C_Spell.GetSpellTexture(aura_env.consecrationCastId),
			changed = true,
			lastCast = 0,
		}

		if consecrationBuff == nil then
			states[""].value = 0
			states[""].value = 1
			states[""].progressType = "static"
		else
			states[""].expirationTime = consecrationBuff.expirationTime
			states[""].duration = aura_env.getDuration()
			states[""].progressType = "timed"
		end

		return true
	end

	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		local spellId = select(3, ...)

		if spellId ~= aura_env.consecrationCastId then
			return false
		end

		local now = GetTime()
		local duration = aura_env.getDuration()

		states[""].changed = true
		states[""].expirationTime = GetTime() + duration
		states[""].duration = duration
		states[""].progressType = "timed"
		states[""].lastCast = now

		return true
	end

	if event == "UNIT_AURA" then
		local consecrationBuff = aura_env.getConsecrationBuff()
		local now = GetTime()

		if consecrationBuff == nil then
			-- sometimes when casting, you briefly lose the buff
			if now == states[""].lastCast or states[""].progressType == "static" then
				return false
			end

			states[""].value = 0
			states[""].value = 1
			states[""].progressType = "static"
			states[""].changed = true

			return true
		end

		if states[""].progressType == "static" then
			local expirationTime = consecrationBuff.expirationTime

			if expirationTime == 0 then
				local diffToLastCast = now - states[""].lastCast

				-- standing in consecration without duration while closing WA
				-- or casting and gaining buff without duration
				if now == diffToLastCast or diffToLastCast == 0 then
					return false
				end

				expirationTime = states[""].lastCast + aura_env.getDuration()
			end

			states[""].expirationTime = expirationTime
			states[""].duration = aura_env.getDuration()
			states[""].progressType = "timed"
			states[""].changed = true

			return true
		end

		if states[""].expirationTime ~= consecrationBuff.expirationTime then
			-- either gained buff just now or moved out and then back into
			if consecrationBuff.expirationTime == 0 then
				local diffToLastCast = now - states[""].lastCast

				-- standing in consecration without duration while closing WA
				-- or casting and gaining buff without duration
				if now == diffToLastCast or diffToLastCast == 0 then
					return false
				end

				local expirationTime = states[""].lastCast + aura_env.getDuration()

				states[""].expirationTime = expirationTime
				states[""].changed = true

				return true
			else
				states[""].expirationTime = consecrationBuff.expirationTime
				states[""].changed = true

				return true
			end
		end

		return false
	end

	return false
end
