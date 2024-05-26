local wogCastId = 85673
local sotrCastId = 53600
local intercessionCastId = 391054

local shiningLightBuffId = 327510 -- free wog
local divinePurposeBuffId = 223819 -- free everything
local bastionOfLightBuffId = 378974 -- free wog/sotr

---@type number|nil
aura_env.lastRighteousDefenderProc = nil

---@param id number
---@return boolean
function aura_env.isSpender(id)
	return id == wogCastId or id == sotrCastId or id == intercessionCastId
end

local function getSpellCooldown(spellId)
	if C_Spell.GetSpellCooldown then
		return C_Spell.GetSpellCooldown(spellId).duration
	end

	return select(2, GetSpellCooldown(spellId))
end

---@return boolean
function aura_env.goakOrWingsOnCd()
	return getSpellCooldown(31884) > 0 -- avenging wrath
		or getSpellCooldown(86659) > 0 -- default goak
		or getSpellCooldown(212641) > 0 -- glyphed goak
end

---@param id number
---@return boolean
function aura_env.isFreeWog(id)
	if id ~= wogCastId then
		return false
	end

	return WA_GetUnitBuff("player", shiningLightBuffId) ~= nil
		or WA_GetUnitBuff("player", divinePurposeBuffId) ~= nil
		or WA_GetUnitBuff("player", bastionOfLightBuffId) ~= nil
end

---@param id number
---@return boolean
function aura_env.isFreeSotr(id)
	if id ~= sotrCastId then
		return false
	end

	return WA_GetUnitBuff("player", divinePurposeBuffId) ~= nil or WA_GetUnitBuff("player", bastionOfLightBuffId) ~= nil
end

---@param id number
---@return boolean
function aura_env.isFreeIntercession(id)
	if id ~= intercessionCastId then
		return false
	end

	return WA_GetUnitBuff("player", divinePurposeBuffId) ~= nil
end
