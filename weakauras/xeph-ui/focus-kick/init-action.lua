aura_env.importantSpellIds = {}

local GetSpellInfo = C_Spell.GetSpellInfo or GetSpellInfo

if aura_env.config.interruptSpellId == 0 or not IsSpellKnown(aura_env.config.interruptSpellId) then
	local name = aura_env.config.interruptSpellId == 0 and nil or GetSpellInfo(aura_env.config.interruptSpellId)
	local label = name and name or "Spell doesn't exist"
	print(
		"["
			.. aura_env.id
			.. "] The given spell id of '"
			.. aura_env.config.interruptSpellId
			.. "' ("
			.. label
			.. ") is not a spell you currently know."
	)
end

if Plater and Plater.db and Plater.db.profile and Plater.db.profile.script_data then
	for _, script in pairs(Plater.db.profile.script_data) do
		if script and script.Name == "Cast - Very Important [Plater]" then
			for _, id in pairs(script.SpellIds) do
				aura_env.importantSpellIds[id] = true
			end
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
