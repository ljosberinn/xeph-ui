function f(modTable)
	modTable.reflectableSpells = {}

	if select(3, UnitClass("player")) == 1 then
		--TWW Dungeons

		--DF Dungeons

		local murozondsRise = {
			400165, -- Epoch Bolt
			413607, -- Corroding Volley
			418202, -- Temporal Blast
			417030, -- Fireball
			411763, -- Infinite Blast
			407121, -- Immolate
		}

		local galakrondsFall = {
			415435, -- Infinite Bolt
			413590, -- Noxious Ejection
			411958, -- Stonebolt
		}

		local rubyLifePools = {
			373803, -- Cold Claws boss adds
			372683, -- Cold Claws trash
			372808, -- Frigid Shard
			373693, -- Living Bomb
			371984, -- Icebolt
			384197, -- Cinderbolt
			384194, -- Cinderbolt
			392576, -- Thunderbolt
			385310, -- Lightning Bolt
			385536, -- Flame Dance
		}

		local azureVault = {
			374789, -- Infused Strike
			373932, -- Illusionary Bolt
			384978, -- Dragon Strike
			377503, -- Condensed Frost
			389804, -- Heavy Tome
			371306, -- Arcane Bolt
		}

		local brackenhideHollow = {
			382249, -- Earth Bolt
			381694, -- Decayed Senses
			378155, -- Earth Bolt (boss)
			382474, -- Decay Surge
		}

		local hallsOfInfusion = {
			374020, -- Containment Beam
			389443, -- Purifying Blast
			374706, -- Pyretic Burst
			375950, -- Ice Shard
			385963, -- Frost Shock
			395690, -- Lightning Blast
			387504, -- Squall Buffet
			387571, -- Focused Deluge
		}

		local uldaman = {
			369674, -- Stone Spike
			369675, -- Chain Lightning
			372718, -- Earthen Shards
			369399, -- Stone Bolt
			369365, -- Curse of Stone
			377395, -- Time Sink
		}

		local neltharus = {
			378818, -- Magma Conflagration
			372538, -- Melt
			383231, -- Lava Bolt
		}

		local nokhudOffensive = {
			387125, -- Thunderstrike
			387127, -- Chain Lightning
			386012, -- Stormbolt
			387613, -- Death Bolt
			382670, -- Gale Arrow
			376827, -- Conductive Strike
			384761, -- Wind Burst
			396206, -- Storm Shock
			381530, -- Storm Shock
		}

		local algetharAcademy = {
			388862, -- Surge
			377991, -- Storm Slash
			387975, -- Arcane Missiles
		}

		--BFA Dungeons

		local waycrestManor = {
			265372, -- Shadow Cleave
			263943, -- Etch
			264105, -- Runic Mark
			260701, -- Bramble Bolt
			260699, -- Soul Bolt
			260700, -- Ruinous Bolt
			266036, -- Drain Essence
			264024, -- Soul Bolt
			426541, -- Runic Bolt
			264556, -- Tearing Strike
			264153, -- Spit
			278444, -- Infest
			265881, -- Decaying Touch
			265880, -- Dread Mark
			268278, -- Wracking Chord
			261438, -- Wasting Strike
			261440, -- Virulent Pathogen
		}

		local atalDazar = {
			253562, -- Wildfire
			254959, -- Soul Burn
			252923, -- Venom Blast
			252687, -- Venomfang Strike
			250096, -- Wracking Pain
		}

		local underrot = {
			265084, -- Blood Bolt
			260879, -- Blood Bolt (boss)
			278961, -- Decaying Mind
			266265, -- Wicked Embrace
			272180, -- Void Spit
		}

		local freehold = {
			259092, -- Lightning Bolt
			257908, -- Oiled Blade
			281420, -- Water Bolt
		}

		--Legion Dungeons

		local darkheartThicket = {
			204243, -- Tormenting Eye
			200238, -- Feed on the Weak
			200185, -- Nightmare Bolt
			200684, -- Nightmare Toxin
			200642, -- Despair
			201411, -- Firebolt
			201837, -- Shadow Bolt
		}

		local blackRookHold = {
			199663, -- Soul Blast
			200248, -- Arcane Blitz
		}

		local neltharionsLair = {
			186269, -- Stone Bolt
			198496, -- Sunder
			210150, -- Toxic Retch
			200732, -- Molten Crash
		}

		local hallsOfValor = {
			198595, -- Thunderous Bolt
			198962, -- Shattered Rune
			198959, -- Etch
			191976, -- Arcing Bolt
			192288, -- Searing Light
		}

		local courtOfStars = {
			209036, -- Throw Torch
			209413, -- Suppress
			211406, -- Firebolt
			211473, -- Shadow Slash
			373364, -- Vampiric Claws
		}

		--WoD Dungeons

		local everbloom = {
			169657, -- Poisonous Claws
			168040, -- Nature's Wrath
			168092, -- Water Bolt
			169840, -- Frostbolt
			169841, -- Arcane Blast
			169839, -- Pyroblast
			427858, -- Fireball
			164965, -- Choking Vines
		}

		local shadowmoonBurialGrounds = {
			152814, -- Shadow Bolt
			152819, -- Shadow Word: Frailty
			156776, -- Rending Voidlash
			398206, -- Death Blast
			153067, -- Void Devastation
			153524, -- Plague Spit
		}

		--MoP Dungeons

		local templeOfTheJadeSerpent = {
			397888, -- Hydrolance
			114803, -- Throw Torch
			114571, -- Agony
			397914, -- Defiling Mist
			397931, -- Dark Claw
			106823, -- Serpent Strike
		}

		--Cata Dungeons

		local throneOfTheTides = {
			426731, -- Water Bolt
			428542, -- Crushing Depths
			426768, -- Lightning Bolt
			75992, -- Lightning Surge
			428374, -- Focused Tempest
			426783, -- Mind Flay
			429048, -- Flame Shock
			429173, -- Mind Rot
			429176, -- Aquablast
			428526, -- Ink Blast
			428889, -- Foul Bolt
		}

		local vortexPinnacle = {
			410873, -- Rushing Wind
			86331, -- Lightning Bolt
			411019, -- Starlight
			87762, -- Lightning Lash
			87622, -- Chain Lightning
		}

		-- Raids
		local amidrassil = {
			431302, -- Fyr'alath's Flame, Fyrakk
			421284, -- Coiling Flames, Volcoross
		}

		local aberrus = {
			403203, -- Flame Slash, Amalgamation Chamber
			403699, -- Shadow Spike
			397386, -- Lava Bolt, trash
			410351, -- Flaming Cudgel, Assault
		}

		local vault = {
			396040, -- Pyroblast, Eranog
			372394, -- Lightning Bolt, Council
			372315, -- Frost Spike
			372275, -- Chain Lightning
			385812, -- Aerial Slash, Dathea
			375716, -- Ice Barrage, Diurna
			385553, -- Storm Bolt
			375653, -- Static Jolt
		}

		local zones = {
			rubyLifePools,
			azureVault,
			brackenhideHollow,
			uldaman,
			neltharus,
			algetharAcademy,
			nokhudOffensive,
			hallsOfInfusion,
			darkheartThicket,
			everbloom,
			throneOfTheTides,
			waycrestManor,
			atalDazar,
			blackRookHold,
			vortexPinnacle,
			underrot,
			freehold,
			neltharionsLair,
			templeOfTheJadeSerpent,
			courtOfStars,
			shadowmoonBurialGrounds,
			hallsOfValor,
			murozondsRise,
			galakrondsFall,
			amidrassil,
			aberrus,
			vault,
		}

		for i = 1, #zones do
			local zone = zones[i]

			for k = 1, #zone do
				local id = zone[k]
				modTable.reflectableSpells[id] = true
			end
		end
	end
end
