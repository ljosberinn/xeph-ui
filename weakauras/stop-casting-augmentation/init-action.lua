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

--- @param id number
--- @return number
function aura_env.getCastTime(id)
	if id == eruptionCastId then
		return select(4, C_Spell.GetSpellInfo and C_Spell.GetSpellInfo(id) or GetSpellInfo(id)) / 1000
	end

	return GetUnitEmpowerMinHoldTime("player") / 1000
end

--- @return number
function aura_env.getExpirationTime()
	for i = 1, 255 do
		local _, _, _, _, _, expirationTime, _, _, _, spellId, _, _, _, _, _ = UnitAura("player", i, "HELPFUL PLAYER")

		if spellId == 395296 then
			return expirationTime
		end
	end

	return 0
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
