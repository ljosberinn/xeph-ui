local tbl = {
    ["overlays"] = {
        [1] = {
            [1] = 1,
            [2] = 1,
            [3] = 1,
            [4] = 1,
        },
        [2] = {
            [1] = 0.67843137254902,
            [2] = 0.47058823529412,
            [3] = 1,
            [4] = 1,
        },
        [3] = {
            [1] = 0,
            [2] = 0.34901960784314,
            [3] = 0.23137254901961,
            [4] = 1,
        },
    },
    ["sparkOffsetX"] = 0,
    ["wagoID"] = "ZuEUctQd3",
    ["authorOptions"] = {
    },
    ["preferToUpdate"] = false,
    ["adjustedMin"] = "0%",
    ["yOffset"] = 1,
    ["anchorPoint"] = "CENTER",
    ["sparkWidth"] = 10,
    ["anchorFrameType"] = "SCREEN",
    ["sparkRotation"] = 0,
    ["sparkRotationMode"] = "AUTO",
    ["url"] = "https://wago.io/ZuEUctQd3/69",
    ["actions"] = {
        ["start"] = {
            ["do_custom"] = false,
        },
        ["init"] = {
            ["custom"] = "\\n\\n",
            ["do_custom"] = false,
        },
        ["finish"] = {
        },
    },
    ["triggers"] = {
        [1] = {
            ["trigger"] = {
                ["use_showAbsorb"] = true,
                ["class"] = "DEMONHUNTER",
                ["use_showCost"] = false,
                ["use_unit"] = true,
                ["use_class"] = true,
                ["powertype"] = 17,
                ["use_absorbMode"] = true,
                ["use_showHealAbsorb"] = true,
                ["use_powertype"] = true,
                ["debuffType"] = "HELPFUL",
                ["names"] = {
                },
                ["type"] = "unit",
                ["use_absorbHealMode"] = true,
                ["subeventSuffix"] = "_CAST_START",
                ["absorbMode"] = "OVERLAY_FROM_END",
                ["use_showIncomingHeal"] = true,
                ["spellIds"] = {
                },
                ["absorbHealMode"] = "OVERLAY_FROM_END",
                ["event"] = "Power",
                ["subeventPrefix"] = "SPELL",
                ["use_requirePowerType"] = true,
                ["unit"] = "player",
            },
            ["untrigger"] = {
            },
        },
        [2] = {
            ["trigger"] = {
                ["type"] = "aura2",
                ["useExactSpellId"] = true,
                ["auraspellids"] = {
                    [1] = "187827",
                },
                ["unit"] = "player",
                ["debuffType"] = "HELPFUL",
            },
            ["untrigger"] = {
            },
        },
        [3] = {
            ["trigger"] = {
                ["use_specId"] = false,
                ["use_form"] = false,
                ["use_inverse"] = false,
                ["use_genericShowOn"] = true,
                ["genericShowOn"] = "showOnCooldown",
                ["unit"] = "player",
                ["equipped_operator"] = ">=",
                ["specId"] = {
                    ["single"] = 581,
                    ["multi"] = {
                        [581] = true,
                    },
                },
                ["use_spec"] = true,
                ["itemName"] = 0,
                ["use_absorbMode"] = true,
                ["equipped"] = "2",
                ["debuffType"] = "HELPFUL",
                ["use_talent"] = false,
                ["type"] = "item",
                ["use_absorbHealMode"] = true,
                ["talent"] = {
                    ["multi"] = {
                    },
                },
                ["use_class"] = false,
                ["use_equipped"] = true,
                ["use_itemName"] = true,
                ["itemSetId"] = "1527",
                ["use_itemSetId"] = true,
                ["use_unit"] = true,
                ["class"] = "DEMONHUNTER",
                ["classification"] = {
                },
                ["spec"] = 2,
                ["event"] = "Item Set",
                ["form"] = {
                    ["single"] = 0,
                    ["multi"] = {
                        ["0"] = true,
                    },
                },
            },
            ["untrigger"] = {
            },
        },
        [4] = {
            ["trigger"] = {
                ["type"] = "unit",
                ["use_absorbHealMode"] = true,
                ["talent"] = {
                    ["multi"] = {
                        [320770] = true,
                    },
                },
                ["class"] = "DEMONHUNTER",
                ["event"] = "Talent Known",
                ["use_talent"] = false,
                ["use_class"] = true,
                ["unit"] = "player",
                ["use_absorbMode"] = true,
                ["use_spec"] = true,
                ["use_unit"] = true,
                ["spec"] = 2,
                ["use_stacks"] = false,
                ["debuffType"] = "HELPFUL",
            },
            ["untrigger"] = {
            },
        },
        ["disjunctive"] = "any",
        ["activeTriggerMode"] = -10,
    },
    ["icon_color"] = {
        [1] = 1,
        [2] = 1,
        [3] = 1,
        [4] = 1,
    },
    ["internalVersion"] = 65,
    ["iconSource"] = 2,
    ["selfPoint"] = "CENTER",
    ["xOffset"] = 0,
    ["adjustedMax"] = "100%",
    ["barColor"] = {
        [1] = 0.78823536634445,
        [2] = 0.258823543787,
        [3] = 0.99215692281723,
        [4] = 1,
    },
    ["desaturate"] = true,
    ["backgroundColor"] = {
        [1] = 0.1803921610117,
        [2] = 0.070588238537312,
        [3] = 0.19215688109398,
        [4] = 0.75,
    },
    ["enableGradient"] = false,
    ["sparkOffsetY"] = 0,
    ["subRegions"] = {
        [1] = {
            ["type"] = "subbackground",
        },
        [2] = {
            ["type"] = "subforeground",
        },
        [3] = {
            ["border_size"] = 1,
            ["border_anchor"] = "bg",
            ["border_offset"] = 0,
            ["border_color"] = {
                [1] = 0,
                [2] = 0,
                [3] = 0,
                [4] = 1,
            },
            ["border_visible"] = true,
            ["border_edge"] = "1 Pixel",
            ["type"] = "subborder",
        },
        [4] = {
            ["text_text_format_p_time_precision"] = 1,
            ["text_text"] = "%1.power",
            ["text_text_format_1.health_big_number_format"] = "AbbreviateNumbers",
            ["text_shadowColor"] = {
                [1] = 0,
                [2] = 0,
                [3] = 0,
                [4] = 1,
            },
            ["text_text_format_1.health_decimal_precision"] = 0,
            ["text_text_format_1.power_round_type"] = "floor",
            ["text_text_format_p_time_legacy_floor"] = false,
            ["text_text_format_1.health_format"] = "Number",
            ["text_text_format_1.percenthealth_format"] = "Number",
            ["rotateText"] = "NONE",
            ["text_text_format_unit_realm_name"] = "never",
            ["text_color"] = {
                [1] = 1,
                [2] = 1,
                [3] = 1,
                [4] = 1,
            },
            ["text_text_format_1.health_abbreviate_max"] = 8,
            ["text_text_format_unit_abbreviate"] = false,
            ["text_shadowYOffset"] = -1,
            ["text_text_format_unit_format"] = "Unit",
            ["text_wordWrap"] = "WordWrap",
            ["text_visible"] = true,
            ["text_text_format_1.health_round_type"] = "floor",
            ["text_text_format_t_time_precision"] = 1,
            ["text_text_format_1.percenthealth_decimal_precision"] = 1,
            ["text_fontSize"] = 18,
            ["anchorXOffset"] = 0,
            ["text_text_format_t_time_dynamic_threshold"] = 60,
            ["text_text_format_n_format"] = "none",
            ["text_fixedWidth"] = 64,
            ["text_text_format_p_time_format"] = 0,
            ["text_text_format_1.power_decimal_precision"] = 0,
            ["text_text_format_1.health_color"] = true,
            ["text_text_format_p_time_mod_rate"] = true,
            ["text_text_format_1.power_format"] = "Number",
            ["text_selfPoint"] = "CENTER",
            ["text_automaticWidth"] = "Auto",
            ["text_text_format_t_time_legacy_floor"] = false,
            ["text_text_format_t_time_format"] = 0,
            ["anchorYOffset"] = 0,
            ["text_justify"] = "CENTER",
            ["text_text_format_1.health_realm_name"] = "never",
            ["text_text_format_t_format"] = "timed",
            ["text_text_format_p_time_dynamic_threshold"] = 60,
            ["text_text_format_1.absorb_format"] = "none",
            ["type"] = "subtext",
            ["text_anchorXOffset"] = 0,
            ["text_text_format_p_format"] = "BigNumber",
            ["text_font"] = "Oswald",
            ["text_fontType"] = "None",
            ["text_anchorYOffset"] = -1.75,
            ["text_shadowXOffset"] = 1,
            ["text_text_format_p_big_number_format"] = "AbbreviateLargeNumbers",
            ["text_text_format_t_time_mod_rate"] = true,
            ["text_anchorPoint"] = "INNER_CENTER",
            ["text_text_format_unit_color"] = true,
            ["text_text_format_1.percentHealth_format"] = "none",
            ["text_text_format_1.health_abbreviate"] = false,
            ["text_text_format_c_format"] = "none",
            ["text_text_format_unit_abbreviate_max"] = 8,
        },
    },
    ["gradientOrientation"] = "HORIZONTAL",
    ["parent"] = "XephUI-Bars",
    ["load"] = {
        ["use_petbattle"] = false,
        ["use_never"] = false,
        ["talent"] = {
            ["multi"] = {
            },
        },
        ["use_vehicle"] = false,
        ["class"] = {
            ["single"] = "DEMONHUNTER",
            ["multi"] = {
            },
        },
        ["use_class"] = true,
        ["use_vehicleUi"] = false,
        ["class_and_spec"] = {
            ["single"] = 581,
            ["multi"] = {
            },
        },
        ["use_class_and_spec"] = true,
        ["spec"] = {
            ["multi"] = {
            },
        },
        ["size"] = {
            ["multi"] = {
            },
        },
    },
    ["sparkBlendMode"] = "ADD",
    ["useAdjustededMax"] = false,
    ["animation"] = {
        ["start"] = {
            ["type"] = "none",
            ["easeType"] = "none",
            ["easeStrength"] = 3,
            ["preset"] = "grow",
            ["duration_type"] = "seconds",
        },
        ["main"] = {
            ["type"] = "none",
            ["easeType"] = "none",
            ["easeStrength"] = 3,
            ["preset"] = "spiralandpulse",
            ["duration_type"] = "seconds",
        },
        ["finish"] = {
            ["type"] = "none",
            ["easeStrength"] = 3,
            ["duration_type"] = "seconds",
            ["easeType"] = "none",
        },
    },
    ["source"] = "import",
    ["frameStrata"] = 4,
    ["information"] = {
        ["forceEvents"] = true,
    },
    ["icon"] = false,
    ["smoothProgress"] = true,
    ["useAdjustededMin"] = false,
    ["regionType"] = "aurabar",
    ["version"] = 69,
    ["height"] = 16,
    ["icon_side"] = "RIGHT",
    ["id"] = "XephUI-FuryVengeance",
    ["uid"] = "hV4xRaHQ3cs",
    ["sparkHeight"] = 30,
    ["texture"] = "Details Flat",
    ["overlaysTexture"] = {
        [1] = "Details Flat",
        [2] = "Details Flat",
        [3] = "Details Flat",
    },
    ["sparkTexture"] = "Interface\\\\CastingBar\\\\UI-CastingBar-Spark",
    ["semver"] = "1.7.1",
    ["tocversion"] = 100007,
    ["sparkHidden"] = "NEVER",
    ["overlayclip"] = false,
    ["alpha"] = 1,
    ["width"] = 274,
    ["zoom"] = 0.45,
    ["sparkColor"] = {
        [1] = 1,
        [2] = 1,
        [3] = 1,
        [4] = 1,
    },
    ["inverse"] = false,
    ["spark"] = false,
    ["orientation"] = "HORIZONTAL",
    ["conditions"] = {
        [1] = {
            ["check"] = {
                ["trigger"] = 1,
                ["op"] = "<",
                ["variable"] = "power",
                ["value"] = "30",
            },
            ["changes"] = {
                [1] = {
                    ["value"] = {
                        [1] = 0.78823536634445,
                        [2] = 0.258823543787,
                        [3] = 0.99215692281723,
                        [4] = 0.40000003576279,
                    },
                    ["property"] = "barColor",
                },
            },
        },
        [2] = {
            ["check"] = {
                ["trigger"] = 1,
                ["op"] = "<",
                ["variable"] = "power",
                ["value"] = "40",
            },
            ["linked"] = true,
            ["changes"] = {
                [1] = {
                    ["value"] = {
                        [1] = 0.78823536634445,
                        [2] = 0.258823543787,
                        [3] = 0.99215692281723,
                        [4] = 0.75,
                    },
                    ["property"] = "barColor",
                },
            },
        },
        [3] = {
            ["check"] = {
                ["trigger"] = -2,
                ["op"] = ">=",
                ["variable"] = "AND",
                ["checks"] = {
                    [1] = {
                        ["trigger"] = 1,
                        ["op"] = ">=",
                        ["variable"] = "power",
                        ["value"] = "95",
                    },
                    [2] = {
                        ["trigger"] = -2,
                        ["variable"] = "OR",
                        ["checks"] = {
                            [1] = {
                                ["trigger"] = 2,
                                ["variable"] = "show",
                                ["value"] = 1,
                            },
                            [2] = {
                                ["trigger"] = 4,
                                ["op"] = "==",
                                ["variable"] = "stacks",
                                ["value"] = "2",
                            },
                        },
                    },
                },
            },
            ["linked"] = true,
            ["changes"] = {
                [1] = {
                    ["value"] = {
                        [1] = 1,
                        [2] = 0.17647059261799,
                        [3] = 0.34117648005486,
                        [4] = 1,
                    },
                    ["property"] = "barColor",
                },
            },
        },
        [4] = {
            ["check"] = {
                ["trigger"] = -2,
                ["variable"] = "AND",
                ["checks"] = {
                    [1] = {
                        ["trigger"] = 1,
                        ["op"] = ">=",
                        ["variable"] = "power",
                        ["value"] = "90",
                    },
                    [2] = {
                        ["op"] = "==",
                        ["checks"] = {
                            [1] = {
                                ["trigger"] = 3,
                                ["variable"] = "show",
                                ["value"] = 1,
                            },
                            [2] = {
                                ["trigger"] = 2,
                                ["variable"] = "show",
                                ["value"] = 0,
                            },
                            [3] = {
                                ["trigger"] = 5,
                                ["op"] = "==",
                                ["variable"] = "stacks",
                                ["value"] = "2",
                            },
                        },
                        ["value"] = "2",
                        ["variable"] = "stacks",
                        ["trigger"] = 4,
                    },
                    [3] = {
                        ["trigger"] = 2,
                        ["variable"] = "show",
                        ["value"] = 0,
                    },
                    [4] = {
                        ["trigger"] = 3,
                        ["variable"] = "show",
                        ["value"] = 1,
                    },
                },
            },
            ["linked"] = true,
            ["changes"] = {
                [1] = {
                    ["value"] = {
                        [1] = 1,
                        [2] = 0.17647059261799,
                        [3] = 0.34117648005486,
                        [4] = 1,
                    },
                    ["property"] = "barColor",
                },
            },
        },
        [5] = {
            ["check"] = {
                ["trigger"] = -2,
                ["variable"] = "AND",
                ["checks"] = {
                    [1] = {
                        ["trigger"] = 1,
                        ["op"] = ">=",
                        ["variable"] = "power",
                        ["value"] = "85",
                    },
                    [2] = {
                        ["trigger"] = -2,
                        ["variable"] = "OR",
                        ["checks"] = {
                            [1] = {
                                ["trigger"] = -2,
                                ["variable"] = "AND",
                                ["checks"] = {
                                    [1] = {
                                        ["trigger"] = 2,
                                        ["variable"] = "show",
                                        ["value"] = 1,
                                    },
                                    [2] = {
                                        ["trigger"] = 4,
                                        ["op"] = "==",
                                        ["variable"] = "stacks",
                                        ["value"] = "2",
                                    },
                                },
                            },
                            [2] = {
                                ["op"] = "==",
                                ["checks"] = {
                                    [1] = {
                                        ["trigger"] = 2,
                                        ["variable"] = "show",
                                        ["value"] = 0,
                                    },
                                    [2] = {
                                        ["trigger"] = 4,
                                        ["op"] = "==",
                                        ["variable"] = "stacks",
                                        ["value"] = "1",
                                    },
                                },
                                ["value"] = "1",
                                ["variable"] = "stacks",
                                ["trigger"] = 4,
                            },
                        },
                    },
                },
            },
            ["linked"] = true,
            ["changes"] = {
                [1] = {
                    ["value"] = {
                        [1] = 1,
                        [2] = 0.17647059261799,
                        [3] = 0.34117648005486,
                        [4] = 1,
                    },
                    ["property"] = "barColor",
                },
            },
        },
        [6] = {
            ["check"] = {
                ["trigger"] = -2,
                ["variable"] = "AND",
                ["checks"] = {
                    [1] = {
                        ["trigger"] = 1,
                        ["op"] = ">=",
                        ["variable"] = "power",
                        ["value"] = "80",
                    },
                    [2] = {
                        ["trigger"] = 3,
                        ["variable"] = "show",
                        ["value"] = 1,
                    },
                    [3] = {
                        ["trigger"] = 2,
                        ["variable"] = "show",
                        ["value"] = 0,
                    },
                    [4] = {
                        ["trigger"] = 4,
                        ["op"] = "==",
                        ["variable"] = "stacks",
                        ["value"] = "1",
                    },
                },
            },
            ["linked"] = true,
            ["changes"] = {
                [1] = {
                    ["value"] = {
                        [1] = 1,
                        [2] = 0.17647059261799,
                        [3] = 0.34117648005486,
                        [4] = 1,
                    },
                    ["property"] = "barColor",
                },
            },
        },
        [7] = {
            ["check"] = {
                ["trigger"] = -2,
                ["variable"] = "AND",
                ["checks"] = {
                    [1] = {
                        ["trigger"] = 1,
                        ["op"] = ">=",
                        ["variable"] = "power",
                        ["value"] = "75",
                    },
                    [2] = {
                        ["trigger"] = -2,
                        ["variable"] = "OR",
                        ["checks"] = {
                            [1] = {
                                ["trigger"] = -2,
                                ["variable"] = "AND",
                                ["checks"] = {
                                    [1] = {
                                        ["trigger"] = 2,
                                        ["variable"] = "show",
                                        ["value"] = 1,
                                    },
                                    [2] = {
                                        ["trigger"] = 4,
                                        ["op"] = "==",
                                        ["variable"] = "stacks",
                                        ["value"] = "1",
                                    },
                                },
                            },
                            [2] = {
                                ["trigger"] = 4,
                                ["variable"] = "show",
                                ["value"] = 0,
                                ["checks"] = {
                                    [1] = {
                                        ["trigger"] = 4,
                                        ["variable"] = "show",
                                        ["value"] = 0,
                                    },
                                },
                            },
                        },
                    },
                },
            },
            ["linked"] = true,
            ["changes"] = {
                [1] = {
                    ["value"] = {
                        [1] = 1,
                        [2] = 0.17647059261799,
                        [3] = 0.34117648005486,
                        [4] = 1,
                    },
                    ["property"] = "barColor",
                },
            },
        },
        [8] = {
            ["check"] = {
                ["trigger"] = -2,
                ["variable"] = "AND",
                ["checks"] = {
                    [1] = {
                        ["trigger"] = 1,
                        ["op"] = ">=",
                        ["variable"] = "power",
                        ["value"] = "70",
                    },
                    [2] = {
                        ["trigger"] = -2,
                        ["variable"] = "AND",
                        ["checks"] = {
                            [1] = {
                                ["trigger"] = 3,
                                ["variable"] = "show",
                                ["value"] = 1,
                            },
                            [2] = {
                                ["trigger"] = 2,
                                ["variable"] = "show",
                                ["value"] = 0,
                            },
                            [3] = {
                                ["trigger"] = 4,
                                ["variable"] = "show",
                                ["value"] = 0,
                            },
                        },
                    },
                },
            },
            ["linked"] = true,
            ["changes"] = {
                [1] = {
                    ["value"] = {
                        [1] = 1,
                        [2] = 0.17647059261799,
                        [3] = 0.34117648005486,
                        [4] = 1,
                    },
                    ["property"] = "barColor",
                },
            },
        },
        [9] = {
            ["check"] = {
                ["trigger"] = -2,
                ["variable"] = "AND",
                ["checks"] = {
                    [1] = {
                        ["trigger"] = 1,
                        ["op"] = ">=",
                        ["variable"] = "power",
                        ["value"] = "66",
                    },
                    [2] = {
                        ["trigger"] = -2,
                        ["variable"] = "AND",
                        ["checks"] = {
                            [1] = {
                                ["trigger"] = 4,
                                ["op"] = "==",
                                ["variable"] = "stacks",
                                ["value"] = "2",
                            },
                            [2] = {
                                ["trigger"] = 2,
                                ["variable"] = "show",
                                ["value"] = 1,
                            },
                            [3] = {
                                ["trigger"] = 3,
                                ["variable"] = "show",
                                ["value"] = 1,
                            },
                        },
                    },
                },
            },
            ["linked"] = true,
            ["changes"] = {
                [1] = {
                    ["value"] = {
                        [1] = 1,
                        [2] = 0.17647059261799,
                        [3] = 0.34117648005486,
                        [4] = 1,
                    },
                    ["property"] = "barColor",
                },
            },
        },
        [10] = {
            ["check"] = {
                ["trigger"] = -2,
                ["variable"] = "AND",
                ["checks"] = {
                    [1] = {
                        ["trigger"] = 1,
                        ["op"] = ">=",
                        ["variable"] = "power",
                        ["value"] = "65",
                    },
                    [2] = {
                        ["trigger"] = -2,
                        ["variable"] = "AND",
                        ["checks"] = {
                            [1] = {
                                ["trigger"] = 4,
                                ["op"] = "==",
                                ["variable"] = "show",
                                ["value"] = 0,
                            },
                            [2] = {
                                ["trigger"] = 2,
                                ["variable"] = "show",
                                ["value"] = 1,
                            },
                        },
                    },
                },
            },
            ["linked"] = true,
            ["changes"] = {
                [1] = {
                    ["value"] = {
                        [1] = 1,
                        [2] = 0.17647059261799,
                        [3] = 0.34117648005486,
                        [4] = 1,
                    },
                    ["property"] = "barColor",
                },
            },
        },
    },
    ["barColor2"] = {
        [1] = 0.63921570777893,
        [2] = 0.18823531270027,
        [3] = 0.78823536634445,
        [4] = 1,
    },
    ["config"] = {
    },
}