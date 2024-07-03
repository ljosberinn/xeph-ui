aura_env.expirationTime = nil
aura_env.lastEbonMightCast = 0

local eruptionCastId = 395160

local extenders = {
	[eruptionCastId] = true,
	[408092] = true, -- font upheaval
	[382266] = true, -- font fire breath
	[396286] = true, -- upheaval
	[357208] = true, -- fire breath
}

--- @param id number
--- @return boolean
function aura_env.isExtender(id)
	return extenders[id] ~= nil
end

local function getCastTime(spellId)
	if C_Spell.GetSpellInfo then
		local info = C_Spell.GetSpellInfo(spellId)
		return info.castTime
	end

	return select(4, GetSpellInfo(spellId))
end

--- @param id number
--- @return number
function aura_env.getCastTime(id)
	if id == eruptionCastId then
		return getCastTime(id) / 1000
	end

	return GetUnitEmpowerMinHoldTime("player") / 1000
end

--- @return number
function aura_env.getExpirationTime()
	local auraData = C_UnitAuras.GetPlayerAuraBySpellID(395296)

	return auraData and auraData.expirationTime or 0
end

aura_env.customEventName = "XEPHUI_AugmentationCastCheck"
aura_env.nextFrame = nil

--- @param expectedCastEnd number
--- @param previousExpirationTime number
--- @param count number
function aura_env.queue(expectedCastEnd, previousExpirationTime, count)
	if aura_env.nextFrame then
		return
	end

	aura_env.nextFrame = C_Timer.NewTimer(0, function()
		WeakAuras.ScanEvents(aura_env.customEventName, aura_env.id, expectedCastEnd, previousExpirationTime, count)
	end)
end
