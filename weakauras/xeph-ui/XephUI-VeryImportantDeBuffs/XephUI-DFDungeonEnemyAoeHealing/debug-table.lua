local tbl = {
    ["iconSource"] = -1,
    ["wagoID"] = "ZuEUctQd3",
    ["parent"] = "XephUI-VeryImportantDeBuffs",
    ["preferToUpdate"] = false,
    ["yOffset"] = 0,
    ["anchorPoint"] = "CENTER",
    ["cooldownSwipe"] = true,
    ["url"] = "https://wago.io/ZuEUctQd3/69",
    ["actions"] = {
        ["start"] = {
            ["sound_repeat"] = 2,
            ["do_loop"] = true,
            ["sound"] = "Interface\\\\Addons\\\\Details\\\\sounds\\\\sound_jedi1.ogg",
            ["do_sound"] = true,
        },
        ["init"] = {
        },
        ["finish"] = {
        },
    },
    ["triggers"] = {
        [1] = {
            ["trigger"] = {
                ["showClones"] = false,
                ["type"] = "aura2",
                ["useStacks"] = false,
                ["subeventSuffix"] = "_CAST_START",
                ["useMatch_count"] = true,
                ["event"] = "Health",
                ["unit"] = "nameplate",
                ["auraspellids"] = {
                    [1] = "198936",
                    [2] = "411911",
                },
                ["names"] = {
                },
                ["spellIds"] = {
                },
                ["subeventPrefix"] = "SPELL",
                ["match_count"] = "0",
                ["match_countOperator"] = ">",
                ["useExactSpellId"] = true,
                ["debuffType"] = "HARMFUL",
            },
            ["untrigger"] = {
            },
        },
        ["activeTriggerMode"] = -10,
    },
    ["internalVersion"] = 65,
    ["keepAspectRatio"] = true,
    ["selfPoint"] = "CENTER",
    ["desaturate"] = false,
    ["version"] = 69,
    ["subRegions"] = {
        [1] = {
            ["type"] = "subbackground",
        },
        [2] = {
            ["border_size"] = 1,
            ["border_offset"] = 0,
            ["border_color"] = {
                [1] = 0.76862752437592,
                [2] = 0.12156863510609,
                [3] = 0.23137256503105,
                [4] = 1,
            },
            ["border_visible"] = true,
            ["border_edge"] = "1 Pixel",
            ["type"] = "subborder",
        },
        [3] = {
            ["text_text_format_p_time_format"] = 0,
            ["text_text_format_s_format"] = "none",
            ["text_text"] = "%1.unitCount",
            ["text_text_format_p_time_mod_rate"] = true,
            ["text_shadowColor"] = {
                [1] = 0,
                [2] = 0,
                [3] = 0,
                [4] = 1,
            },
            ["text_selfPoint"] = "AUTO",
            ["text_automaticWidth"] = "Auto",
            ["text_fixedWidth"] = 64,
            ["anchorXOffset"] = 0,
            ["text_text_format_c_format"] = "none",
            ["text_justify"] = "CENTER",
            ["rotateText"] = "NONE",
            ["text_text_format_p_format"] = "timed",
            ["text_text_format_1.unitCount_format"] = "none",
            ["text_text_format_p_time_legacy_floor"] = false,
            ["type"] = "subtext",
            ["text_anchorXOffset"] = 0,
            ["text_color"] = {
                [1] = 1,
                [2] = 1,
                [3] = 1,
                [4] = 1,
            },
            ["text_font"] = "Oswald",
            ["text_anchorYOffset"] = -1.25,
            ["text_shadowYOffset"] = 0,
            ["text_visible"] = true,
            ["text_wordWrap"] = "WordWrap",
            ["text_fontType"] = "OUTLINE",
            ["text_anchorPoint"] = "CENTER",
            ["text_text_format_p_time_precision"] = 1,
            ["text_shadowXOffset"] = 0,
            ["text_fontSize"] = 16,
            ["text_text_format_p_time_dynamic_threshold"] = 0,
            ["anchorYOffset"] = 0,
        },
    },
    ["height"] = 28,
    ["load"] = {
        ["use_petbattle"] = false,
        ["use_zoneIds"] = true,
        ["talent"] = {
            ["multi"] = {
            },
        },
        ["use_vehicle"] = false,
        ["class"] = {
            ["multi"] = {
            },
        },
        ["size"] = {
            ["multi"] = {
            },
        },
        ["spec"] = {
            ["multi"] = {
            },
        },
        ["use_combat"] = true,
        ["race"] = {
            ["single"] = "Troll",
            ["multi"] = {
                ["Troll"] = true,
            },
        },
        ["class_and_spec"] = {
            ["single"] = 250,
            ["multi"] = {
                [250] = true,
            },
        },
        ["use_vehicleUi"] = false,
        ["use_spellknown"] = false,
        ["use_exact_spellknown"] = false,
        ["use_never"] = false,
        ["zoneIds"] = "g240,325",
    },
    ["source"] = "import",
    ["zoom"] = 0.45,
    ["authorOptions"] = {
    },
    ["regionType"] = "icon",
    ["cooldownEdge"] = false,
    ["color"] = {
        [1] = 1,
        [2] = 1,
        [3] = 1,
        [4] = 1,
    },
    ["cooldown"] = true,
    ["xOffset"] = 0,
    ["uid"] = "GafrPhrk(co",
    ["frameStrata"] = 1,
    ["cooldownTextDisabled"] = true,
    ["semver"] = "1.7.1",
    ["tocversion"] = 100007,
    ["id"] = "XephUI-DFDungeonEnemyAoeHealing",
    ["width"] = 32,
    ["alpha"] = 1,
    ["anchorFrameType"] = "SCREEN",
    ["useCooldownModRate"] = true,
    ["config"] = {
    },
    ["inverse"] = false,
    ["animation"] = {
        ["start"] = {
            ["type"] = "preset",
            ["easeType"] = "none",
            ["easeStrength"] = 3,
            ["preset"] = "fade",
            ["duration_type"] = "seconds",
        },
        ["main"] = {
            ["type"] = "none",
            ["easeType"] = "none",
            ["easeStrength"] = 3,
            ["preset"] = "pulse",
            ["duration_type"] = "seconds",
        },
        ["finish"] = {
            ["type"] = "preset",
            ["easeType"] = "none",
            ["easeStrength"] = 3,
            ["preset"] = "fade",
            ["duration_type"] = "seconds",
        },
    },
    ["conditions"] = {
    },
    ["information"] = {
        ["forceEvents"] = true,
    },
    ["icon"] = true,
}