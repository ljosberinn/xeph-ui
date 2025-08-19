function f(modTable)
	modTable.isActive = modTable.config.scale and WOW_PROJECT_ID == WOW_PROJECT_MAINLINE

	local medium = modTable.config.midScale -- 0.90
	local small = modTable.config.lowScale -- 0.80
	local extrasmall = modTable.config.extraLowScale -- 0.70,
	local larger = modTable.config.higherScale -- 1.1

	--[[
    GUIDELINES
    - use LARGER for enemies with great situational importance that need extra attention
        ex: totems at the end of Stonevault, Spiteful targeting you
    - use MEDIUM for enemies that do little to nothing but melee the tank and have average health
        OR casters without mandatory kick
        ex: Patchwerk Soldier, Necrotic Wake | Tainted Lashers, Gnarlroot
        ex: Primalist Galesinger, Halls of Infusion
    - use SMALL for enemies that do nothing but melee the tank and have less than average health
        -- ex: Jagged Hound, Waycrest Manor
    - use EXTRA SMALL for enemies that do nothing at all AND/OR there's so many on the screen, you have no choice
        ex: Fiery Vines, Tindral | Hungry Lashers, Academy
    ]]
	--

	---@class SpitefulLikeScaling
	---@field self number
	---@field others number

	---@type table<number, SpitefulLikeScaling>
	---@description table of npc ids with conditional scaling based on their current target
	local spitefulLikes = {
		[220626] = { -- Blood Parasite, Ovinax
			self = larger,
			others = extrasmall,
		},
		[235631] = { -- Crawler Mine, Motherlode
			self = larger,
			others = small,
		},
		[133482] = { -- Crawler Mine, Motherlode
			self = larger,
			others = small,
		},
		[167898] = { -- Manifestation of Envy, HoA
			self = medium,
			others = small,
		},
		[231014] = { -- Loaderbot - Floodgate
			self = larger,
			others = medium,
		},
	}

	---@table<number, number>
	modTable.npcIDs = {}

	modTable.playerMetaInformation = {
		specId = nil,
		isRdps = false,
		isTank = false,
		isMdps = false,
		isHealer = false,
		lastQuery = 0,
	}

	local function GetCurrentSpecId()
		local diff = GetTime() - modTable.playerMetaInformation.lastQuery

		if diff >= 60 then
			modTable.playerMetaInformation.lastQuery = GetTime()
			return PlayerUtil.GetCurrentSpecID()
		end

		return modTable.playerMetaInformation.specId
	end

	---@return  boolean, boolean, boolean, boolean
	function modTable.determinePlayerMetaInformation(specId)
		local role = select(5, GetSpecializationInfoByID(specId))

		if role == "NONE" then
			role = "DAMAGER"
		end

		local isTank = false
		local isHealer = false
		local isRdps = false
		local isMdps = false

		if role == "TANK" then
			isTank = true
		elseif role == "HEALER" then
			isHealer = true
		elseif role == "DAMAGER" then
			isRdps = specId == 102 -- balance
				or specId == 1467 -- devastation
				or specId == 1473 -- augmentation
				or specId == 253 -- beast mastery
				or specId == 254 -- marksmanship
				or specId == 62 -- arcane
				or specId == 63 -- fire
				or specId == 64 -- frost
				or specId == 258 -- shadow
				or specId == 262 -- elemental
				or specId == 265 -- afflictin
				or specId == 266 -- demonology
				or specId == 267 -- destruction

			isMdps = not isRdps
		end

		return isRdps, isTank, isMdps, isHealer
	end

	---@param defaultScale number
	---@param condition boolean
	---@return number
	local function downscaleByOneIf(defaultScale, condition)
		if condition then
			if defaultScale == larger then
				return medium
			elseif defaultScale == medium then
				return small
			end
		end

		return defaultScale
	end

	function modTable.compile(force)
		if not modTable.isActive then
			return
		end

		local specId = GetCurrentSpecId()

		if not force and specId == modTable.playerMetaInformation.specId then
			return
		end

		modTable.playerMetaInformation.specId = specId

		local isRdps, isTank, isMdps, isHealer = modTable.determinePlayerMetaInformation(specId)

		if
			not force
			and isRdps == modTable.playerMetaInformation.isRdps
			and isTank == modTable.playerMetaInformation.isTank
			and isMdps == modTable.playerMetaInformation.isMdps
			and isHealer == modTable.playerMetaInformation.isHealer
		then
			return
		end

		modTable.playerMetaInformation.isRdps = isRdps
		modTable.playerMetaInformation.isTank = isTank
		modTable.playerMetaInformation.isMdps = isMdps
		modTable.playerMetaInformation.isHealer = isHealer

		table.wipe(modTable.npcIDs)

		local test = {
			--[87329] = extrasmall, -- test dummy
		}
		-- raids

		local manaforgeOmega = {}
		if not isTank then
			manaforgeOmega[244922] = medium -- Shadowguard Phaseblade
		end

		local liberationOfUndermine = {
			[231935] = small, -- Junkyard Hyena
			[236280] = small, -- Tiny Torq
			[236284] = small, -- Fun-sized Flarendo
			[231977] = medium, -- Darkfuse Technician
		}

		local nerubarPalace = {
			[219739] = small, -- Infested Spawn
			[223674] = small, --Skitterer - Ansurek
			[219746] = small, -- Tomb - Ansurek
			[221344] = medium, -- Gloom Hatchling - Ansurek
		}
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

		-- War Within dungeons
		local ecoDomeAldani = {
			[234870] = small, -- Invading Mite
			[234912] = medium, -- Ravaging Scavenger
			[245411] = medium, -- Ravaging Scavenger
			[234960] = medium, -- Tamed Ruinstalker
			[239379] = small, -- Unbound Ethereal
		}

		local operationFloodgate = {
			[231497] = medium, -- Bombshell crab
			--[231014] = medium, -- Loaderbot
			[229252] = medium, -- Darkfuse Hyena
			[228144] = downscaleByOneIf(medium, isRdps or isMdps), -- Darkfuse Soldier
		}
		if not isTank then
			operationFloodgate[227145] = medium -- Waterworks Crocolisk
		end

		local theRookery = {
			[219066] = small, -- Citizen
		}

		local prioryOfTheSacredFlame = {
			[212838] = small, --Arathi Neophyte
			[207943] = extrasmall, --Arathi Neophyte
			[206705] = small, -- Arathi Footman
			[206699] = downscaleByOneIf(medium, isMdps or isTank), -- War lynx
			[206694] = medium, -- Fervent Sharpshooter
			[211140] = small, -- Arathi Neophyte - Last boss
		}

		local darkflameCleft = {
			[210148] = small, -- Menial Laborer
			[210810] = small, -- Menial Laborer
			[208457] = small, -- Skittering Darkness
			[213008] = medium, -- Wriggling Darkspawn
		}

		local cinderbrewMeadery = {
			[218671] = medium, -- Pyromaniac
			[217126] = extrasmall, --Over-indulged Patron
			[214668] = small, -- Patron
			[214920] = small, -- Tasting room attendant
			[218865] = small, --Bee-let
			[210270] = small, --Brew Drop
			[223562] = small, --Brew Drop #2
		}

		local stoneVault = {
			[214287] = larger, --Earth Burst Totem
		}

		local araKara = {
			[216336] = small, --Ravenous Crawler
			[216341] = small, --Jabbing Flyer
			[218325] = extrasmall, --Swarming Flyer
			[216337] = small, --Bloodworker
			[215968] = small, -- Black blood
		}

		local cityOfThreads = {
			[220199] = small, --Battle Scarab
			[216363] = medium, --Reenforced drone
			[216365] = medium, --Carrier
			[223357] = medium, --Conscript
			[216329] = small, --Droplet
			[220065] = small, --Umbral Weave
			[222700] = small, --Umbral Weave
			[219198] = medium, --Ravenous Scarab
			[216342] = medium, -- Skittering Assistant
		}

		local theDawnbreaker = {
			[224616] = small, -- Animated Shadow
			[213894] = medium, -- Nightfall Curseblade
			[223995] = medium, -- Nightfall Curseblade
		}
		if not isTank then
			theDawnbreaker[213895] = medium -- Nightfall Shadowalker
		end

		-- DF Dungeons

		local murozondsRise = {
			[205151] = small, -- Tyr's Vanguard
		}

		local galakrondsFall = {
			[204536] = extrasmall, -- Blight Chunk
			[206065] = extrasmall, -- Interval
		}

		local hallsOfInfusion = {
			[190923] = small, -- Zephyrling
		}

		local neltharus = {
			[192781] = small, -- Ore Elemental
			[194389] = small, -- Lava Spawn
		}

		local uldaman = {
			[184134] = small, -- Scavenging Leaper
			[186696] = larger, -- Quaking Totem
		}

		local brackenhideHollow = {
			[189299] = small, -- Decaying Slime
			[192481] = small, -- Decaying Slime (boss adds)
			[194330] = small, -- Decaying Slime (from big slime split)
			[199916] = small, -- Decaying Slime
			[194273] = small, -- Witherling
			[187238] = small, -- Witherling
			[189363] = extrasmall, -- Infected Lasher
			[208994] = extrasmall, -- Infected Lasher
			[194373] = small, -- Witherling
			[190381] = larger, -- Rotburst Totem
		}

		local algetharAcademy = {
			[196642] = extrasmall, -- Hungry Lasher
			[197398] = extrasmall, -- Hungry Lasher
			[192329] = small, -- Territorial Eagle
			[196694] = medium, -- Arcane Forager
		}

		local azureVault = {
			[191313] = extrasmall, -- Bubbling Sapling
			[196559] = extrasmall, -- Volatile Sapling
			[187246] = medium, -- Nullmagic Hornswog
			[187242] = medium, -- Tarasek Looter
			[187159] = small, -- Whelp
		}

		local rubyLifePools = {
			[189893] = extrasmall, -- Infused Whelp
			[187894] = extrasmall, -- Infused Whelp
			[194622] = extrasmall, -- Scorchling
			[190205] = extrasmall, -- Scorchling
			[197509] = extrasmall, -- Primal Thundercloud
		}

		local nokhudOffensive = {
			[195855] = small, -- Risen Warrior
			[195875] = small, -- Desecrated Bakar
			[196645] = small, -- Desecrated Bakar
		}

		-- Shadowlands Dungeons

		local tazavesh = {
			[178163] = small, -- Murkbrine Shorerunner - Gambit
			[178394] = medium, -- Cartel Lackey - Streets
			[176396] = medium, -- Defective Sorter - Streets
			[177807] = medium, -- Customs Security
			[179386] = medium, -- Corsair Officer
			[180432] = small, -- Devoted Accomplice
		}
		if not isTank then
			tazavesh[176394] = medium -- P.O.S.T. Worker
			tazavesh[180015] = medium -- Burly Deckhand
		end

		local theaterOfPain = {
			[163089] = small, -- Disgusting Refuse
			[169875] = medium, -- Shackled Soul
			[167994] = medium, -- Ossified Conscript
		}

		local necroticWake = {
			[166264] = small, -- Spare Parts
			[166266] = small, -- Spare Parts #2
			[171500] = extrasmall, -- Shuffling Corpse
			[165138] = small, -- Blight bag
			[162729] = medium, -- Patchwerk Soldier
			[163122] = small, -- Brittlebone Warrior
			[164427] = small, -- Reanimated Warrior
		}

		local mistsOfTirnaScithe = {
			[165111] = medium, -- Drust Spiteclaw
			[167117] = small, -- Larva
		}

		local hallsOfAtonement = {
			[167892] = small, -- Tormented Soul
			[167806] = small, -- Animated Sin
			[167610] = small, -- Anklebiter
			[165415] = small, -- Toiling Groundskeeper
			[164363] = medium, -- Undying Stonefiend - Echelon
		}
		if isRdps then
			hallsOfAtonement[164563] = medium -- Vicious Gargon
			hallsOfAtonement[165515] = medium -- Depraved Darkblade
		end

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

		--BFA Dungeons

		local theMotherlode = {
			[130436] = medium, -- Off-Duty Laborer
			[136006] = extrasmall, -- Rowdy Reveler
			[136005] = extrasmall, -- Rowdy Reveler
			[130437] = medium, -- Mine Rat
			[133963] = small, -- Test Subject
			[130653] = small, -- Wanton Sapper
			[134005] = small, -- Shalebiter
			[138369] = small, -- Footbomb Hooligan
		}

		local mechagon = {
			[144300] = extrasmall, -- Mechagon Citizen
			[150547] = medium, -- Scrapbone Grunter
			[144301] = small, -- Living Waste
		}

		local siegeOfBoralus = {
			[133990] = medium, -- Scrimshaw Gutter
			[138002] = medium, -- Scrimshaw Gutter
			[135258] = medium, -- Curseblade
		}

		local atalDazar = {
			[128435] = extrasmall, -- saurid
		}

		local waycrestManor = {
			[131669] = small, -- Jagged Hound
		}

		local underrot = {
			[131402] = extrasmall, -- Underrot Tick
		}

		local freehold = {
			[130024] = small, -- Soggy Shiprat
		}

		-- Legion Dungeons

		local hallsOfValor = {
			[97087] = medium, -- Valajar Champion
			[96640] = medium, -- Valajar Marksman
			[99922] = small, -- Ebonclaw Packmate
			[96608] = medium, -- Ebonclaw Worg
			[96609] = medium, -- Gildedfur Stag
		}

		local darkheartThicket = {
			[100529] = small, -- Hatespawn Slime
			[101074] = small, -- Hatespawn Whelpling
			[100991] = small, -- Strangling Roots
			[107288] = small, -- Vilethorn Sapling
		}

		local blackRookHold = {
			[98677] = small, -- Rook Spiderling
			[98900] = medium, -- Wyrmtongue Trickster
			[102781] = extrasmall, -- Fel Bat Pup
		}

		local courtOfStars = {
			[105703] = small, -- Mana Wyrm,
			[104295] = small, -- Blazing Imp
		}

		local neltharionsLair = {
			[96247] = extrasmall, -- Vileshard Crawler
			[102430] = small, -- Tarspitter Slug
		}

		-- WoD Dungeons

		local everbloom = {
			[81864] = small, -- Dreadpetal
			[84401] = small, -- Swift Sproutling
		}

		local shadowmoonBurialGrounds = {
			[75451] = small, -- Defiled Spirit (non-casting)
			[77006] = small, -- Corpse Skitterling
			[76444] = small, -- Subjugated Soul
		}
		-- MoP Dungeons
		local templeOfTheJadeSerpent = {
			[62358] = small, -- Corrupt Droplet
			[58319] = small, -- Lesser Sha
			[59598] = small, -- Lesser Sha
		}

		-- Cata Dungeons

		local throneOfTheTides = {
			[40923] = extrasmall, -- Unstable Corruption
		}

		local vortexPinnacle = {
			[205326] = medium, -- Gust Soldier
			[45477] = medium, -- Gust Soldier
			[45704] = small, -- Lurking Tempest
			[204337] = small, -- Lurking Tempest
			[45924] = medium, -- Turbulent Squall
			[45922] = medium, -- Empyrean Assassin
			[45926] = medium, -- Servant of Asaad
			[45932] = small, -- Skyfall Star
		}

		local grimBatol = {
			[224853] = small, -- Hatchling
			[39388] = medium, -- Boss Hatchling
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
			-- Misc
			[189707] = small, -- Chaotic Motes, SL Fated affix
			[229537] = larger, -- Void Emissary
			[229296] = small, -- Orb of Ascendance
		}

		local maps = {
			test,
			manaforgeOmega,
			liberationOfUndermine,
			ecoDomeAldani,
			operationFloodgate,
			theMotherlode,
			theRookery,
			prioryOfTheSacredFlame,
			darkflameCleft,
			cinderbrewMeadery,
			theDawnbreaker,
			stoneVault,
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
			siegeOfBoralus,
			mechagon,
		}

		for i = 1, #maps do
			local map = maps[i]

			for id, priority in pairs(map) do
				modTable.npcIDs[id] = priority
			end
		end
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

	---@param id number
	---@return boolean
	function modTable.isSpitefulLike(id)
		return spitefulLikes[id] ~= nil
	end

	function modTable.getSpitefulLikeScale(id)
		return spitefulLikes[id]
	end

	---@param unitId string
	---@return boolean
	function modTable.targetsPlayer(unitId)
		local targetName = UnitName(unitId .. "target")

		if not targetName then
			return false
		end

		return UnitIsUnit(targetName, "player")
	end
end
