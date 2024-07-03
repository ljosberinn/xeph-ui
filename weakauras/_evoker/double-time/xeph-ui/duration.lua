function f()
	local auraInfo = C_UnitAuras.GetPlayerAuraBySpellID(395296)

	if not auraInfo then
		return 0, 0
	end

	return auraInfo.duration, GetTime() + auraInfo.duration
end
