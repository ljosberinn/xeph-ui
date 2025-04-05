function f(modTable)
	modTable.reflectableSpells = {}

	local playerClass = select(3, UnitClass("player"))

	-- Checks to see if a spell is on cooldown, not counting the 1.5s cooldown from global cooldown.
	---@param spellID number
	---@return boolean
	local function IsSpellOnCooldown_IgnoreGCD(spellID)
		local gcdInfo = C_Spell.GetSpellCooldown(61304)
		local GCD_expirationTime = gcdInfo.startTime + gcdInfo.duration
		local spellInfo = C_Spell.GetSpellCooldown(spellID)
		local spellReadyTime = spellInfo.startTime + spellInfo.duration
		return spellReadyTime > GCD_expirationTime
	end

	-- Create a tick if it doesn't already exist. The tick will be used to show when interrupt will be available.
	local function MaybeCreateTickTexture(castBar)
		if not castBar.tick then
			castBar.tick = castBar:CreateTexture(nil, "overlay")
			castBar.tick:SetDrawLayer("overlay", 4)
			castBar.tick:SetBlendMode("DISABLE")
			--castBar.tick:SetHeight(castBar:GetHeight())
			castBar.tick:SetHeight(8)
			castBar.tick:SetTexture(Plater.SparkTextures[8])
			castBar.tick:SetWidth(2)
			castBar.tick:SetVertexColor(Plater:ParseColors(modTable.config.colorTick))
		end
	end

	---@param unitId string
	---@return boolean
	local function UnitIsStillCasting(unitId)
		if UnitCastingInfo(unitId) ~= nil then
			return true
		end

		if UnitChannelInfo(unitId) ~= nil then
			return true
		end

		return false
	end

	local function DetermineInterruptId()
		if playerClass == 1 then -- Warrior
			return function()
				return 6552 -- Pummel
			end
		end

		if playerClass == 2 then -- Paladin
			return function()
				return 96231 -- Rebuke
			end
		end

		if playerClass == 3 then -- Hunter
			return function()
				local spec = GetSpecialization()

				if spec == 3 then -- survival
					return 187707 -- muzzle
				end

				return 147362 -- counter shot
			end
		end

		if playerClass == 4 then -- rogue
			return function()
				return 1766 -- kick
			end
		end

		if playerClass == 5 then -- priest
			return function()
				local spec = GetSpecialization()

				if spec == 3 then -- shadow
					return 15487 -- silence
				end

				return nil
			end
		end

		if playerClass == 6 then -- death knight
			return function()
				return 47528 -- mind freeze
			end
		end

		if playerClass == 7 then -- shaman
			return function()
				return 57994
			end
		end

		if playerClass == 8 then -- mage
			return function()
				return 2139 -- counterspell
			end
		end

		if playerClass == 9 then -- warlock
			return function()
				if IsSpellKnown(89766, true) then -- felguard: axe toss
					return 89766
				end

				if IsSpellKnown(19647, true) then -- felhunter: spell lock
					return 19647
				end

				if C_UnitAuras.GetPlayerAuraBySpellID(196099) ~= nil and IsSpellKnown(132409, true) then -- spell lock via grimoire of sacrifice
					return 132409
				end

				return nil
			end
		end

		if playerClass == 10 then -- monk
			return function()
				return 116705 -- spear hand strike
			end
		end

		if playerClass == 11 then -- druid
			return function()
				local spec = GetSpecialization()

				if spec == 1 then -- balance
					return 78675 -- solar beam
				end

				return 106839 -- skull bash
			end
		end

		if playerClass == 12 then -- demon hunter
			return function()
				return 183752 -- disrupt
			end
		end

		if playerClass == 13 then -- evoker
			return function()
				return 351338 -- quell
			end
		end
	end

	local GetInterruptID = DetermineInterruptId()
	local playerIsWarlock = playerClass == 9

	---@param unitId string
	---@param unitFrame Frame
	function modTable.EnhancedCastBar(unitId, unitFrame)
		local castBar = unitFrame.castBar

		if castBar.tick ~= nil then
			castBar.tick:Hide()
		end

		if castBar.IsInterrupted or castBar.interrupted or not UnitIsStillCasting(unitId) then
			return
		end

		local targetUnitId = unitId .. "target"

		if not UnitExists(targetUnitId) then
			return
		end

		local targetName = UnitName(targetUnitId)
		local isTargettingMe = targetName == UnitName("player")
		castBar.Text:SetText(castBar.SpellName)

		-- Cast is targetting a specific unit
		if targetName then
			-- Nameplate flash options
			if isTargettingMe and modTable.config.nameplateFlash then
				-- Default value of true since it is turned on in the options
				local showNameplateFlash = true

				if
					modTable.config.hideNameplateFlashSolo
					and not UnitInParty("player")
					and not UnitInRaid("player")
				then
					showNameplateFlash = false
				end

				if modTable.config.hideFlashAsTank and GetSpecializationRole(GetSpecialization()) == "TANK" then
					showNameplateFlash = false
				end

				-- Show nameplate flash if conditions met
				if showNameplateFlash then
					Plater.FlashNameplateBody(unitFrame)
				end
			end

			-- Target name in cast bar options
			if modTable.config.showTargetName then
				if modTable.config.replaceName and isTargettingMe then
					targetName = "Me"
				end

				local castBarWidth = castBar:GetWidth()
				-- clip cast name at 50% of cast bar width always
				DetailsFramework:TruncateText(castBar.Text, castBarWidth * 0.5)

				-- first, truncate the spell name to make space for the target name
				local currentText = castBar.Text:GetText()
				if currentText ~= nil and currentText ~= "" then
					local castText = currentText .. " " .. Plater.SetTextColorByClass(targetUnitId, targetName)

					if
						modTable.config.hideNameSolo
						and not UnitInParty("player")
						and not UnitInRaid("player")
						and isTargettingMe
					then
						castText = currentText
					end

					castBar.Text:SetText(castText)
					-- now truncate again to ensure the target name doesn't overlap with the cast duration
					DetailsFramework:TruncateText(castBar.Text, castBarWidth * 0.9)
				end
			end
		end

		if not modTable.config.showInterruptColor then
			return
		end

		local interruptID = GetInterruptID()
		local nextColor = modTable.config.colorProtected

		if interruptID == nil then
			nextColor = modTable.config.colorNoInterrupt
		else
			-- Interrupt bar color options
			local canInterrupt = castBar.canInterrupt
			local castEndTime = castBar.spellEndTime

			local interruptInfo = C_Spell.GetSpellCooldown(interruptID)
			local interruptReadyTime = interruptInfo.startTime + interruptInfo.duration

			if canInterrupt then
				-- Check to see if the spell is known/talented
				if IsSpellKnown(interruptID, playerIsWarlock) then
					if interruptReadyTime == 0 then
						nextColor = modTable.config.colorInterruptAvailable
					elseif
						modTable.config.showSecondaryInterrupts
						and playerClass == 2 -- paladin
						and IsSpellKnown(31935) -- avenger's shield
						and not IsSpellOnCooldown_IgnoreGCD(31935)
					then
						nextColor = modTable.config.colorSecondaryInterrupt
					elseif interruptReadyTime < (castEndTime - 0.25) then
						MaybeCreateTickTexture(castBar)
						castBar.tick:Show()
						local tickLocation = (interruptInfo.startTime + interruptInfo.duration - castBar.spellStartTime)
							/ castBar.maxValue -- castBar.spellStartTime + 0.25
						if castBar.channeling then
							tickLocation = 1 - tickLocation
						end
						castBar.tick:SetPoint("center", castBar, "left", tickLocation * castBar:GetWidth(), 0)

						nextColor = modTable.config.colorInterruptSoon
					elseif interruptReadyTime >= (castEndTime - 0.25) then
						nextColor = modTable.config.colorNoInterrupt
					end
				else
					nextColor = modTable.config.colorNoInterrupt
				end
			end

			-- Spell Reflection coloring
			if
				modTable.config.showSecondaryInterrupts
				and isTargettingMe
				and playerClass == 1
				and IsSpellKnown(23920) -- spell reflect
				and not IsSpellOnCooldown_IgnoreGCD(23920)
				and modTable.reflectableSpells[castBar.SpellID] == true
			then
				-- Color the bar if the spell is reflectable
				nextColor = modTable.config.colorSecondaryInterrupt
			end
		end

		local currentR, currentG, currentB, currentA = castBar:GetColor()
		local nextR, nextG, nextB, nextA = unpack(nextColor)

		if currentR ~= nextR or currentG ~= nextG or currentB ~= nextB or currentA ~= nextA then
			Plater.SetCastBarColor(unitFrame, nextColor)
		end
	end

	if playerClass == 1 then
		--TWW Dungeons
		local araKara = {
			436322, -- Poison bolt - atik
			434786, -- Web bolt
		}

		local cityOfThreads = {
			442536, -- Grimweave Blast
			443427, -- Web Bolt
			439341, -- Splice - Izo
			446717, -- Umbral Weave
			438860, -- Umbral Weave - Izo
		}

		local theDawnbreaker = {
			428086, -- Shadow bolt
			451114, -- Congealed Shadow
			432448, -- Stygian Seed
			431495, -- Black Edge
			451113, -- Web Bolt
			431303, -- Night Bolt
			431494, -- Black Edge
		}

		local theStonevault = {
			429422, -- Stone Bolt
			426283, -- Arcing Void
			429110, --Alloy Bolt
			429545, -- Censoring Gear
			459210, -- Shadow Claw
			430097, -- Molten Metal - Speaker Brokk
		}

		local cinderbrewMeadery = {}

		local darkflameCleft = {}

		local prioryOfTheSacredFlame = {}

		local theRookery = {}

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

		--Shadowlands Dungeons

		local mistsOfTirnaScithe = {
			332767, --Spirit Bolt
			323057, --Spirit Bolt - Boss
			332557, --Soul Split
			463217, --Anima Slash
			325223, --Anima Injection
			332486, --Overgrowth
		}

		local theNecroticWake = {
			328667, --Frostbolt Volley
			333623, --Frostbolt Volley
			326574, --Noxious Fog
			320788, --Frozen Binds
			322274, --Enfeeble
			334748, --Drain Fluids
			320462, --Necrotic Bolt
			333479, --Spew Disease
			323347, --Clinging Darkness
			333602, --Frostbolt
		}

		--BFA Dungeons

		local siegeOfBoralus = {
			272581, -- Water bolt
			257063, -- Brackish bolt
		}

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

		local grimBatol = {
			447966, --Shadowflame bolt (Boss)
			76369, --Shadowflame bolt (adds)
			450087, --Depth's Grasp
			451971, --Lava Fist
			451241, --Shadowflame Slash
		}

		-- Raids
		local nerubarPalace = {
			438807, --Vicious Bite - Broodtwister
			441362, --Volatile Concoction - Broodtwister
			441772, --Void Bolt - Silken Court
			438200, --Poison Bolt - Silken Court
		}

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
			nerubarPalace,
			araKara,
			cityOfThreads,
			grimBatol,
			mistsOfTirnaScithe,
			siegeOfBoralus,
			theDawnbreaker,
			theNecroticWake,
			theStonevault,
			cinderbrewMeadery,
			darkflameCleft,
			prioryOfTheSacredFlame,
			theRookery,
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
