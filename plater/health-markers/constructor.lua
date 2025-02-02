function f(_, _, _, envTable, scriptTable)
	--TWW Dungeons
	local araKara = {
		[214840] = { 30 }, --Engorged Crawler
	}

	local cityOfThreads = {
		[219984] = { 50 }, --Xeph'itik
	}

	local dawnbreaker = {
		[211087] = { 50 }, --Speaker Shadowcrown
		[213937] = { 60 }, --Rasha'nan
	}

	local prioryOfTheSacredFlame = {
		[207940] = { 50 }, --Prioress Murrpray
	}

	local darkflameCleft = {
		[210797] = { 55 }, --The Darkness
	}

	--DF Dungeons

	local dawnOfTheInfinite = {
		[207638] = { 80 }, -- Blight of Galakrond
		[207639] = { 80 }, -- Blight of Galakrond
		[198997] = { 80 }, -- Blight of Galakrond
		[201792] = { 50 }, -- Ahnzon
		[199000] = { 20 }, -- Deios
		[198933] = { 90, 85 }, -- Iridikron
	}

	local rubyLifePools = {
		[190485] = { 50 }, -- Stormvein
		[190484] = { 50 }, -- Kyrakka
		[193435] = { 50 }, -- Kyrakka
		[188252] = { 75, 45 }, -- Melidrussa Chillworn
		[197697] = { 50 }, -- Flamegullet
	}

	local azureVault = {
		[186738] = { 75, 50, 25 }, -- Umbrelskul
	}

	local brackenhideHollow = {
		[186125] = { 15 }, -- Tricktotem
		[186122] = { 15 }, -- Rira Hackclaw
		[186124] = { 15 }, -- Gashtooth
		[185534] = { 15 }, -- Bonebolt Hunter
		[186206] = { 15 }, -- Cruel Bonecrusher
		[185508] = { 15 }, -- Claw Fighter
		[185528] = { 15 }, -- Trickclaw Mystic
		[186121] = { 4 }, -- Decatriarch Wratheye
		[186227] = { 20 }, -- Monstrous Decay
	}

	local neltharus = {
		[194816] = { 10 }, -- Forgewrought Monstrosity
	}

	local hallsOfInfusion = {
		[189719] = { 15 }, -- Watcher Irideus
		[190407] = { 20 }, -- Aqua Rager
		[189729] = { 60 }, -- Primal Tsunami
	}

	local nokhudOffensive = {
		[186151] = { 60 }, --Balakar Khan
	}

	local uldaman = {
		[184020] = { 40 }, -- Hulking Berserker
		[184580] = { 10 }, -- Olaf
		[184581] = { 10 }, -- Baelog
		[184582] = { 10 }, -- Eric "The Swift"
		[184125] = { 1 }, -- Chrono-Lord Deios
	}

	--SL Dungeons

	local theaterOfPain = {
		[164451] = { 40 }, -- Dessia the Decapitator
		[164463] = { 40 }, -- Paceran the Virulent
		[164461] = { 40 }, -- Sathel the Accursed
		[165946] = { 50 }, -- Mordretha
	}

	local mistsOfTirnaScithe = {
		[164929] = { 20 }, -- Tirnenn Villager
		[164501] = { 70, 40, 10 }, -- Mistcaller
		[164926] = { 50 }, --Drust Boughbreaker
		[164804] = { 20 }, -- Droman Oulfarran
		[164517] = { 70, 40 }, --Tred'ova
	}

	local plaguefall = {
		[164267] = { 66, 33 }, -- Magrave Stradama
		[164967] = { 66, 33 }, -- Doctor ickus
		[169861] = { 66, 33 }, -- Ickor Bileflesh
	}

	local hallsOfAtonement = {
		[164218] = { 70, 40 }, --Lord Chamberlain
	}

	local sanguineDepths = {
		[162099] = { 50 }, -- General Kaal Boss fight
	}

	local spiresOfAscension = {
		[162061] = { 70, 30 }, --Devos
	}

	local necroticWake = {
		[163121] = { 70 }, -- Stitched Vanguard
	}

	local deOtherSide = {
		[164558] = { 80, 60, 40, 20 }, -- Hakkar the Soulflayer
	}

	local tazaveshGambit = {
		[177269] = { 40 }, -- So'leah
	}

	local tazaveshStreets = {
		[175806] = { 66, 33 }, -- So'azmi
	}

	--BFA Dungeons

	local freehold = {
		[126983] = { 60, 30 }, -- Harlan Sweete - Freehold
		[126832] = { 75 }, -- Skycap'n Kragg - Freehold
		[129699] = { 90, 70, 50, 30 }, -- Ludwig von Tortollan - Freehold
	}

	local waycrest = {
		[131527] = { 30 }, -- Lord Waycrest
	}

	local siegeOfBoralus = {
		[129208] = { 66, 33 }, -- Dread Captain Lockwood
	}

	local motherlode = {
		[133345] = { 20 }, -- Feckless Assistant
	}

	local junkyard = {
		[150276] = { 50 }, -- Heavy Scrapbot
		[152009] = { 30 }, -- Malfunctioning Scrapbots
		[144298] = { 30 }, -- Defense Bot Mk III (Workshop)
	}

	local workshop = {
		[144298] = { 30 }, -- Defense Bot Mk III (casts a shield)
	}

	--Legion Dungeons

	local karazhanUpper = {
		[114790] = { 66, 33 }, -- Viz'aduum
	}

	local karazhanLower = {
		[114261] = { 50 }, -- Toe Knee
		[114260] = { 50 }, -- Mrrgria
		[114265] = { 50 }, -- Gang Ruffian
		[114783] = { 50 }, -- Reformed Maiden
		[114312] = { 60 }, -- Moroes
	}

	local hallsOfValor = {
		[96574] = { 30 }, -- Stormforged Sentinel
		[95674] = { 60.5 }, -- Fenryr P1
		[94960] = { 10.5 }, -- Hymdall
		[95676] = { 80, 5 }, -- Odyn
	}

	local courtOfStars = {
		[104215] = { 25 }, -- Patrol Captain Gerdo
	}

	local neltharionsLair = {
		[91005] = { 20 }, -- Naraxas
	}

	local blackRookHold = {
		[98542] = { 50 }, -- Amalgam of Souls
		[98965] = { 20 }, -- Kur'talos Ravencrest
	}

	local darkheartThicket = {
		[99192] = { 50 }, -- Shade of Xavius
	}

	--WoD Dungeons

	local grimrailDepot = {
		[81236] = { 50 }, -- Grimrail Technician
		[79545] = { 60 }, -- Nitrogg Thundertower
		[77803] = { 20 }, -- Railmaster Rocketspark
	}

	local ironDocks = {
		[81297] = { 50 }, -- Dreadfang -> Fleshrender Nok'gar
	}

	local shadowmoonBurialGrounds = {
		[76057] = { 20.5 }, -- Carrion Worm
	}

	--MoP Dungeons

	local templeOfTheJadeSerpent = {
		[59544] = { 50 }, --The Nodding Tiger
		[56732] = { 70, 30 }, -- Liu Flameheart
	}

	--Cata Dungeons

	local throneOfTheTides = {
		[40586] = { 60, 30 }, -- Lady Naz'jar
		[40825] = { 25 }, -- Erunak Stonespeaker
	}

	local grimBatol = {
		[224249] = { 50 }, --Twilight Lavabender
		[40320] = { 50 }, --Valiona
	}

	--Raids

	local amirdrassil = {
		[208445] = { 35 }, -- Larodar
		[204931] = { 70 }, -- Fyrakk
	}

	local aberrus = {
		[201261] = { 80, 60, 40 }, -- Kazzara
		[201773] = { 50 }, -- Moltannia (Eternal Blaze)
		[201774] = { 50 }, -- Krozgoth (Essence of Shadow)
		[201668] = { 60, 35 }, -- Neltharion
		[200912] = { 50 }, -- Neldris, Experiment
		[200913] = { 50 }, -- Thadrion, Experiment
		[199659] = { 25 }, -- Warlord Kagni, Assault of the Zaqali
		[201754] = { 65, 40 }, -- Sarkareth
		[203230] = { 50 }, -- Dragonfire Golem, Zskarn
	}

	local vault = {
		[181378] = { 66, 33 }, -- Kurog Grimtotem
		[194990] = { 50 }, -- Stormseeker Acolyte
		[189492] = { 65 }, -- Raszageth
	}

	local sepulcher = {
		[181548] = { 40 }, -- Absolution: Prototype Pantheon
		[181551] = { 40 }, -- Duty: Prototype Pantheon
		[181546] = { 40 }, -- Renewal: Prototype Pantheon
		[181549] = { 40 }, -- War: Prototype Pantheon
		[183501] = { 75, 50 }, --Xymox
		[180906] = { 78, 45 }, --Halondrus
		[183671] = { 40 }, -- Monstrous Soul - Anduin
		[185421] = { 15 }, -- The Jailer
	}

	local sanctumOfDomination = {
		[175730] = { 70, 40 }, -- Fatescribe Roh-Kalo
		[176523] = { 70, 40 }, -- Painsmith
		[175725] = { 66, 33 }, -- Eye of the Jailer
		[176929] = { 60, 20 }, -- Remnant of Kel'Thuzad
		[175732] = { 83, 50 }, -- Sylvanas Windrunner
	}

	local nathria = {
		[166969] = { 50 }, -- Council of Blood - Frieda
		[166970] = { 50 }, -- Council of Blood - Stavros
		[166971] = { 50 }, -- Council of Blood - Niklaus
		[167406] = { 70.5, 37.5 }, -- Sire Denathrius
		[173162] = { 66, 33 }, -- Lord Evershade
	}

	local openWorld = {
		[180013] = { 20 }, -- Escaped Wilderling, Shadowlands - Korthia
		[179931] = { 80, 60 }, -- Relic Breaker krelva, Shadowlands - Korthia
		[193532] = { 40 }, -- Bazual, The Dreaded Flame, Dragonflight
	}

	local mageTower = {
		[116410] = { 33 }, -- Karam Magespear
	}

	envTable.lifePercent = {}

	local zones = {
		araKara,
		darkflameCleft,
		prioryOfTheSacredFlame,
		cityOfThreads,
		dawnbreaker,
		rubyLifePools,
		azureVault,
		brackenhideHollow,
		neltharus,
		hallsOfInfusion,
		nokhudOffensive,
		uldaman,
		theaterOfPain,
		mistsOfTirnaScithe,
		plaguefall,
		hallsOfAtonement,
		sanguineDepths,
		spiresOfAscension,
		necroticWake,
		deOtherSide,
		tazaveshGambit,
		tazaveshStreets,
		freehold,
		waycrest,
		siegeOfBoralus,
		motherlode,
		junkyard,
		workshop,
		karazhanUpper,
		karazhanLower,
		hallsOfValor,
		courtOfStars,
		neltharionsLair,
		blackRookHold,
		darkheartThicket,
		grimrailDepot,
		ironDocks,
		shadowmoonBurialGrounds,
		templeOfTheJadeSerpent,
		throneOfTheTides,
		grimBatol,
		amirdrassil,
		aberrus,
		vault,
		sepulcher,
		sanctumOfDomination,
		nathria,
		openWorld,
		mageTower,
		dawnOfTheInfinite,
	}

	for i = 1, #zones do
		local zone = zones[i]

		for id, thresholds in pairs(zone) do
			envTable.lifePercent[id] = thresholds
		end
	end

	function envTable.CreateMarker(unitFrame)
		unitFrame.healthMarker = unitFrame.healthBar:CreateTexture(nil, "overlay")
		unitFrame.healthMarker:SetColorTexture(1, 1, 1)
		unitFrame.healthMarker:SetSize(1, unitFrame.healthBar:GetHeight())

		unitFrame.healthOverlay = unitFrame.healthBar:CreateTexture(nil, "overlay")
		unitFrame.healthOverlay:SetColorTexture(1, 1, 1)
		unitFrame.healthOverlay:SetSize(1, unitFrame.healthBar:GetHeight())
	end

	function envTable.UpdateMarkers(unitFrame)
		local markersTable = envTable.lifePercent[envTable._NpcID]

		if not markersTable then
			return
		end

		local unitLifePercent = envTable._HealthPercent / 100

		for _, percent in ipairs(markersTable) do
			percent = percent / 100
			if unitLifePercent > percent then
				if not unitFrame.healthMarker then
					envTable.CreateMarker(unitFrame)
				end

				unitFrame.healthMarker:Show()
				local width = unitFrame.healthBar:GetWidth()
				unitFrame.healthMarker:SetPoint("left", unitFrame.healthBar, "left", width * percent, 0)

				local overlaySize = width * (unitLifePercent - percent)
				unitFrame.healthOverlay:SetWidth(overlaySize)
				unitFrame.healthOverlay:SetPoint("left", unitFrame.healthMarker, "right", 0, 0)

				unitFrame.healthMarker:SetVertexColor(Plater:ParseColors(scriptTable.config.indicatorColor))
				unitFrame.healthMarker:SetAlpha(scriptTable.config.indicatorAlpha)

				unitFrame.healthOverlay:SetVertexColor(Plater:ParseColors(scriptTable.config.fillColor))
				unitFrame.healthOverlay:SetAlpha(scriptTable.config.fillAlpha)

				return
			end
		end

		if unitFrame.healthMarker and unitFrame.healthMarker:IsShown() then
			unitFrame.healthMarker:Hide()
			unitFrame.healthOverlay:Hide()
		end
	end
end
