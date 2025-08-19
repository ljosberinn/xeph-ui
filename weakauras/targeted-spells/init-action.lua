aura_env.customEventName = "XEPHUI_TARGETED_SPELLS"

aura_env.allowList = {
	[201226] = true, --Blood Bolt (DHT)
	[193633] = true, --Shoot (BRH)
	[373392] = true, --Shoot (Nokhud)
	[369781] = true, --Dagger Throw (Uldaman)
	[387974] = true, --Arcane Missiles (Algethar)
	[373932] = true, --Illusionary Bolt (Azure Vault)
}
aura_env.blockList = {}

local schools = {
	"fire",
	"arcane",
	"nature",
	"frost",
	"shadow",
	"holy",
	"plague",
	"chaos",
	"physical",
	"spellstrike",
	"flamestrike",
	"spellfire",
	"froststrike",
	"spellfrost",
	"frostfire",
	"holystrike",
	"divine",
	"radiant",
	"holyfrost",
	"stormstrike",
	"astral",
	"volcanic",
	"froststorm",
	"holystorm",
	"shadowstrike",
	"spellshadow",
	"shadowflame",
	"shadowfrost",
	"twilight",
	"volcanic",
}

local pattern1, pattern2, pattern3 = aura_env.config.pattern1, aura_env.config.pattern2, aura_env.config.pattern3

---@param description string
---@return boolean
function aura_env.descriptionImpliesDamage(description)
	description = description:lower()

	if description:match(pattern1) or description:match(pattern2) or description:match(pattern3) then
		return true
	end

	for _, school in ipairs(schools) do
		if description:match(school .. " damage") then
			return true
		end
	end

	return false
end
