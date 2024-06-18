aura_env.ignorelist = {
	[75] = true, --Auto Shot
	[5374] = true, -- Mutilate
	[7268] = true, -- Arcane Missiles
	[27576] = true, -- Mutilate
	[32175] = true, -- Stormstrike
	[32176] = true, -- Stormstrike (Off-Hand)
	[50622] = true, -- Bladestorm
	[52174] = true, -- Heroic Leap
	[57794] = true, -- Heroic Leap
	[61391] = true, -- Typhoon
	[84721] = true, -- Frozen Orb
	[85384] = true, -- Raging Blow
	[88263] = true, -- Hammer of the Righteous
	[96103] = true, -- Raging Blow
	[102794] = true, -- Ursol's Vortex
	[107270] = true, -- Spinning Crane Kick
	[110745] = true, -- Divine Star
	[114089] = true, -- Windlash
	[114093] = true, -- Windlash Off-Hand
	[115357] = true, -- Windstrike
	[115360] = true, -- Windstrike Off-Hand
	[115464] = true, -- Healing Sphere
	[120692] = true, -- Halo
	[120696] = true, -- Halo
	[121473] = true, -- Shadow Blade
	[121474] = true, -- Shadow Blade Off-hand
	[122128] = true, -- Divine Star
	[127797] = true, -- Ursol's Vortex
	[132951] = true, -- Flare
	[135299] = true, -- Tar Trap
	[184707] = true, -- Rampage
	[184709] = true, -- Rampage
	[198928] = true, -- Cinderstorm
	[199672] = true, -- Rupture
	[201363] = true, -- Rampage
	[201364] = true, -- Rampage
	[204255] = true, -- Soul Fragments
	[213241] = true, -- Felblade
	[213243] = true, -- Felblade
	[218617] = true, -- Rampage
	[225919] = true, -- Fracture
	[225921] = true, -- Fracture
	[228354] = true, -- Flurry
	[228537] = true, -- Shattered Souls
	[228597] = true, -- Frostbolt
	[272790] = true, -- Frenzy; BM hunter buff
	[276245] = true, -- Env; envenom buff
	[346665] = true, -- Throw Glaive
	[361195] = true, -- Verdant Embrace friendly heal
	[361509] = true, -- Living Flame friendly heal
	[367230] = true, -- Spiritbloom
	[370966] = true, -- The Hunt Impact (DH Class Tree Talent)
	[383313] = true, -- Abomination Limb periodical
	[385060] = true, -- Odyn's Fury
	[385061] = true, -- Odyn's Fury
	[385062] = true, -- Odyn's Fury
	[385954] = true, -- Shield Charge
	[408385] = true, -- Crusading Strikes
}

for _, spell in pairs(aura_env.config.ignorelist) do
	aura_env.ignorelist[spell.id] = true
end

aura_env.spellcasts = 0

aura_env.isRogue = false
aura_env.isEvoker = false

aura_env.lastComboPoints = 0
aura_env.currentComboPoints = 0

aura_env.empowers = {}
aura_env.rogueSpenders = {}

function aura_env.getComboPoints()
	return UnitPower("player", Enum.PowerType.ComboPoints)
end

---@param spellId number
---@return string, number, number
function aura_env.getSpellMeta(spellId)
	if C_Spell.GetSpellInfo then
		local info = C_Spell.GetSpellInfo(spellId)
		if not info.icon then
			info.icon = C_Spell.GetSpellTexture(spellId)
		end

		return info.name, info.icon, info.castTime
	end

	local name, _, icon, castTime = GetSpellInfo(spellId)
	return name, icon, castTime
end

do
	local id = select(3, C_PlayerInfo.GetClass({ unit = "player" }))

	if id == 13 then
		aura_env.isEvoker = true

		aura_env.empowers = {
			[357208] = 3, -- FB
			[382266] = 4, -- FB font
			[359073] = 3, -- ES
			[382411] = 4, -- ES font
			[396286] = 3, -- Upheaval
			[408092] = 4, -- Upheaval font
			[355936] = 3, -- Dream Breath
			[382614] = 4, -- Dream Breath font
			[367226] = 3, -- Spiritbloom
			[382731] = 4, -- Spiritbloom font
		}
	elseif id == 4 then
		aura_env.isRogue = true
		aura_env.currentComboPoints = aura_env.getComboPoints()
		aura_env.lastComboPoints = aura_env.currentComboPoints

		aura_env.rogueSpenders = {
			-- common
			[1943] = true, -- rupture
			[315496] = true, -- slice and dice
			[408] = true, -- kidney shot
			-- assa
			[32645] = true, -- envenom
			[121411] = true, -- crimson tempest
			-- sub
			[196819] = true, -- eviscerate
			[280719] = true, -- secret technique
			[319175] = true, -- black powder
			-- outlaw
			[2098] = true, -- dispatch
			[315341] = true, -- between the eyes
		}
	end
end

--- @type table<string, boolean>
local unknownGuidIsMyPet = {}

--- @param guid string
--- @param sourceFlags number
--- @return boolean
local function isMyPet(guid, sourceFlags)
	if unknownGuidIsMyPet[guid] == nil then
		unknownGuidIsMyPet[guid] = CombatLog_Object_IsA(sourceFlags, COMBATLOG_FILTER_MY_PET)
	end

	return unknownGuidIsMyPet[guid]
end

--- @param guid string
--- @param sourceFlags number
--- @return boolean
function aura_env.isBasicallyMe(guid, sourceFlags)
	if guid == WeakAuras.myGUID then
		return true
	end

	if aura_env.config.petActions then
		return isMyPet(guid, sourceFlags)
	end

	return false
end

--- @param guid string
--- @return boolean
function aura_env.isPet(guid)
	return aura_env.config.petActions and unknownGuidIsMyPet[guid] == true or false
end
