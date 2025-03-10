-- UNIT_AURA:group
function f(states, event, ...)
	if event == "UNIT_AURA" then
		local unit, info = ...

		if not info then
			return false
		end

		if info.addedAuras then
			for _, aura in pairs(info.addedAuras) do
				if aura.spellId == 119611 and aura.sourceUnit == "player" and aura.icon == 5901829 then
					states[unit] = {
						show = true,
						changed = true,
						progressType = "timed",
						duration = 8,
						expirationTime = GetTime() + 8,
						spellId = aura.spellId,
						unit = unit,
						icon = 1381294,
						autoHide = true,
						auraInstanceId = aura.auraInstanceID,
						nativeExpirationTime = aura.expirationTime,
					}

					return true
				end
			end
		end

		if not states[unit] then
			return false
		end

		if info.updatedAuraInstanceIDs then
			for _, auraInstanceId in pairs(info.updatedAuraInstanceIDs) do
				if auraInstanceId == states[unit].auraInstanceId then
					local aura = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, auraInstanceId)

					if aura then
						if aura.expirationTime < states[unit].nativeExpirationTime then
							states[unit].nativeExpirationTime = aura.expirationTime -- slight diff between apply and immediate update
						else
							local diff = aura.expirationTime - states[unit].nativeExpirationTime

							if diff > 0 then
								states[unit].expirationTime = GetTime() + 8
								states[unit].changed = true
								states[unit].nativeExpirationTime = aura.expirationTime

								return true
							end
						end
					end
				end
			end
		end

		if info.removedAuraInstanceIDs then
			for _, auraInstanceId in pairs(info.removedAuraInstanceIDs) do
				if auraInstanceId == states[unit].auraInstanceId then
					states[unit].show = false
					states[unit].changed = true
					return true
				end
			end
		end
	end

	return false
end
