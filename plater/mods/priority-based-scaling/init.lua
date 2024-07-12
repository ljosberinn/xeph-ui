function f(modTable)
	local medium = modTable.config.midScale -- 0.9
	local small = modTable.config.lowScale -- 0.8
	local extrasmall = modTable.config.extraLowScale -- 0.7,
	local larger = modTable.config.higherScale -- 1.1

	modTable.npcIDs = {}

	local test = {}
	-- raids
	local amirdrassil = {
		[210231] = medium, -- Tainted Lasher, Gnarlroot
		[211306] = extrasmall, -- Fiery Vines, Tindral
	}
	local vault = {
		[194991] = medium, -- Oathsworn Vanguard
		[191714] = small, -- Seeking Stormling
	}
	local sepulcher = {
		[183669] = small, -- Fiendish Soul
	}
	local nathria = {
		[169925] = small, -- Begrudging Waiter
	}
	local nerubarPalace = {
		[219739] = small, -- Infested Spawn
		[220626] = medium, -- Parasite
	}
	-- dungeons
	local araKara = {
		[216336] = medium, -- Ravenous Crawler
		[216341] = medium, -- Jabbing Flyer
		[218325] = medium, -- Swarming Flyer
	}

	local cityOfThreads = {
		[220199] = small, -- Battle Scarab
		[216363] = medium, -- Reenforced drone
		[216365] = medium, -- Carrier
		[223357] = medium, -- Conscript
		[216329] = small, -- Droplet
		[220065] = small, -- Umbral Weave
		[222700] = small, -- Umbral Weave
		[219198] = medium, -- Ravenous Scarab
	}

	local tazavesh = {
		[178163] = small, -- Murkbrine Shorerunner
	}

	local theaterOfPain = {
		[163089] = small, -- Disgusting Refuse
	}

	local necroticWake = {
		[166264] = small, -- Spare Parts
		[166266] = small, -- Spare Parts #2
		[171500] = small, -- Shuffling Corpse
		[165138] = small, -- Blight bag
		[162729] = medium, -- Patchwerk Soldier
	}

	local mistsOfTirnaScithe = {
		[165111] = medium, -- Drust Spiteclaw
		[167117] = small, -- Larva
	}

	local hallsOfAtonement = {
		[167892] = medium, -- Tormented Soul
	}

	local deOtherSide = {
		[168986] = small, -- Skeletal Raptor
	}

	local plaguefall = {
		[168969] = small, -- Gushing Slime
	}

	local sanguineDepths = {
		[171455] = small, -- Stonewall Gargon
		[168457] = small, -- Stonewall Gargon
		[166589] = small, -- Animate Weapon
	}

	local grimBatol = {
		[224853] = small, -- Hatchling
		[39388] = medium, -- Boss Hatchling
	}

	local sigeOfBoralus = {
		[133990] = medium, -- Scrimshaw Gutter
		[138002] = medium, -- Scrimshaw Gutter
		[135258] = medium, -- Curseblade
	}

	local mechagon = {
		[144300] = small, -- Mechagon Citizen
	}

	local atalDazar = {
		[128435] = extrasmall, -- saurid
	}

	local waycrestManor = {
		[131669] = extrasmall, -- Jagged Hound
		[139269] = extrasmall, -- Gloom Horror
		[134041] = small, -- Infected Peasant
		[135052] = extrasmall, -- Blight Toad
		[136541] = extrasmall, -- Bile Oozeling
		[131847] = small, -- Waycrest Reveler
		[135048] = small, -- Gorestained Piglet (Drustvar Villager)
		[131585] = extrasmall, -- Enthralled Guard
	}

	local darkheartThicket = {
		[100529] = small, -- Hatespawn Slime
		[101074] = small, -- Hatespawn Whelpling
		[100991] = small, -- Strangling Roots
		[107288] = small, -- Vilethorn Sapling
	}

	local everbloom = {
		[81864] = extrasmall, -- Dreadpetal
		[84401] = small, -- Swift Sproutling
	}

	local blackRookHold = {
		[98677] = small, -- Rook Spiderling
		[98900] = medium, -- Wyrmtongue Trickster
		[102781] = extrasmall, -- Fel Bat Pup
	}

	local galakrondsFall = {
		[204536] = extrasmall, -- Blight Chunk
		[206065] = extrasmall, -- Interval
	}

	local throneOfTheTides = {
		[40923] = extrasmall, -- Unstable Corruption
	}

	local templeOfTheJadeSerpent = {
		[62358] = small, -- Corrupt Droplet
		[200126] = medium, -- Fallen Waterspeaker
		[65317] = medium, -- Xiang
		[59547] = medium, -- Jiang
		[58319] = small, -- Lesser Sha
		[59598] = small, -- Lesser Sha
		[59553] = medium, -- The Songbird Queen
		[59545] = small, -- Golden Beetle
		[59544] = medium, -- The Nodding Tiger
		[59552] = medium, -- The Crybaby Hozen
		[200131] = medium, -- Sha-Touched Guardian
		[57109] = small, -- Minion of Doubt
		[200388] = small, -- Malformed Sha
		[200387] = medium, -- Shambling Infester
	}

	local nokhudOffensive = {
		[192803] = small, -- War Ohuna
		[192794] = small, -- Nokhud Beastmaster
		[192796] = medium, -- Nokhud Hornsounder
		[192789] = small, -- Nokhud Longbow
		[192800] = medium, -- Nokhud Lancemaster
		[191847] = medium, -- Nokhud Plainstomper
		[194898] = small, -- Primalist Arcblade
		[194895] = small, -- Unstable Squall
		[194896] = small, -- Primal Stormshield
		[194897] = small, -- Stormsurge Totem
		[195579] = small, -- Primal Gust
		[195696] = medium, -- Primalist Thunderbeast
		[195855] = small, -- Risen Warrior
		[195875] = small, -- Desecrated Bakar
		[196645] = small, -- Desecrated Bakar
		[195878] = medium, -- Ukhel Beastcaller
		[195876] = small, -- Descecrated Ohuna
		[195851] = medium, -- Ukhel Deathspeaker
		[195927] = medium, -- Soulharvester Galtmaa (same)
		[195928] = medium, -- Soulharvester Duuren (same)
		[195929] = medium, -- Soulharvester Tumen (same)
		[195930] = medium, -- Soulharvester Mandakh (same)
		[193553] = small, -- Nokhud Warhound
		[193555] = small, -- Nokhud Villager (female)
		[186643] = small, -- Nokhud Villager (male)
		[193544] = small, -- Nokhud Houndsman
		[193565] = medium, -- Nokhud Defender
		[193457] = medium, -- Balara
		[196263] = small, -- Nokhud Neophyte
		[199325] = small, -- Nokhud Stormcaller
		[196484] = small, -- Nokhud Stormcaller
		[199294] = small, -- Nokhud Stormcaster
		[199320] = small, -- Nokhud Warspear (RP version)
		[199321] = small, -- Nokhud Warspear (RP version)
	}

	local courtOfStars = {
		[105703] = small, -- Mana Wyrm,
		[104251] = medium, -- Duskwatch Sentry
		[104246] = medium, -- Duskwatch Guard
		[111563] = medium, -- Duskwatch Guard
		[105705] = medium, -- Bound Energy
		[104295] = small, -- Blazing Imp
		[104277] = small, -- Legion Hound
		[104300] = medium, -- Shadow Mistress
	}

	local shadowmoonBurialGrounds = {
		[75715] = medium, -- Reanimated Ritual Bones
		[75451] = small, -- Defiled Spirit (non-casting)
		[75506] = medium, -- Shadowmoon Loyalist
		[77006] = small, -- Corpse Skitterling
		[76444] = small, -- Subjugated Soul
	}

	local algetharAcademy = {
		[196642] = extrasmall, -- Hungry Lasher
		[197398] = extrasmall, -- Hungry Lasher
		[192329] = small, -- Territorial Eagle
		[196694] = extrasmall, -- Arcane Forager
		[196671] = medium, -- Arcane Ravager
		[196577] = small, -- Spellbound Battleaxe
		[197904] = small, -- Spellbound Battleaxe
		[196798] = medium, -- Corrupted Manafiend
		[196045] = medium, -- Corrupted Manafiend
		[196200] = small, -- Algeth'ar Echoknight
		[196202] = medium, -- Spectral Invoker
		[196203] = small, -- Ethereal Restorer
	}

	local azureVault = {
		[191313] = small, -- Bubbling Sapling
		[196559] = small, -- Volatile Sapling
		[187155] = medium, -- Rune Seal Keeper
		[187154] = medium, -- Unstable Curator
		[196116] = medium, -- Crystal Fury
		[196117] = small, -- Crystal Thrasher
		[186740] = small, -- Arcane Construct
		[189555] = small, -- Arcane Attendant
		[190510] = small, -- Vault Guard
		[191739] = medium, -- Scalebane Liutenant
		[187246] = small, -- Nullmagic Hornswog
		[187242] = small, -- Tarasek Looter
		[187240] = medium, -- Draconid Breaker
	}

	local hallsOfValor = {
		[97087] = small, -- Valajar Champion
		[95842] = medium, -- Valajar Thundercaller
		[96574] = medium, -- Stormforged Sentinel
		[95832] = small, -- Valajar Shieldmaiden
		[101639] = small, -- Valajar Shieldmaiden
		[101637] = medium, -- Valajar Aspirant
		[97197] = medium, -- Valajar Purifier
		[96640] = medium, -- Valajar Marksman
		[96611] = small, -- Angehoof Bull
		[99922] = small, -- Ebonclaw Packmate
		[96608] = small, -- Ebonclaw Worg
		[97068] = medium, -- Storm Drake
	}

	local rubyLifePools = {
		[188011] = small, -- Primal Terrasentry
		[188067] = small, -- Flashfrost Chillweaver
		[188244] = medium, -- Primal Juggernaut
		[189893] = small, -- Infused Whelp
		[187894] = small, -- Infused Whelp
		[187897] = medium, -- Defier Draghar
		[194622] = small, -- Scorchling
		[190205] = small, -- Scorchling
		[197698] = medium, -- Thunderhead
		[190034] = medium, -- Blazebound Destroyer
		[190207] = medium, -- Primalist Cinderweaver
		[197697] = medium, -- Flamegullet
		[197509] = extrasmall, -- Primal Thundercloud
		[197982] = small, -- Storm Warrior
	}

	local underrot = {
		[131402] = small, -- Underrot Tick
		[131436] = medium, -- Chosen Blood Matron
		[133663] = medium, -- Fanatical Headhunter
		[133852] = small, -- Living Rot
		[130909] = medium, -- Fetid Maggot
		[133836] = small, -- Reanimated Guardian
		[134284] = medium, -- Fallen Deathspeaker
		[135169] = small, -- Spirit Drain Totem
		[138281] = medium, -- Faceless Corruptor
		[137458] = small, -- Rotting Spore
	}

	local freehold = {
		[126928] = small, -- Irontide Corsair
		[126918] = medium, -- Irontide Crackshot
		[128551] = small, -- Irontide Mastiff
		[129602] = medium, -- Irontide Enforcer
		[127119] = small, -- Freehold Deckhand
		[130521] = small, -- Freehold Deckhand
		[129550] = small, -- Bilge Rat Padfoot
		[129526] = small, -- Bilge Rat Swabby
		[129548] = small, -- Blacktooth Brute
		[130522] = small, -- Freehold Shipmate
		[127124] = small, -- Freehold Barhand
		[129559] = small, -- Cutwater Duelist
		[130404] = medium, -- Vermin Trapper
		[126497] = small, -- Shiprat
		[130024] = small, -- Soggy Shiprat
		[129527] = medium, -- Bilge Rat Buccaneer
		[130011] = small, -- Irontide Buccaneer
		[129599] = small, -- Cutwater Knife Juggler
		[129547] = small, -- Blacktooth Knuckleduster
		[129529] = small, -- Blacktooth Scrapper
		[129601] = small, -- Cutwater Harpooner
		[130400] = medium, -- Irontide Crusher
		[127019] = small, -- Target Dummy
		[130012] = small, -- Irontide Ravager
		[127111] = medium, -- Irontide Oarsman
		[127106] = small, -- Irontide Officer
	}

	local neltharionsLair = {
		[96247] = extrasmall, -- Vileshard Crawler
		[98406] = medium, -- Embershard Scorpion
		[91001] = medium, -- Tarspitter Lurker
		[101438] = medium, -- Vileshard Chunk
		[105636] = small, -- Understone Drudge
		[105720] = small, -- Understone Drudge
		[92350] = small, -- Understone Drudge
		[92610] = small, -- Understone Drummer
		[92387] = small, -- Drums of War
		[91332] = medium, -- Stoneclaw Hunter
		[90997] = medium, -- Mightstone Breaker
		[113998] = medium, -- Mightstone Breaker
		[94224] = small, -- Petrifying Totem
		[90998] = medium, -- Blightshard Shaper
		[101437] = small, -- Burning Geode
		[102430] = small, -- Tarspitter SLug
		[102253] = small, -- Understone Demolisher
	}

	local vortexPinnacle = {
		[205326] = small, -- Gust Soldier
		[45477] = small, -- Gust Soldier
		[45915] = medium, -- Armored Mistral
		[45704] = small, -- Lurking Tempest
		[204337] = small, -- Lurking Tempest
		[45917] = medium, -- Cloud Prince
		[45924] = medium, -- Turbulent Squall
		[45922] = small, -- Empyrean Assassin
		[45926] = small, -- Servant of Asaad
		[45928] = medium, -- Executor of the Caliph
		[45932] = small, -- Skyfall Star
		[45930] = medium, -- Minister of Air
	}

	local hallsOfInfusion = {
		[190345] = small, -- Primalist Geomancer
		[190348] = small, -- Primalist Ravager
		[190342] = medium, -- Containment Apperatus
		[196712] = medium, -- Nullification Device
		[190366] = small, -- Curious Swoglet
		[195399] = extrasmall, -- Curious Swoglet
		[199037] = medium, -- Primalist Shocktrooper
		[190370] = medium, -- Squallbringer Cyraz
		[190923] = extrasmall, -- Zephyrling
		[190373] = medium, -- Primalist Galesinger
		[190371] = medium, -- Primalist Earthshaker
		[190407] = small, -- Aqua Rager
		[190359] = small, -- Skulking Zealot
		[190406] = small, -- Aqualing
	}

	local neltharus = {
		[192787] = small, -- Qalashi Spinecrusher
		[193293] = small, -- Qalashi Warden
		[192781] = small, -- Ore Elemental
		[192786] = small, -- Qalashi Plunderer
		[189227] = medium, -- Qalashi Hunter
		[189247] = small, -- Tamed Phoenix
		[189266] = small, -- Qalashi Trainee
		[189472] = small, -- Qalashi Lavabearer
		[189471] = medium, -- Qalashi Blacksmith
		[193291] = medium, -- Apex Blazewing
		[194389] = small, -- Lava Spawn
	}

	local uldaman = {
		[184134] = small, -- Scavenging Leaper
		[184020] = small, -- Hulking Berserker
		[184019] = small, -- Burly Rock-Thrower
		[186664] = small, -- Stonevault Ambusher
		[186696] = larger, -- Quaking Totem
		[184130] = small, -- Earthen Custodian
		[184319] = medium, -- Refti Custodian
		[184107] = medium, -- Runic Protector
		[184303] = small, -- Skittering Crawler
		[184300] = medium, -- Ebonstone Golem
		[184131] = medium, -- Earthen Guardian
		[184331] = medium, -- Infinite Timereaver
		[191311] = small, -- Infinite Whelp
	}

	local brackenhideHollow = {
		[185529] = medium, -- Bracken Warscourge
		[185508] = small, -- Claw Fighter
		[186206] = small, -- Cruel Bonecrusher
		[186191] = medium, -- Decay Speaker
		[185534] = medium, -- Bonebolt Hunter
		[185691] = small, -- Vicious Hyena
		[186122] = small, -- Rira Hackclaw
		[186124] = medium, -- Gashtooth
		[186208] = medium, -- Rotbow Stalker
		[186284] = small, -- Gutchewer Bear
		[194745] = small, -- Rotfang Hyena
		[186227] = small, -- Monstrous Decay
		[189299] = extrasmall, -- Decaying Slime
		[192481] = extrasmall, -- Decaying Slime (boss adds)
		[194330] = extrasmall, -- Decaying Slime (from big slime split)
		[199916] = small, -- Decaying Slime
		[194273] = extrasmall, -- Witherling
		[187238] = extrasmall, -- Witherling
		[187231] = small, -- Wither Biter
		[187315] = small, -- Disease Slasher
		[191243] = small, -- Wild Lasher
		[189363] = extrasmall, -- Infected Lasher
		[208994] = extrasmall, -- Infected Lasher
		[189531] = medium, -- Decayed Elder
		[186226] = medium, -- Fetid Rotsinger
		[186229] = medium, -- Wilted Oak
		[194373] = small, -- Witherling
		[190381] = larger, -- Rotburst Totem
	}

	local murozondsRise = {
		[205151] = extrasmall, -- Tyr's Vanguard
	}

	local misc = {
		-- Fodder to the Flame demons
		[169428] = small,
		[169430] = small,
		[169429] = small,
		[169426] = small,
		[169421] = small,
		[169425] = small,
		[168932] = small,
		[189707] = small, -- Chaotic Motes, SL Fated affix
	}

	local maps = {
		test,
		amirdrassil,
		atalDazar,
		waycrestManor,
		darkheartThicket,
		everbloom,
		blackRookHold,
		galakrondsFall,
		throneOfTheTides,
		templeOfTheJadeSerpent,
		nokhudOffensive,
		courtOfStars,
		shadowmoonBurialGrounds,
		algetharAcademy,
		azureVault,
		hallsOfValor,
		rubyLifePools,
		underrot,
		freehold,
		neltharionsLair,
		vortexPinnacle,
		hallsOfInfusion,
		neltharus,
		uldaman,
		brackenhideHollow,
		murozondsRise,
		misc,
		vault,
		sepulcher,
		nathria,
		nerubarPalace,
		araKara,
		cityOfThreads,
		tazavesh,
		theaterOfPain,
		necroticWake,
		mistsOfTirnaScithe,
		hallsOfAtonement,
		deOtherSide,
		plaguefall,
		sanguineDepths,
		grimBatol,
		sigeOfBoralus,
		mechagon,
	}

	for _, map in pairs(maps) do
		for id, priority in pairs(map) do
			modTable.npcIDs[id] = priority
		end
	end

	---@param id number
	---@return boolean
	function modTable.isSpiteful(id)
		return tonumber(id) == 174773
	end

	---@param unit string
	---@return number|nil
	function modTable.parseGUID(unit)
		local guid = UnitGUID(unit)

		if not guid then
			return nil
		end

		local id = select(6, strsplit("-", guid))

		return id and tonumber(id) or nil
	end

	---@param unitId string
	---@return boolean
	function modTable.spitefulTargetsPlayer(unitId)
		local targetName = UnitName(unitId .. "target")

		if not targetName then
			return false
		end

		return UnitIsUnit(targetName, "player")
	end
end
