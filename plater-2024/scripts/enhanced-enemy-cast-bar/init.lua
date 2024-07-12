function f(modTable)
	-- The list of supported spell reflection names and zones.
	local reflectableSpells = {
		-- Initial data for reflectable spells credit to: https://docs.google.com/spreadsheets/d/e/2PACX-1vS26lkSc_eaulHX7-UY8Uu-7DAHvkScxh3npd0kQn3uvvWsgsQm9ducLUi4R2mb7ieNluVilyq5sQe5/pubhtml#

		-- The Azure Vault
		[1] = {
			["spells"] = {
				"Infused Strike",
				"Illusionary Bolt",
				"Dragon Strike",
				"Arcane Bolt",
				"Infused Ground",
				"Condensed Frost",
				"Heavy Tome",
			},
			["zones"] = {
				2073,
				2074,
				2075,
				2076,
				2077,
			},
		},
		-- Algeth'ar Academy
		[2] = {
			["spells"] = {
				"Energy Bomb",
				"Darting Sting",
				"Arcane Missiles",
				"Vicious Ambush",
				"Surge",
				"Deadly Winds",
			},
			["zones"] = {
				2097,
				2098,
				2099,
			},
		},
		-- Court of Stars
		[3] = {
			["spells"] = {
				"Drifting Embers",
				"Firebolt",
				"Throw Torch",
				"Vampiric Claws",
				"Suppress",
				"Shadow Slash",
				"Eyestorm",
			},
			["zones"] = {
				761,
				762,
				763,
			},
		},
		-- Halls of Valor
		[4] = {
			["spells"] = {
				"Arcing Bolt",
				"Searing Light",
				"Etch",
				"Shattered Rune",
				"Thunderous Bolt",
			},
			["zones"] = {
				703,
				704,
				705,
				829,
			},
		},
		-- Ruby Life Pools
		[5] = {
			["spells"] = {
				"Cold Claws",
				"Frigid Shard",
				"Primal Chill",
				"Living Bomb",
				"Icebolt",
				"Cold Claws",
				"Cinderbolt",
				"Flame Dance",
				"Lightning Bolt",
				"Burning Touch",
				"Thunder Bolt",
			},
			["zones"] = {
				2094,
				2095,
			},
		},
		-- Shadowmoon Burial Grounds
		[6] = {
			["spells"] = {
				"Deathspike",
				"Void Devastation",
				"Death Blast",
				"Plague Spit",
				"Shadow Bolt",
				"Shadow Word: Frailty",
				"Rending Voidlash",
				"Void Bolt",
			},
			["zones"] = {
				574,
				575,
				576,
			},
		},
		-- Temple of the Jade Serpent
		[7] = {
			["spells"] = {
				"Hydrolance",
				"Agony",
				"Serpent Strike",
				"Jade Serpent Wave",
				"Defiling Mist",
				"Touch of Ruin",
				"Throw Torch",
				"Dark Claw",
			},
			["zones"] = {
				429,
				430,
				791,
				792,
			},
		},
		-- The Nokhud Offensive
		[8] = {
			["spells"] = {
				"Wind Burst",
				"Gale Arrow",
				"Conductive Strike",
				"Storm Shock",
				"Stormbolt",
				"Chain Lightning",
				"Thunderstrike",
				"Death Bolt",
				"Surge",
			},
			["zones"] = {
				2093,
			},
		},
		-- Vault of the Incarnates
		[9] = {
			["spells"] = {
				"Primal Flow",
				"Pyroblast",
				"Chain Lightning",
				"Frost Spike",
				"Lightning Bolt",
				"Aerial Buffet",
				"Aerial Slash",
				"Storm Bolt",
				"Ice Barrage",
				"Static Jolt",
			},
			["zones"] = {
				2119,
				2120,
				2121,
				2122,
				2123,
				2124,
				2125,
				2126,
			},
		},
		-- Brackenhide Hollow
		[10] = {
			["spells"] = {
				"Earth Bolt",
				"Decayed Senses",
				"Touch of Decay",
				"Decay Surge",
			},
			["zones"] = {
				2096,
				2106,
			},
		},
		-- Halls of Infusion
		[11] = {
			["spells"] = {
				"Purifying Blast",
				"Gulp Swog Toxin",
				"Focused Deluge",
				"Squall Buffet",
				"Containment Beam",
				"Pyretic Burst",
				"Ice Shard",
				"Lightning Blast",
				"Frost Shock",
				"Wind Buffet",
			},
			["zones"] = {
				2082,
				2083,
			},
		},
		-- Netharus
		[12] = {
			["spells"] = {
				"Grounding Spear",
				"Melt",
				"Lava Bolt",
				"Magma Conflagration",
			},
			["zones"] = {
				2080,
				2081,
			},
		},
		-- Uldaman
		[13] = {
			["spells"] = {
				"Chain Lightning",
				"Stone Spike",
				"Earthen Shards",
				"Burning Heat",
				"Stone Bolt",
				"Venomous Fangs",
				"Time Sink",
				"Spiked Carapace",
				"Curse of Stone",
			},
			["zones"] = {
				2071,
				2072,
			},
		},
		-- Freehold
		[14] = {
			["spells"] = {
				"Water Bolt",
				"Lightning Bolt",
				"Infected Wound",
				"Oiled Blade",
			},
			["zones"] = {
				936,
			},
		},
		-- Underrot
		[15] = {
			["spells"] = {
				"Blood Bolt",
				"Wicked Embrace",
				"Decaying Mind",
				"Void Spit",
			},
			["zones"] = {
				1041,
				1042,
			},
		},
		-- Neltharion's Lair
		[16] = {
			["spells"] = {
				"Stone Gaze",
				"Stone Bolt",
				"Toxic Retch",
				"Molten Crash",
				"Piercing Shards",
				"Sunder",
			},
			["zones"] = {
				731,
			},
		},
		-- Vortex Pinnacle
		[17] = {
			["spells"] = {
				"Lightning Bolt",
				"Chain Lightning",
				"Rushing Wind",
				"Lightning Lash",
				"Starlight",
				"Holy Smite",
				"Wind Bolt",
			},
			["zones"] = {
				325,
				737,
			},
		},
		-- Abberus, the Shadowed Crucible
		[18] = {
			["spells"] = {
				"Flame Slash",
				"Shadow Spike",
				"Flaming Cudgel",
				"Lava Bolt",
				"Scorching Detonation",
				"Void Surge",
			},
			["zones"] = {
				2166,
				2167,
				2168,
				2169,
				2170,
			},
		},
		-- Dawn of the Infinite
		[19] = {
			["spells"] = {
				"Noxious Ejection",
				"Stonebolt",
				"Infinite Bolt",
				"Infinite Blast",
				"Fireball",
				"Immolate",
				"Temporal Blast",
				"Corroding Volley",
				"Epoch Bolt",
			},
			["zones"] = {
				2190,
				2191,
				2192,
				2193,
				2194,
				2195,
				2196,
				2197,
				2198,
			},
		},
		-- Amirdrassil
		[20] = {
			["spells"] = {
				"Coiling Flames",
				"Twisting Singe",
				"Fyr'alath's Flame",
			},
			["zones"] = {
				2232,
				2240,
				2244,
				2233,
				2234,
				2238,
			},
		},
		-- Atal'Dazar
		[21] = {
			["spells"] = {
				"Wildfire",
				"Venomfang Strike",
				"Venom Blast",
				"Soulburn",
				"Wracking Pain",
			},
			["zones"] = {
				934,
				935,
			},
		},
		-- Black Rook Hold
		[22] = {
			["spells"] = {
				"Soul Blast",
				"Arcane Blitz",
			},
			["zones"] = {
				751,
				752,
				753,
				754,
				755,
				756,
			},
		},
		-- Darkheart Thicket
		[23] = {
			["spells"] = {
				"Nightmare Bolt",
				"Feed on the Weak",
				"Bloodbolt",
				"Firebolt",
				"Nightmare Toxin",
				"Despair",
				"Unnerving Screech",
				"Tormenting Eye",
				"Shadow Bolt",
				"Darksoul Bite",
			},
			["zones"] = {
				733,
			},
		},
		-- Everbloom
		[24] = {
			["spells"] = {
				"Nature's Wrath",
				"Water Bolt",
				"Dreadpetal Pollen",
				"Arcane Blast",
				"Fireball",
				"Frostbolt",
				"Choking Vines",
				"Dancing Thorns",
				"Pyroblast",
				"Poisonous Claws",
			},
			["zones"] = {
				620,
				621,
			},
		},
		-- Throne of the Tides
		[25] = {
			["spells"] = {
				"Focused Tempest",
				"Frostbolt",
				"Water Bolt",
				"Flame Shock",
				"Mind Rot",
				"Foul Bolt",
				"Ink Blast",
				"Mind Flay",
				"Aquablast",
				"Hex",
				"Crushing Depths",
				"Lightning Bolt",
				"Lightning Surge",
			},
			["zones"] = {
				323,
				322,
			},
		},
		-- Waycrest Manor
		[26] = {
			["spells"] = {
				"Bramble Bolt",
				"Ruinous Bolt",
				"Soul Bolt",
				"Wasting Strike",
				"Wracking Chord",
				"Virulent Pathogen",
				"Darkened Lighting",
				"Shadow Cleave",
				"Infest",
				"Spit",
				"Etch",
				"Runic Mark",
				"Decaying Touch",
				"Dread Mark",
				"Runic Bolt",
				"Scar Soul",
				"Tearing Strike",
				"Drain Essence",
			},
			["zones"] = {
				1016,
				1015,
				1017,
				1018,
				1029,
			},
		},
	}

	modTable.reflectableSpellsByZoneId = {}

	-- TODO: above should just be a list of spell ids. zone can be dropped
	for _, tbl in pairs(reflectableSpells) do
		for i = 1, #tbl.zones do
			local zoneId = tbl.zones[i]
			modTable.reflectableSpellsByZoneId[zoneId] = {}
			for j = 1, #tbl.spells do
				local spellName = tbl.spells[j]
				modTable.reflectableSpellsByZoneId[zoneId][spellName] = true
			end
		end
	end
end
