function f(modTable)
	local prioScaleMap = {
		[1] = modTable.config.midScale, -- 0.9
		[2] = modTable.config.lowScale, -- 0.8
		[3] = modTable.config.extraLowScale, -- 0.7,
		[4] = modTable.config.higherScale, -- 1.1
	}

	modTable["npcIDs"] = {

		--TEST
		--[87329] = 1, --Testing Dummy
		--[194644] = 4, -- Valdrakken Dummy

		--                                                          DUNGEONS

		--THE WAR WITHIN

		--Ara-kara
		[216336] = 1, --Ravenous Crawler
		[216341] = 1, --Jabbing Flyer
		[218325] = 1, --Swarming Flyer

		--City of Threads
		[220199] = 2, --Battle Scarab
		[216363] = 1, --Reenforced drone
		[216365] = 1, --Carrier
		[223357] = 1, --Conscript
		[216329] = 2, --Droplet
		[220065] = 2, --Umbral Weave
		[222700] = 2, --Umbral Weave
		[219198] = 1, --Ravenous Scarab

		--DRAGONFLIGHT

		--Nokhud Offensive
		[195875] = 2, --Desecrated Bakar
		[195855] = 1, -- Risen Warrior

		--Dawn of the Infinite
		[204536] = 2, --Blight Chunk
		[206063] = 1, -- Temporal Deviation

		--Halls of Infusion
		[190923] = 2, --Zephyrling

		--Brackenhide Hollow
		[189299] = 2, -- Decaying Slime
		[189363] = 2, -- Infected Lasher
		[194373] = 1, -- Witherling

		--Uldaman
		[184134] = 2, -- Scavaging Leaper

		--The Nokhud Offensive
		[195579] = 2, --Primal Gust

		--Algeth'ar Academy
		[196642] = 2, --Hungry Lasher
		[197398] = 2, --Hungry Lasher
		[196694] = 1, --Arcane Forager
		[192329] = 1, --Territorial Eagle

		--The Azure Vault
		[191313] = 2, -- Volatile Sapling
		[187242] = 1, --Tarasek Delver

		--Ruby Life Pools
		[190205] = 1, --Scorchling
		[197509] = 2, --Primal Thundercloud
		[187894] = 1, --Infused Whelp

		--SL DUNGEONS

		--Tazavesh
		[178163] = 2, --Murkbrine Shorerunner

		--Theater of Pain
		[163089] = 2, --Disgusting Refuse

		--Necrotic Wake
		[166264] = 2, --Spare Parts
		[166266] = 2, --Spare Parts #2
		[171500] = 2, --Shuffling Corpse
		[165138] = 2, --Blight bag
		[162729] = 1, --Patchwerk Soldier

		--Mists
		[165111] = 1, --Drust Spiteclaw
		[167117] = 2, --Larva

		--Sanguine Depths
		[171455] = 2, --Stonewall Gargon
		[168457] = 2, --Stonewall Gargon
		[166589] = 2, --Animate Weapon

		--Plaguefall
		[168969] = 2, --Gushing Slime

		--De Other Side
		[168986] = 2, --Skeletal Raptor

		--Halls of Atonement
		[167892] = 1, --Tormented Soul

		--BFA DUNGEONS

		--Siege
		[133990] = 1, --Scrimshaw Gutter
		[138002] = 1, --Scrimshaw Gutter
		[135258] = 1, --Curseblade

		--Waycrest manor
		[131669] = 1, --Jagged Hound

		--Atal'Dazar
		[128435] = 1, --Saurid's

		-- Freehold
		[130024] = 2, --Soggy Shiprat

		-- Underrot
		[131402] = 1, --Underrot Tick

		-- Mechagon
		[144300] = 2, --Mechagon Citizen

		--LEGION DUNGEONS

		--Darkheart Thicket
		[100529] = 2, --Hatespawn Slime
		[101074] = 2, --Hatespawn Whelpling

		--Blackrook Hold
		[98677] = 2, --Rook Spiderling
		[98900] = 1, --Wyrmtongue Trickster
		[102781] = 2, --Fel Bat Pup

		--Nelth's Lair
		[96247] = 2, -- Vileshard Crawler
		[102430] = 2, --Tarspitter Slug

		--Court of Stars
		[105703] = 2, --Mana Wyrm
		[104295] = 1, --Blazing Imp

		--OLD SHIT

		--Everbloom
		[81864] = 1, --Dreadpetal
		[84401] = 2, --Swift Sproutling

		--Throne of the tides
		[40923] = 2, --Unstable Corruption

		-- Temple of the Jade Serpent
		[58319] = 2, --Lesser Sha
		[62358] = 2, --Corrupt Droplet

		--Shadowmoon Burial Grounds
		[77006] = 2, --Corpse Skitterling
		[75451] = 1, --Defiled Spirit

		--Grim Batol
		[224853] = 2, --Hatchling
		[39388] = 1, --Boss Hatchling

		--                                                            RAIDS

		-- Rubar Palace
		[219739] = 2, -- Infested Spawn
		[220626] = 1, -- Parasite

		--Amirdrassil
		[210231] = 1, --Tainted Lasher
		[211306] = 2, --Fiery vines

		--Vault
		[194991] = 1, --Oathsworn Vanguard
		[191714] = 2, --Seeking Stormling

		--Sepulcher of the First Ones
		[183669] = 2, --Fiendish Soul

		--Castle Nathria
		[169925] = 2, --Begrudging Waiter

		--Misc
		[189707] = 2, --Chaotic Motes
	}

	modTable.isSpiteful = function(id)
		return tonumber(id) == 174773
	end

	modTable.parseGUID = function(unit)
		local guid = UnitGUID(unit)

		if not guid then
			return nil
		end

		local id = select(6, strsplit("-", guid))

		return id and tonumber(id) or nil
	end

	modTable.spitefulTargetsPlayer = function(unitId)
		local targetName = UnitName(unitId .. "target")

		if not targetName then
			return false
		end

		return UnitIsUnit(targetName, "player")
	end

	modTable.getScale = function(prio)
		if not modTable.config.scale then
			return nil
		end

		return prioScaleMap[prio]
	end
end
