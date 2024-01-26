function (modTable)
    local prioScaleMap = {
        [1] = modTable.config.midScale, -- 0.9
        [2] = modTable.config.lowScale, -- 0.8
        [3] = modTable.config.extraLowScale, -- 0.7,
        [4] = modTable.config.higherScale -- 1.1
    }

    modTable["npcIDs"] = {}

    do
        local test = {}
        -- raids
        local amirdrassil = {
            [210231] = 1, --Tainted Lasher on Gnarlroot
            [211306] = 3 -- Fiery Vines on Tindral
        }
        -- dungeons
        local atalDazar = {
            [128435] = 3 -- saurid
        }
        local waycrestManor = {
            [131669] = 3, -- Jagged Hound
            [139269] = 3, -- Gloom Horror
            [134041] = 2, -- Infected Peasant
            [135052] = 3, -- Blight Toad
            [136541] = 3, -- Bile Oozeling
            [131847] = 2, -- Waycrest Reveler
            [135048] = 2, -- Gorestained Piglet (Drustvar Villager)
        }
        local darkheartThicket = {
            [100529] = 2, -- Hatespawn Slime
            [101074] = 2, -- Hatespawn Whelpling
            [100991] = 2, -- Strangling Roots
            [107288] = 2 -- Vilethorn Sapling
        }
        local everbloom = {
            [81864] = 3, -- Dreadpetal
            [84401] = 2 -- Swift Sproutling
        }
        local blackRookHold = {
            [98677] = 2, -- Rook Spiderling
            [98900] = 1, -- Wyrmtongue Trickster
            [102781] = 3 -- Fel Bat Pup
        }
        local dotiFall = {
            [204536] = 3 -- Blight Chunk
        }
        local throneOfTheTides = {
            [40923] = 3 -- Unstable Corruption
        }
        local templeOfTheJadeSerpent = {
            [62358] = 2, -- Corrupt Droplet
            [200126] = 1, -- Fallen Waterspeaker
            [65317] = 1, -- Xiang
            [59547] = 1, -- Jiang
            [58319] = 2, -- Lesser Sha
            [59598] = 2, -- Lesser Sha
            [59553] = 1, -- The Songbird Queen
            [59545] = 2, -- Golden Beetle
            [59544] = 1, -- The Nodding Tiger
            [59552] = 1, -- The Crybaby Hozen
            [200131] = 1, -- Sha-Touched Guardian
            [57109] = 2, -- Minion of Doubt
            [200388] = 2, -- Malformed Sha
            [200387] = 1 -- Shambling Infester
        }
        local nokhudOffensive = {
            [192803] = 2, -- War Ohuna
            [192794] = 2, -- Nokhud Beastmaster
            [192796] = 1, -- Nokhud Hornsounder
            [192789] = 2, -- Nokhud Longbow
            [192800] = 1, -- Nokhud Lancemaster
            [191847] = 1, -- Nokhud Plainstomper
            [194898] = 2, -- Primalist Arcblade
            [194895] = 2, -- Unstable Squall
            [194896] = 2, -- Primal Stormshield
            [194897] = 2, -- Stormsurge Totem
            [195579] = 2, -- Primal Gust
            [195696] = 1, -- Primalist Thunderbeast
            [195855] = 2, -- Risen Warrior
            [195875] = 2, -- Desecrated Bakar
            [196645] = 2, -- Desecrated Bakar
            [195878] = 1, -- Ukhel Beastcaller
            [195876] = 2, -- Descecrated Ohuna
            [195851] = 1, -- Ukhel Deathspeaker
            [195927] = 1, -- Soulharvester Galtmaa (same)
            [195928] = 1, -- Soulharvester Duuren (same)
            [195929] = 1, -- Soulharvester Tumen (same)
            [195930] = 1, -- Soulharvester Mandakh (same)
            [193553] = 2, -- Nokhud Warhound
            [193555] = 2, -- Nokhud Villager (female)
            [186643] = 2, -- Nokhud Villager (male)
            [193544] = 2, -- Nokhud Houndsman
            [193565] = 1, -- Nokhud Defender
            [193457] = 1, -- Balara
            [196263] = 2, -- Nokhud Neophyte
            [199325] = 2, -- Nokhud Stormcaller
            [196484] = 2, -- Nokhud Stormcaller
            [199294] = 2, -- Nokhud Stormcaster
            [199320] = 2, -- Nokhud Warspear (RP version)
            [199321] = 2 -- Nokhud Warspear (RP version)
        }
        local courtOfStars = {
            [105703] = 2, -- Mana Wyrm,
            [104251] = 1, -- Duskwatch Sentry
            [104246] = 1, -- Duskwatch Guard
            [111563] = 1, -- Duskwatch Guard
            [105705] = 1, -- Bound Energy
            [104295] = 2, -- Blazing Imp
            [104277] = 2, -- Legion Hound
            [104300] = 1 -- Shadow Mistress
        }
        local shadowmoonBurialGrounds = {
            [75715] = 1, -- Reanimated Ritual Bones
            [75451] = 2, -- Defiled Spirit (non-casting)
            [75506] = 1, -- Shadowmoon Loyalist
            [77006] = 2, -- Corpse Skitterling
            [76444] = 2 -- Subjugated Soul
        }
        local algetharAcademy = {
            [196642] = 2, -- Hungry Lasher
            [197398] = 2, -- Hungry Lasher
            [197219] = 1, -- Vile Lasher
            [192329] = 2, -- Territorial Eagle
            [196694] = 2, -- Arcane Forager
            [196671] = 1, -- Arcane Ravager
            [196577] = 2, -- Spellbound Battleaxe
            [197904] = 2, -- Spellbound Battleaxe
            [196798] = 1, -- Corrupted Manafiend
            [196045] = 1, -- Corrupted Manafiend
            [196200] = 2, -- Algeth'ar Echoknight
            [196202] = 1, -- Spectral Invoker
            [196203] = 2 -- Ethereal Restorer
        }
        local azureVault = {
            [191313] = 2, -- Bubbling Sapling
            [196559] = 2, -- Volatile Sapling
            [187155] = 1, -- Rune Seal Keeper
            [187154] = 1, -- Unstable Curator
            [196116] = 1, -- Crystal Fury
            [196117] = 2, -- Crystal Thrasher
            [186740] = 2, -- Arcane Construct
            [189555] = 2, -- Arcane Attendant
            [190510] = 2, -- Vault Guard
            [191739] = 1, -- Scalebane Liutenant
            [187246] = 2, -- Nullmagic Hornswog
            [187242] = 2, -- Tarasek Looter
            [187240] = 1 -- Draconid Breaker
        }
        local hallsOfValor = {
            [97087] = 2, -- Valajar Champion
            [95842] = 1, -- Valajar Thundercaller
            [96574] = 1, -- Stormforged Sentinel
            [95832] = 2, -- Valajar Shieldmaiden
            [101639] = 2, -- Valajar Shieldmaiden
            [101637] = 1, -- Valajar Aspirant
            [97197] = 1, -- Valajar Purifier
            [96640] = 1, -- Valajar Marksman
            [96611] = 2, -- Angehoof Bull
            [99922] = 2, -- Ebonclaw Packmate
            [96608] = 2, -- Ebonclaw Worg
            [97068] = 1 -- Storm Drake
        }
        local rubyLifePools = {
            [188011] = 2, -- Primal Terrasentry
            [188067] = 2, -- Flashfrost Chillweaver
            [188244] = 1, -- Primal Juggernaut
            [189893] = 2, -- Infused Whelp
            [187894] = 2, -- Infused Whelp
            [187897] = 1, -- Defier Draghar
            [194622] = 2, -- Scorchling
            [190205] = 2, -- Scorchling
            [197698] = 1, -- Thunderhead
            [190034] = 1, -- Blazebound Destroyer
            [190207] = 1, -- Primalist Cinderweaver
            [197697] = 1, -- Flamegullet
            [197509] = 2, -- Primal Thundercloud
            [197982] = 2 -- Storm Warrior
        }
        local underrot = {
            [131402] = 2, -- Underrot Tick
            [131436] = 1, -- Chosen Blood Matron
            [133663] = 1, -- Fanatical Headhunter
            [133852] = 2, -- Living Rot
            [130909] = 1, -- Fetid Maggot
            [133836] = 2, -- Reanimated Guardian
            [134284] = 1, -- Fallen Deathspeaker
            [135169] = 2, -- Spirit Drain Totem
            [138281] = 1, -- Faceless Corruptor
            [137458] = 2 -- Rotting Spore
        }
        local freehold = {
            [126928] = 2, -- Irontide Corsair
            [126918] = 1, -- Irontide Crackshot
            [128551] = 2, -- Irontide Mastiff
            [129602] = 1, -- Irontide Enforcer
            [127119] = 2, -- Freehold Deckhand
            [130521] = 2, -- Freehold Deckhand
            [129550] = 2, -- Bilge Rat Padfoot
            [129526] = 2, -- Bilge Rat Swabby
            [129548] = 2, -- Blacktooth Brute
            [130522] = 2, -- Freehold Shipmate
            [127124] = 2, -- Freehold Barhand
            [129559] = 2, -- Cutwater Duelist
            [130404] = 1, -- Vermin Trapper
            [126497] = 2, -- Shiprat
            [130024] = 2, -- Soggy Shiprat
            [129527] = 1, -- Bilge Rat Buccaneer
            [130011] = 2, -- Irontide Buccaneer
            [129599] = 2, -- Cutwater Knife Juggler
            [129547] = 2, -- Blacktooth Knuckleduster
            [129529] = 2, -- Blacktooth Scrapper
            [129601] = 2, -- Cutwater Harpooner
            [130400] = 1, -- Irontide Crusher
            [127019] = 2, -- Target Dummy
            [130012] = 2, -- Irontide Ravager
            [127111] = 1, -- Irontide Oarsman
            [127106] = 2 -- Irontide Officer
        }
        local neltharionsLair = {
            [96247] = 3, -- Vileshard Crawler
            [98406] = 1, -- Embershard Scorpion
            [91001] = 1, -- Tarspitter Lurker
            [101438] = 1, -- Vileshard Chunk
            [105636] = 2, -- Understone Drudge
            [105720] = 2, -- Understone Drudge
            [92350] = 2, -- Understone Drudge
            [92610] = 2, -- Understone Drummer
            [92387] = 2, -- Drums of War
            [91332] = 1, -- Stoneclaw Hunter
            [90997] = 1, -- Mightstone Breaker
            [113998] = 1, -- Mightstone Breaker
            [94224] = 2, -- Petrifying Totem
            [90998] = 1, -- Blightshard Shaper
            [101437] = 2, -- Burning Geode
            [102430] = 2, -- Tarspitter SLug
            [102253] = 2 -- Understone Demolisher
        }
        local vortexPinnacle = {
            [205326] = 2, -- Gust Soldier
            [45477] = 2, -- Gust Soldier
            [45915] = 1, -- Armored Mistral
            [45704] = 2, -- Lurking Tempest
            [204337] = 2, -- Lurking Tempest
            [45917] = 1, -- Cloud Prince
            [45924] = 1, -- Turbulent Squall
            [45922] = 2, -- Empyrean Assassin
            [45926] = 2, -- Servant of Asaad
            [45928] = 1, -- Executor of the Caliph
            [45932] = 2, -- Skyfall Star
            [45930] = 1 -- Minister of Air
        }
        local hallsOfInfusion = {
            [190345] = 2, -- Primalist Geomancer
            [190348] = 2, -- Primalist Ravager
            [190342] = 1, -- Containment Apperatus
            [196712] = 1, -- Nullification Device
            [190366] = 2, -- Curious Swoglet
            [195399] = 2, -- Curious Swoglet
            [199037] = 1, -- Primalist Shocktrooper
            [190370] = 1, -- Squallbringer Cyraz
            [190923] = 2, -- Zephyrling
            [190373] = 1, -- Primalist Galesinger
            [190371] = 1, -- Primalist Earthshaker
            [190407] = 2, -- Aqua Rager
            [190359] = 2, -- Skulking Zealot
            [190406] = 2 -- Aqualing
        }
        local neltharus = {
            [192787] = 2, --Qalashi Spinecrusher
            [193293] = 2, --Qalashi Warden
            [192781] = 2, --Ore Elemental
            [192786] = 2, --Qalashi Plunderer
            [189227] = 1, --Qalashi Hunter
            [189247] = 2, --Tamed Phoenix
            [189266] = 2, --Qalashi Trainee
            [189472] = 2, --Qalashi Lavabearer
            [189471] = 1, --Qalashi Blacksmith
            [193291] = 1, --Apex Blazewing
            [194389] = 2 --Lava Spawn
        }
        local uldaman = {
            [184134] = 2, -- Scavenging Leaper
            [184020] = 2, -- Hulking Berserker
            [184019] = 2, -- Burly Rock-Thrower
            [186664] = 2, -- Stonevault Ambusher
            [186696] = 4, -- Quaking Totem
            [184130] = 2, -- Earthen Custodian
            [184319] = 1, -- Refti Custodian
            [184107] = 1, -- Runic Protector
            [184303] = 2, -- Skittering Crawler
            [184300] = 1, -- Ebonstone Golem
            [184131] = 1, -- Earthen Guardian
            [184331] = 1, -- Infinite Timereaver
            [191311] = 2 -- Infinite Whelp
        }
        local brackenhideHollow = {
            [185529] = 1, -- Bracken Warscourge
            [185508] = 2, -- Claw Fighter
            [186206] = 2, -- Cruel Bonecrusher
            [186191] = 1, -- Decay Speaker
            [185534] = 1, -- Bonebolt Hunter
            [185691] = 2, -- Vicious Hyena
            [186122] = 2, -- Rira Hackclaw
            [186124] = 1, -- Gashtooth
            [186208] = 1, -- Rotbow Stalker
            [186284] = 2, -- Gutchewer Bear
            [194745] = 2, -- Rotfang Hyena
            [186227] = 2, -- Monstrous Decay
            [189299] = 2, -- Decaying Slime
            [192481] = 2, -- Decaying Slime
            [194273] = 2, -- Witherling
            [187238] = 2, -- Witherling
            [187231] = 2, -- Wither Biter
            [187315] = 2, -- Disease Slasher
            [191243] = 2, -- Wild Lasher
            [189363] = 2, -- Infected Lasher
            [189531] = 1, -- Decayed Elder
            [186226] = 1, -- Fetid Rotsinger
            [186229] = 1, -- Wilted Oak
            [194373] = 2, -- Witherling
            [199916] = 2, -- Decaying Slime
            [190381] = 4 -- Rotburst Totem
        }
        local dotiRise = {
            [205151] = 3 -- Tyr's Vanguard
        }
        local misc = {
            -- Fodder to the Flame demons
            [169428] = 2,
            [169430] = 2,
            [169429] = 2,
            [169426] = 2,
            [169421] = 2,
            [169425] = 2,
            [168932] = 2
        }

        local maps = {
            test,
            amirdrassil,
            atalDazar,
            waycrestManor,
            darkheartThicket,
            everbloom,
            blackRookHold,
            dotiFall,
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
            dotiRise,
            misc
        }

        for _, map in pairs(maps) do
            for id, priority in pairs(map) do
                modTable["npcIDs"][id] = priority
            end
        end
    end

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
