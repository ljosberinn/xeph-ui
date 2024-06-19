aura_env.importantSpellIds = {}

if aura_env.config.interruptSpellId == 0 or not IsSpellKnown(aura_env.config.interruptSpellId) then
	local name = nil

	if aura_env.config.interruptSpellId ~= nil then
		local id = aura_env.config.interruptSpellId
		if C_Spell.GetSpellName then
			name = C_Spell.GetSpellName(id)
		else
			name = GetSpellInfo(id)
		end
	end

	local label = name and name or "Spell doesn't exist"

	local str = format(
		"[%s] The given spell id of '%d' (%s) is not a spell you currently know.",
		aura_env.id,
		aura_env.config.interruptSpellId,
		label
	)
	print(str)
end

if Plater and Plater.db and Plater.db.profile and Plater.db.profile.script_data then
	for _, script in pairs(Plater.db.profile.script_data) do
		if script and script.Name == "Cast - Very Important [Plater]" then
			for _, id in pairs(script.SpellIds) do
				aura_env.importantSpellIds[id] = true
			end
			break
		end
	end
end

aura_env.allowedKeys = {
	show = true,
	duration = true,
	expirationTime = true,
	icon = true,
	name = true,
	remaining = true,
	spellId = true,
	unit = true,
	castType = true,
	raidMarkIndex = true,
	raidMark = true,
	stagesData = true,
	class = true,
	stage = true,
	spell = true,
	empowered = true,
	stageTotal = true,
	sourceName = true,
	sourceUnit = true,
	sourceRealm = true,
	destName = true,
	destUnit = true,
	destRealm = true,
}

local tick = nil

for _, region in pairs(aura_env.region.subRegions) do
	if region.type == "subtick" then
		tick = region
		break
	end
end

--- @param percent number
function aura_env.updateTickPlacement(percent)
	if tick then
		tick:SetTickPlacement(percent)
		tick:SetVisible(true)
	end
end

function aura_env.hideTick()
	if tick then
		tick:SetVisible(false)
	end
end

---@return number, number
function aura_env.getInterruptCooldown()
	if C_Spell.GetSpellCooldown then
		local spellCd = C_Spell.GetSpellCooldown(aura_env.config.interruptSpellId)
		return spellCd.duration, spellCd.startTime
	end

	local interruptCastTime, interruptCd = GetSpellCooldown(aura_env.config.interruptSpellId)
	return interruptCd, interruptCastTime
end
