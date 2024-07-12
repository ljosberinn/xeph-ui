function f(self, unitId, unitFrame, envTable, scriptTable)
	--insert code here

	envTable.lifePercent = {
		--npcId = (percent divisions), --NPC Name
		--[0000] = {80, 30},   --debug

		--                                                                             ***DG's***

		--TWW Dungeons

		--City of threads
		[219984] = { 50 }, --Xeph'itik

		--Dawnbreaker
		[211087] = { 50 }, --Speaker Shadowcrown

		-- **DF Dungeons
		---Algeth'ar Academy

		--Brackenhide Hollow
		[186125] = { 15 }, --Tricktotem
		[186122] = { 15 }, --Rira Hackclaw
		[186124] = { 15 }, --Gashtooth
		[186121] = { 4 }, -- Decatriarch Wratheye
		[185534] = { 15 }, --Bonebolt Hunter
		[185508] = { 15 }, --Claw Fighter
		[186206] = { 15 }, --Cruel Bonecrusher
		[185528] = { 15 }, --Trickclaw Mystic

		--Halls of Infusion
		[190407] = { 20 }, --Aqua Rager
		[189719] = { 15 }, --Watcher Irideus
		[189729] = { 60 }, -- Primal Tsunami

		--Neltharus
		[194816] = { 10 }, -- Forgewrought Monstrosity

		--Ruby Life pools
		[190485] = { 50 }, --Stormvein
		[190484] = { 50 }, --Kyrakka
		[193435] = { 50 }, --Kyrakka
		[188252] = { 75, 45 }, --Melidrussa Chillworn
		[197697] = { 50 }, -- Flamegullet

		--The Azure Vault
		[186738] = { 75, 50, 25 }, --Umbrelskul

		-- The Nokhud Offensive
		[186151] = { 60 }, --Balakar Khan

		-- Uldaman: Legacy of Tyr
		[184020] = { 40 }, -- Hulking Berserker
		[184580] = { 10 }, -- Olaf
		[184581] = { 10 }, -- Baelog
		[184582] = { 10 }, -- Eric "The Swift"
		[184422] = { 70, 30 }, --Emberon

		-- Dawn of the Infinite
		[207638] = { 80 }, -- Blight of Galakrond
		[207639] = { 80 }, -- Blight of Galakrond
		[198997] = { 80 }, -- Blight of Galakrond
		[201792] = { 50 }, -- Ahnzon
		[199000] = { 20 }, -- Deios
		[198933] = { 90, 85 }, -- Iridikron

		-- **SL Dungeons
		-- De Other Side
		[164558] = { 80, 60, 40, 20 }, --Hakkar the Soulflayer

		--Halls of Atonement
		[164218] = { 70, 40 }, --Lord Chamberlain

		--Mists of Tirna Scithe
		[164501] = { 70, 40, 10 }, --Mistcaller
		[164926] = { 50 }, --Drust Boughbreaker
		[164929] = { 20 }, --Villager
		[164804] = { 22 }, -- Droman Oulfarran

		--Plaguefall
		[164267] = { 66, 33 }, --Magrave Stradama
		[164967] = { 66, 33 }, --Doctor ickus
		[169861] = { 66, 33 }, -- Ickor Bileflesh

		--Sanguine Depths
		[162099] = { 50 }, --General Kaal Boss fight

		--Spires of Ascension
		[162061] = { 70, 30 }, --Devos

		--Tazavesh
		[177269] = { 40 }, --So'leah (Gambit)
		[175806] = { 66, 33 }, --So'azmi (Streets)

		--The Necrotic Wake
		[163121] = { 70 }, -- Stitched vanguard

		--Theater of Pain
		[164451] = { 40 }, --Dessia the Decapirator
		[164463] = { 40 }, --Paceran the Virulent
		[164461] = { 40 }, --Sathel the Accursed
		[165946] = { 50 }, --Mordretha

		-- **BFA Dungeons

		-- Siege of Boredom
		[129208] = { 66, 33 }, --Dread Captain Lockwood

		--Freehold
		[126983] = { 60 }, -- Harlan Sweete
		[129732] = { 75 }, --Skycap'n Kragg
		[126832] = { 75 }, --Skycap'n Kragg
		[129699] = { 90, 70, 50, 30 }, -- Ludwig von Tortollan

		-- Operation: Mechagon
		[150276] = { 50 }, --Heavy Scrapbots (Junk)
		[152009] = { 30 }, --Malfunctioning Scrapbots (Junk)
		[144298] = { 30 }, --Defense Bot Mk III (Workshop)

		--The MOTHERLODE!!
		[133345] = { 20 }, --Feckless Assistant

		--The Underrot
		[133007] = { 85, 68, 51, 34, 17 }, --Unbound Abomination

		--Waycrest Manor
		[131527] = { 30 }, --Lord Waycrest

		-- **WoD Dungeons
		--Grimrail Depot
		[81236] = { 50 }, -- Grimrail Technician
		[79545] = { 60 }, -- Nitrogg Thundertower
		[77803] = { 20 }, -- Railmaster Rocketspark

		--Iron Docks
		[81297] = { 50 }, -- Dreadfang -> Fleshrender Nok'gar

		--Shadowmoon Burial Grounds
		[76057] = { 20 }, -- Carrion Worm

		--**Legion Dungeons
		--Court of Stars
		[104215] = { 25 }, -- Patrol Captain Gerdo

		-- Return to Karazhan (Lower)
		[114261] = { 50 }, --Toe Knee
		[114260] = { 50 }, -- Mrrgria
		[114265] = { 50 }, --Gang Ruffian
		[114783] = { 50 }, --Reformed Maiden
		[114312] = { 60 }, -- Moroes

		-- Return to Karazhan (Upper)
		[114790] = { 66, 33 }, -- Viz'aduum

		--Halls of Valor
		[96574] = { 30 }, --Stormforged Sentinel
		[97087] = { 30 }, --Valarjar Champion
		[95674] = { 60 }, -- Fenryr P1
		[94960] = { 10 }, -- Hymdall
		[95676] = { 80 }, --Odyn

		--Neltharion's Lair
		[91005] = { 20 }, -- Naraxas
		[113537] = { 15 }, -- Emberhusk Dominator

		--Blackrook Hold
		[98542] = { 50 }, -- Amalgam of Souls
		[98965] = { 20 }, -- Kur'talos Ravencrest

		--Darkheart Thicket
		[99192] = { 50 }, -- Shade of Xavius

		-- **Pandaria Dungeons
		-- Temple of The Jade Serpent
		[59544] = { 50 }, --The Nodding Tiger
		[56732] = { 70, 30 }, -- Liu Flameheart

		--CATA Dungeons
		-- Throne of the Tides
		[40586] = { 60, 30 }, -- Lady Naz'jar
		[40825] = { 25 }, -- Erunak Stonespeaker

		--Grim Batol
		[224249] = { 50 }, --Twilight Lavabender

		--                                                                             ***RAID***
		-- DF Raid

		--Amirdrassil
		[208445] = { 35 }, -- Larodar
		[204931] = { 70 }, -- Fyrakk

		--Vault of the Incarnates
		[194990] = { 50 }, -- Stormseeker Acolyte: Raszageth
		[189492] = { 65 }, -- Raszageth

		--Aberrus, the Shadowed Crucible
		[201261] = { 80, 60, 40 }, -- Kazzara
		[201773] = { 50 }, -- Eternal Blaze
		[201774] = { 50 }, -- Essence of Shadow
		[199659] = { 25 }, -- Warlord Kagni
		[201668] = { 60, 35 }, -- Neltharion
		[200913] = { 50 }, --Thadrion
		[200912] = { 50 }, --Neldris
		[203230] = { 50 }, --Dragonfire Golem

		--SL Raid
		[181548] = { 40 }, --Absolution: Prototype Pantheon, Sepulcher of the First Ones
		[181551] = { 40 }, --Duty: Prototype Pantheon, Sepulcher of the First Ones
		[181546] = { 40 }, --Renewal: Prototype Pantheon, Sepulcher of the First Ones
		[181549] = { 40 }, --War: Prototype Pantheon, Sepulcher of the First Ones
		[183501] = { 75, 50 }, --Xymox, Sepulcher of the First Ones
		[180906] = { 78, 45 }, --Halondrus, Sepulcher of the First Ones
		[183671] = { 40 }, --Monstrous Soul - Anduin, Sepulcher of the First Ones
		[185421] = { 15 }, --The Jailer, Sepulcher of the First Ones

		[175730] = { 70, 40 }, --Fatescribe Roh-Kalo, Sanctum of domination
		[176523] = { 70, 40 }, --Painsmith, Sanctum of domination
		[175725] = { 66, 33 }, --Eye of the Jailer, Sanctum of domination
		[176929] = { 60, 20 }, --Remnant of Kel'Thuzad, Sanctum of domination
		[175732] = { 83, 50 }, -- Sylvanas Windrunner, Sanctum of Domination

		[166969] = { 50 }, --Council of Blood - Frieda, Castle Nathria
		[166970] = { 50 }, --Council of Blood - Stavros, Castle Nathria
		[166971] = { 50 }, --Council of Blood - Niklaus, Castle Nathria
		[167406] = { 70.5, 37.5 }, --Sire Denathrius, Castle Nathria
		[173162] = { 66, 33 }, --Lord Evershade, Castle Nathria

		--                                                                             ***OPEN WORD***
		-- Kortia (SL)
		[180013] = { 20 }, --Escaped Wilderling, Shadowlands - Korthia
		[179931] = { 80, 60 }, --Relic Breaker krelva, Shadowlands - Korthia

		--Dragon Isles (DF)
		[193532] = { 40 }, --Bazual, The Dreaded Flame - WordBoss

		--Mage Tower
		[116410] = { 33 }, -- Karam Magespear
	}

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
		if markersTable then
			local unitLifePercent = envTable._HealthPercent / 100
			for i, percent in ipairs(markersTable) do
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
			end --end for

			if unitFrame.healthMarker and unitFrame.healthMarker:IsShown() then
				unitFrame.healthMarker:Hide()
				unitFrame.healthOverlay:Hide()
			end
		end
	end
end
