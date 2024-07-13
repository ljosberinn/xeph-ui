aura_env.consecrationCastId = 26573

---@return AuraData|nil
function aura_env.getConsecrationBuff()
	return C_UnitAuras.GetPlayerAuraBySpellID(188370)
end

---@return number
function aura_env.getDuration()
	return IsPlayerSpell(379022) and 14 or 12
end
