function (self, unitId, unitFrame, envTable)
    -- used for nameColouring
    -- AARRGGBB
    local markerToHex = {
        [1] = "FFFFFFFF", -- Yellow 5 Point Star
        [2] = "FFFFFFFF", -- Orange Circle
        [3] = "FFFFFFFF", -- Purple Diamond
        [4] = "FFFFFFFF", -- Green Triangle
        [5] = "FFFFFFFF", -- Light Blue Moon
        [6] = "FFFFFFFF", -- Blue Square
        [7] = "FFFFFFFF", -- Red Cross
        [8] = "FFFFFFFF" -- White Skull
    }

    -- Makes it so you take their first name e.g Jessie Howlis -> Jessie
    -- Old way was some degen fucking shit this is easier
    local nameBlacklist = {
        ["the"] = true,
        ["of"] = true,
        ["Tentacle"] = true,
        ["Apprentice"] = true,
        ["Denizen"] = true,
        ["Emissary"] = true,
        ["Howlis"] = true,
        ["Terror"] = true,
        ["Totem"] = true,
        ["Waycrest"] = true,
        --["Dummy"] = true, -- Testing Purposes
        ["Aspect"] = true
    }

    -- Override for names, Thanks to Nnoggie for all of the dungeon ones
    local renameTable = {
        -- Testing

        --Dragonflight Raids
        --Aberrus, The Shadowed Crucible
        ["Kazzara, the Hellforged"] = "Kazzara",
        ["Rashok, the Elder"] = "Rashok",
        --Vault of the Incarnates
        ["Dathea, Ascended"] = "Dathea",
        ["Nascent Proto-Dragon"] = "Nascent Dragon",
        ["Juvenile Frost Proto-Dragon"] = "Frost Dragon",
        --Dragonflight Dungeons
        --Dawn of the Infinite
        ["Tyr, the Infinite Keeper"] = "Tyr",
        --Ruby Life Pools
        ["Tempest Channeler"] = "Tempest",
        ["Flame Channeler"] = "Flame",
        --Algeth'ar Academy
        ["Alpha Eagle"] = "Alpha",
        ["Vile Lasher"] = "Big Lasher",
        --The Azure Vault
        ["Hardened Crystal"] = "Hardened",
        ["Crystal Fury"] = "Crystal",
        --Brackenhide Hollow
        ["Rotburst Totem"] = "Rotburst",
        ["Decay Totem"] = "Decay Totem",
        --Halls of Infusion
        --Neltharus
        ["Chargath, Bane of Scales"] = "Chargath",
        --The Nokhud Offensive
        ["Stormsurge Totem"] = "Storm Totem",
        ["Stormcaller Solongo"] = "Stormcaller",
        ["Stormcaller Zarii"] = "Stormcaller",
        ["Soulharvester Tumen"] = "Soulharvester",
        ["Soulharvester Mandakh"] = "Soulharvester",
        --Uldaman: Legacy of Tyr
        ["Refti Custodian"] = "Refti",
        ["Earthen Custodian"] = "Earthen",
        ['Eric "The Swift"'] = "Eric",
        --Shadowlands

        --Open World
        ["Fallen Knowledge-Seeker"] = "Seeker",
        --Shadowlands Raids

        --Castle Nathria
        ["Stoneborn Maitre D'"] = "Maitre D'",
        ["Rat of Unusual Size"] = "Big Rat",
        --Sanctum of Domination
        ["Sylvanas Windrunner"] = "Sylvanas",
        --Sepulcher of the First Ones
        ["Anduin Wrynn"] = "Anduin",
        ["The Jailer"] = "Jailer",
        ["Prototype of War"] = "War",
        ["Prototype of Duty"] = "Duty",
        ["Prototype of Renewal"] = "Renewal",
        ["Prototype of Absolution"] = "Absolution",
        --Shadowlands Dungeons

        --De other Side
        ["Millhouse Manastorm"] = "Millhouse",
        ["Millificent Manastorm"] = "Millificent",
        --Mists of Tirna Scithe
        ["Droman Oulfarran"] = "Droman",
        --Necrotic Wake
        ["Stitching Assistant"] = "Stitching",
        ["Separation Assistant"] = "Separator",
        ["Blightbone"] = "Blightbone",
        --Theater of pain
        ["Mordretha, the Endless Empress"] = "Mordretha",
        --Plaguefall
        ["Congealed Slime"] = "Purple Slime",
        ["Pestilence Slime"] = "Haste Slime",
        ["Gushing Slime"] = "Green Slime",
        ["Rotmarrow Slime"] = "Bad Slime",
        --Tazavesh: Streets of Wonder

        --Tazavesh: So'leah's Gambit
        ["Invigorating Fish Stick"] = "Fish Stick",
        -- BFA Dungeons
        --Freehold
        --Underrot
        --Operation: Mechagon
        ["Rocket Tonk"] = "Rocket",
        ["Strider Tonk"] = "Strider",
        ["Bomb Tonk"] = "Bomb",
        ["Defense Bot Mk I"] = "MK-I",
        ["Defense Bot Mk III"] = "MK-III",
        --Legion Dungeons
        --Return To Karazhan
        ["Spectral Apprentice"] = "Apprentice",
        ["Shrieking Terror"] = "Terror",
        --Halls of Valor
        --Court of Stars

        --MoP Dungeons
        --Temple of the Jade Serpent
        ["Haunting Sha"] = "Haunting",
        --Seasonal Affixes
        --Incorporeal
        ["Incorporeal Being"] = "Incorporeal",
        --M+ Encrypted Affix
        ["Urh Relic"] = "CDR",
        ["Wo Relic"] = "Speed",
        ["Vy Relic"] = "Haste",
        ["Urh Dismantler"] = "Urh",
        ["Wo Drifter"] = "Wo",
        ["Vy Interceptor"] = "Vy"
    }

    -- @unitId  unitID for mob e.g nameplate1
    -- @marker Raid Target ID
    -- @nameColouring Enables text to be coloured by raid marker
    -- @isBoss Boolean for enabling this on boss mobs, Do i want this?? no idea
    -- @debugMode Test mode for using dummy's
    -- @debugEntry Which hook it came from
    function envTable.namer(unitId, marker, nameColouring)
        if unitId then
            local name = UnitName(unitId)
            local a, b, c, d, e, f = strsplit(" ", name, 5)
            local unitName

            if nameBlacklist[b] then
                unitName = name ~= nil and (a or b or c or d or e or f) or nil
            else
                unitName = name ~= nil and (f or e or d or c or b or a) or nil
            end

            if unitName == nil then
                unitName = name
            end

            if renameTable[name] then
                unitName = renameTable[name]
            end

            if unitId and marker and nameColouring then
                unitFrame.healthBar.unitName:SetText(WrapTextInColorCode(unitName, markerToHex[marker]))
            elseif unitId then
                unitFrame.healthBar.unitName:SetText(unitName)
            end
        end
    end
end
