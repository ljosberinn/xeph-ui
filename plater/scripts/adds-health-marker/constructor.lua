function (self, unitId, unitFrame, envTable, scriptTable)
    envTable.lifePercent = {        
        -- DF Dungeons
        -- Ruby Life Pools
        [190485] = {50}, --Stormvein
        [190484] = {50}, --Kyrakka
        [193435] = {50}, --Kyrakka
        [188252] = {75, 45}, --Melidrussa Chillworn
        [197697] = {50}, -- Flamegullet
        -- The Azure Vault
        [186738] = {75, 50, 25}, --Umbrelskul
        -- Brackenhide Hollow
        [186125] = {30}, --Tricktotem
        [186122] = {30}, --Rira Hackclaw
        [186124] = {30}, --Gashtooth
        [185534] = {10}, --Bonebolt Hunter
        [186121] = {4}, -- Decatriarch Wratheye
        [186227] = {20}, -- Monstrous Decay
        -- Neltharus
        [194816] = {10}, -- Forgewrought Monstrosity
        -- Halls of Infusion
        [189719] = {15}, --Watcher Irideus
        [190407] = {20}, --Aqua Rager
        -- The Nokhud Offensive
        [186151] = {60}, --Balakar Khan
        -- Uldaman: Legacy of Tyr
        [184020] = {40}, -- Hulking Berserker
        [184580] = {10}, -- Olaf 
        [184581] = {10}, -- Baelog 
        [184582] = {10}, -- Eric "The Swift" 
        [184125] = {1}, -- Chrono-Lord Deios
        
        -- SL Dungeons
        -- Theater of Pain
        [164451] = {40}, --dessia the decapirator
        [164463] = {40}, --Paceran the Virulent
        [164461] = {40}, --Sathel the Accursed
        [165946] = {50}, -- ~mordretha
        -- Mists of Tirna Scithe
        [164501] = {70, 40, 10}, --mistcaller 
        [164926] = {50}, --Drust Boughbreaker
        [164804] = {22}, -- Droman Oulfarran
        -- Plaguefall
        [164267] = {66, 33}, --Magrave Stradama
        [164967] = {66, 33}, --Doctor ickus
        [169861] = {66, 33}, -- Ickor Bileflesh
        -- Halls of Atonement
        [164218] = {70, 40}, --Lord Chamberlain
        -- Sanguine Depths
        [162099] = {50}, --General Kaal Boss fight
        -- Spires of Ascension
        [162061] = {70, 30}, --Devos
        -- Necrotic Wake
        [163121] = {70}, -- Stitched Vanguard
        -- De Other Side
        [164558] = {80, 60, 40, 20}, --Hakkar the Soulflayer
        -- Tazavesh: So'leah Gambit
        [177269] = {40}, --So'leah
        -- Tazavesh: Streets of Wonder
        [175806] = {66, 33}, --So'azmi
        
        -- BFA Dungeons
        -- Freehold
        [126983] = {60, 30}, --Harlan Sweete - Freehold
        [126832] = {75}, --Skycap'n Kragg - Freehold
        -- The MOTHERLODE
        [133345] = {20}, --Feckless Assistant
        -- Mechagon: Junkyard
        [150276] = {50}, --Heavy Scrapbot
        [152009] = {30}, --Malfunctioning Scrapbots
        -- Mechagon: Workshop
        [144298] = {30}, --Defense Bot Mk III (casts a shield)

        -- Legion Dungeons
        -- Karazhan: Upper
        [114790] = {66, 33}, -- Viz'aduum
        -- Karazhan: Lower
        [114261] = {50}, --Toe Knee
        [114260] = {50}, -- Mrrgria
        [114265] = {50}, --Gang Ruffian
        [114783] = {50}, --Reformed Maiden
        [114312] = {60}, -- Moroes
        -- Halls of Valor
        [96574] = {30}, --Stormforged Sentinel
        [95674] = {60.5}, -- Fenryr P1
        [94960] = {10.5}, -- Hymdall
        [95676] = {80, 5}, --Odyn
        -- Court of Stars
        [104215] = {25}, -- Patrol Captain Gerdo
        --- Neltharion's Lair
        [91005] = {20}, --Naraxas
        
        -- Draenor Dungeons
        -- Grimrail Depot
        [81236] = {50}, -- Grimrail Technician
        [79545] = {60}, -- Nitrogg Thundertower
        [77803] = {20}, -- Railmaster Rocketspark
        -- Iron Docks
        [81297] = {50}, -- Dreadfang -> Fleshrender Nok'gar
        -- Shadowmoon Burial Grounds
        [76057] = {20.5}, -- Carrion Worm
        
        -- Pandaria Dungeons
        -- Temple of the Jade Serpent
        [59544] = {50}, --The Nodding Tiger
        [56732] = {70, 29.5}, -- Liu Flameheart
        
        -- DF Raid
        --Aberrus, the Shadowed Crucible
        [201261] = {80, 60, 40}, -- Kazzara
        [201773] = {50}, -- Moltannia
        [201774] = {50}, -- Krozgoth
        [201668] = {70, 40}, -- Neltharion
        [200912] = {50}, -- Neldris, Experiment
        [200913] = {50}, -- Thadrion, Experiment
        [199659] = {25}, --Warlord Kagni, Assault of the Zaqali
        [201754] = {65, 40}, -- Sarkareth
        -- Vault of the Incarnates
        [181378] = {66, 33}, --Kurog Grimtotem, 
        [194990] = {50}, -- Stormseeker Acolyte
        [189492] = {65}, -- Raszageth
        
        --SL Raid
        -- Sepulcher of the First Ones
        [181548] = {40}, --Absolution: Prototype Pantheon
        [181551] = {40}, --Duty: Prototype Pantheon
        [181546] = {40}, --Renewal: Prototype Pantheon
        [181549] = {40}, --War: Prototype Pantheon
        [183501] = {75, 50}, --Xymox
        [180906] = {78, 45}, --Halondrus
        [183671] = {40}, --Monstrous Soul - Anduin
        [185421] = {15}, --The Jailer
        -- Sanctum of Domination
        [175730] = {70, 40}, --Fatescribe Roh-Kalo
        [176523] = {70, 40}, --Painsmith
        [175725] = {66, 33}, --Eye of the Jailer
        [176929] = {60, 20}, --Remnant of Kel'Thuzad
        [175732] = {83, 50}, -- Sylvanas Windrunner
        -- Castle Nathria
        [166969] = {50}, --Council of Blood - Frieda
        [166970] = {50}, --Council of Blood - Stavros
        [166971] = {50}, --Council of Blood - Niklaus
        [167406] = {70.5, 37.5}, --Sire Denathrius
        [173162] = {66, 33}, --Lord Evershade
        
        -- Open World
        [180013] = {20}, --Escaped Wilderling, Shadowlands - Korthia
        [179931] = {80, 60}, --Relic Breaker krelva, Shadowlands - Korthia
        [193532] = {40}, --Bazual, The Dreaded Flame, Dhragonflight
        
        --Mage Tower
        [116410] = {33} -- Karam Magespear
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
        if (markersTable) then
            local unitLifePercent = envTable._HealthPercent / 100
            for _, percent in ipairs(markersTable) do
                percent = percent / 100
                if (unitLifePercent > percent) then
                    if (not unitFrame.healthMarker) then
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
            
            if (unitFrame.healthMarker and unitFrame.healthMarker:IsShown()) then
                unitFrame.healthMarker:Hide()
                unitFrame.healthOverlay:Hide()
            end
        end
    end
end

