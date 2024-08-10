aura_env.spellName = C_Spell.GetSpellName(395296)
aura_env.active = false

local extenders = {
	[395160] = true, -- eruption
	[408092] = true, -- font upheaval
	[382266] = true, -- font fire breath
	[396286] = true, -- upheaval
	[357208] = true, -- fire breath
	[403631] = true, -- breath of eons
}

--- @param id number
--- @return boolean
function aura_env.isExtender(id)
	return extenders[id] ~= nil
end
