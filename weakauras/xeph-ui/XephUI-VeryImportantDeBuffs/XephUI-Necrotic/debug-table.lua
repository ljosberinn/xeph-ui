local tbl = {
    ["iconSource"] = -1,
    ["wagoID"] = "ZuEUctQd3",
    ["xOffset"] = 0,
    ["preferToUpdate"] = false,
    ["customText"] = "\\n\\n",
    ["yOffset"] = 0,
    ["anchorPoint"] = "CENTER",
    ["cooldownSwipe"] = true,
    ["cooldownEdge"] = false,
    ["actions"] = {
        ["start"] = {
        },
        ["init"] = {
        },
        ["finish"] = {
        },
    },
    ["triggers"] = {
        [1] = {
            ["trigger"] = {
                ["useMatch_count"] = true,
                ["useGroup_count"] = false,
                ["subeventPrefix"] = "SPELL",
                ["match_count"] = "0",
                ["debuffType"] = "HARMFUL",
                ["showClones"] = false,
                ["type"] = "aura2",
                ["auraspellids"] = {
                    [1] = "209858",
                },
                ["names"] = {
                },
                ["group_count"] = "0",
                ["event"] = "Health",
                ["spellIds"] = {
                },
                ["unit"] = "player",
                ["subeventSuffix"] = "_CAST_START",
                ["useExactSpellId"] = true,
                ["group_countOperator"] = ">",
                ["match_countOperator"] = ">",
            },
            ["untrigger"] = {
            },
        },
        [2] = {
            ["trigger"] = {
                ["type"] = "custom",
                ["subeventSuffix"] = "",
                ["event"] = "Combat Log",
                ["customStacks"] = "function ()\\n    local stacks = select(3, WA_GetUnitDebuff(\\\"player\\\", 209858))  \\n    local percentage = 0\\n    \\n    if(stacks ~= nil) then \\n        percentage = stacks * 2         \\n    end\\n    \\n    return percentage;\\nend\\n\\n\\n\\n",
                ["custom_hide"] = "timed",
                ["events"] = "UNIT_AURA:player",
                ["unit"] = "player",
                ["custom"] = "function()\\n    return true\\nend",
                ["subeventPrefix"] = "",
                ["custom_type"] = "event",
                ["debuffType"] = "HELPFUL",
            },
            ["untrigger"] = {
            },
        },
        ["disjunctive"] = "any",
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
                [1] = 1,
                [2] = 0,
                [3] = 0,
                [4] = 1,
            },
            ["border_visible"] = true,
            ["border_edge"] = "1 Pixel",
            ["type"] = "subborder",
        },
        [3] = {
            ["text_text_format_p_time_precision"] = 1,
            ["text_text_format_s_format"] = "none",
            ["text_text"] = "%stacks%%",
            ["text_text_format_p_time_mod_rate"] = true,
            ["anchorYOffset"] = 0,
            ["text_selfPoint"] = "AUTO",
            ["text_automaticWidth"] = "Auto",
            ["text_fixedWidth"] = 64,
            ["text_text_format_p_time_dynamic_threshold"] = 0,
            ["text_text_format_c_format"] = "none",
            ["text_justify"] = "CENTER",
            ["rotateText"] = "NONE",
            ["text_shadowXOffset"] = 0,
            ["text_text_format_stacks_format"] = "none",
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
            ["text_text_format_p_format"] = "timed",
            ["text_anchorYOffset"] = -1.25,
            ["text_fontType"] = "OUTLINE",
            ["text_wordWrap"] = "WordWrap",
            ["text_visible"] = true,
            ["text_anchorPoint"] = "CENTER",
            ["text_shadowYOffset"] = 0,
            ["text_text_format_p_time_format"] = 0,
            ["text_fontSize"] = 16,
            ["anchorXOffset"] = 0,
            ["text_shadowColor"] = {
                [1] = 0,
                [2] = 0,
                [3] = 0,
                [4] = 1,
            },
        },
    },
    ["height"] = 28,
    ["load"] = {
        ["use_petbattle"] = false,
        ["class_and_spec"] = {
            ["multi"] = {
            },
        },
        ["talent"] = {
            ["multi"] = {
            },
        },
        ["use_role"] = true,
        ["class"] = {
            ["multi"] = {
            },
        },
        ["use_affixes"] = true,
        ["role"] = {
            ["single"] = "TANK",
        },
        ["use_vehicle"] = false,
        ["use_vehicleUi"] = false,
        ["affixes"] = {
            ["single"] = 4,
            ["multi"] = {
                [4] = true,
            },
        },
        ["spec"] = {
            ["multi"] = {
            },
        },
        ["use_never"] = false,
        ["size"] = {
            ["multi"] = {
            },
        },
    },
    ["source"] = "import",
    ["config"] = {
    },
    ["url"] = "https://wago.io/ZuEUctQd3/69",
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
    ["regionType"] = "icon",
    ["icon"] = true,
    ["information"] = {
        ["forceEvents"] = true,
    },
    ["displayIcon"] = "",
    ["parent"] = "XephUI-VeryImportantDeBuffs",
    ["alpha"] = 1,
    ["width"] = 32,
    ["cooldownTextDisabled"] = true,
    ["semver"] = "1.7.1",
    ["tocversion"] = 100007,
    ["id"] = "XephUI-Necrotic",
    ["useCooldownModRate"] = true,
    ["frameStrata"] = 1,
    ["anchorFrameType"] = "SCREEN",
    ["zoom"] = 0.45,
    ["uid"] = "kW3zTFcMuN5",
    ["inverse"] = false,
    ["authorOptions"] = {
    },
    ["conditions"] = {
        [1] = {
            ["check"] = {
                ["trigger"] = 1,
                ["op"] = "==",
                ["variable"] = "totalStacks",
                ["value"] = "0",
            },
            ["changes"] = {
                [1] = {
                    ["value"] = {
                        ["sound_type"] = "Play",
                        ["sound"] = "Interface\\\\Addons\\\\WeakAuras\\\\PowerAurasMedia\\\\Sounds\\\\kaching.ogg",
                        ["sound_channel"] = "Master",
                    },
                    ["property"] = "sound",
                },
                [2] = {
                    ["value"] = {
                        ["message"] = "necro stacks gone",
                        ["message_type"] = "SAY",
                    },
                    ["property"] = "chat",
                },
            },
        },
        [2] = {
            ["check"] = {
                ["trigger"] = 1,
                ["op"] = ">=",
                ["variable"] = "totalStacks",
                ["value"] = "25",
            },
            ["linked"] = true,
            ["changes"] = {
                [1] = {
                    ["value"] = {
                        ["sound_type"] = "Play",
                        ["sound"] = "Interface\\\\AddOns\\\\WeakAuras\\\\Media\\\\Sounds\\\\OhNo.ogg",
                        ["sound_channel"] = "Master",
                    },
                    ["property"] = "sound",
                },
            },
        },
        [3] = {
            ["check"] = {
                ["trigger"] = 1,
                ["op"] = ">=",
                ["variable"] = "totalStacks",
                ["value"] = "40",
            },
            ["linked"] = true,
            ["changes"] = {
                [1] = {
                    ["value"] = {
                        ["sound_type"] = "Play",
                        ["sound"] = "Interface\\\\AddOns\\\\BugSack\\\\Media\\\\error.ogg",
                        ["sound_channel"] = "Master",
                    },
                    ["property"] = "sound",
                },
                [2] = {
                    ["value"] = {
                        ["message"] = "40+ stacks, cc pls",
                        ["message_type"] = "SAY",
                    },
                    ["property"] = "chat",
                },
            },
        },
    },
    ["cooldown"] = true,
    ["color"] = {
        [1] = 1,
        [2] = 1,
        [3] = 1,
        [4] = 1,
    },
}