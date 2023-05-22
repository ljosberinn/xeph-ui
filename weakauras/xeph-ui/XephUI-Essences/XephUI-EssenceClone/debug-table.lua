local tbl = {
    ["sparkWidth"] = 10,
    ["iconSource"] = -1,
    ["wagoID"] = "ZuEUctQd3",
    ["xOffset"] = 0,
    ["preferToUpdate"] = true,
    ["yOffset"] = 0,
    ["anchorPoint"] = "CENTER",
    ["sparkRotation"] = 0,
    ["sparkRotationMode"] = "AUTO",
    ["url"] = "https://wago.io/ZuEUctQd3/69",
    ["actions"] = {
        ["start"] = {},
        ["init"] = {
            ["custom"] = 'aura_env.lastPower = -1\\n\\n--- @return number\\nlocal function GetEssenceCooldown()\\n    local rechargeRate = GetPowerRegenForPowerType(Enum.PowerType.Essence)\\n    \\n    if rechargeRate == nil or rechargeRate == 0 then\\n        rechargeRate = 0.2\\n    end\\n    \\n    return 1 / rechargeRate\\nend\\n\\n\\n--- @class EssenceState\\n--- @field show boolean\\n--- @field value number\\n--- @field total number\\n--- @field progressType \\"static\\" | \\"timed\\"\\n--- @field expirationTime number\\n--- @field duration number\\n--- @field changed boolean\\n\\n--- @param state EssenceState\\n--- @param changes table\\n--- @return boolean\\nlocal function UpdateState(state, changes)\\n    local updated = false\\n    for key, value in pairs(changes) do\\n        if state[key] ~= value then\\n            state[key] = value\\n            state.changed = true\\n            updated = true\\n        end\\n    end\\n    \\n    return updated\\nend\\n\\n--- @param essence number\\n--- @param power number\\n--- @param state EssenceState\\n--- @return boolean\\nlocal function UpdateProgress(essence, power, state)\\n    if essence == power + 1 then\\n        local duration = GetEssenceCooldown()\\n        \\n        return UpdateState(\\n            state,\\n            {\\n                duration = duration,\\n                expirationTime = GetTime() + duration,\\n                progressType = \\"timed\\",\\n                show = true\\n            }\\n        )\\n    end\\n    \\n    if essence <= power then\\n        return UpdateState(\\n            state,\\n            {\\n                value = 1,\\n                total = 1,\\n                progressType = \\"static\\",\\n                show = true\\n            }\\n        )\\n    end\\n    \\n    return UpdateState(\\n        state,\\n        {\\n            value = 0,\\n            total = 1,\\n            progressType = \\"static\\",\\n            show = true\\n        }\\n    )\\nend\\n\\n--- @param states table<number, EssenceState>\\n--- @return boolean\\nlocal function Initialize(states, maxPower)\\n    for essence = 1, 6 do\\n        if states[essence] == nil then\\n            states[essence] = {\\n                progressType = \\"timed\\",\\n                index = essence\\n            }\\n        end\\n    end\\n    \\n    if maxPower == 5 and states[6].show then\\n        states[6].show = false\\n        \\n        return true\\n    end\\n    \\n    return false\\nend\\n\\n--- @param states table<number, EssenceState>\\n--- @param power number\\n--- @param maxPower number\\n--- @return boolean\\nlocal function Update(states, power, maxPower)\\n    local didUpdate = false\\n    for essence = 1, maxPower do\\n        if UpdateProgress(essence, power, states[essence]) then\\n            didUpdate = true\\n        end\\n    end\\n    \\n    return didUpdate\\nend\\n\\n--- @param states table<number, EssenceState>\\n--- @return boolean\\nfunction aura_env.trigger(states)\\n    local maxPower = UnitPowerMax(\\"player\\", Enum.PowerType.Essence)\\n    local power = UnitPower(\\"player\\", Enum.PowerType.Essence)\\n    \\n    if power == aura_env.lastPower and #states ~= 0 then\\n        return false\\n    end\\n    \\n    aura_env.lastPower = power\\n    \\n    return Initialize(states, maxPower) or Update(states, power, maxPower)\\nend\\n\\n\\n-- Hide SHadowedUnitFrames Essence dot display on player frame which cannot be hidden via settings\\nif SUFUnitplayer and SUFUnitplayer.essence then\\n    SUFUnitplayer.essence:Hide()\\nend',
            ["do_custom"] = true
        },
        ["finish"] = {}
    },
    ["triggers"] = {
        [1] = {
            ["trigger"] = {
                ["use_absorbMode"] = true,
                ["names"] = {},
                ["debuffType"] = "HELPFUL",
                ["type"] = "custom",
                ["use_absorbHealMode"] = true,
                ["subeventSuffix"] = "_CAST_START",
                ["essence"] = 1,
                ["use_essence"] = true,
                ["event"] = "Evoker Essence",
                ["custom_type"] = "stateupdate",
                ["subeventPrefix"] = "SPELL",
                ["spellIds"] = {},
                ["custom"] = '-- UNIT_POWER_FREQUENT:player, UNIT_MAXPOWER:player\\n\\n--- @param states table<number, EssenceState>\\n--- @param powerType nil | string\\n--- @return boolean\\nfunction (states, _, _, powerType)\\n    if powerType and powerType ~= \\"ESSENCE\\" then\\n        return false\\n    end\\n    \\n    return aura_env.trigger(states)\\nend',
                ["use_unit"] = true,
                ["check"] = "event",
                ["events"] = "UNIT_POWER_FREQUENT:player, UNIT_MAXPOWER:player, OPTIONS, STATUS",
                ["unit"] = "player",
                ["customVariables"] = '{ \\n    duration = true,\\n    progressType = {\\n        type = \\"select\\",\\n        values = { static = \\"static\\", timed = \\"timed\\" }\\n    },\\n    power = \\"number\\",\\n}'
            },
            ["untrigger"] = {}
        },
        [2] = {
            ["trigger"] = {
                ["type"] = "aura2",
                ["auraspellids"] = {
                    [1] = "359618",
                    [2] = "369299",
                    [3] = "392268"
                },
                ["unit"] = "player",
                ["useExactSpellId"] = true,
                ["debuffType"] = "HELPFUL"
            },
            ["untrigger"] = {}
        },
        [3] = {
            ["trigger"] = {
                ["type"] = "unit",
                ["use_absorbHealMode"] = true,
                ["talent"] = {
                    ["multi"] = {
                        [369908] = true
                    }
                },
                ["use_absorbMode"] = true,
                ["event"] = "Talent Known",
                ["use_talent"] = false,
                ["use_class"] = true,
                ["spec"] = 1,
                ["use_spec"] = true,
                ["class"] = "EVOKER",
                ["unit"] = "player",
                ["use_unit"] = true,
                ["debuffType"] = "HELPFUL"
            },
            ["untrigger"] = {}
        },
        [4] = {
            ["trigger"] = {
                ["type"] = "aura2",
                ["auraspellids"] = {
                    [1] = "411055"
                },
                ["unit"] = "player",
                ["useExactSpellId"] = true,
                ["debuffType"] = "HELPFUL"
            },
            ["untrigger"] = {}
        },
        [5] = {
            ["trigger"] = {
                ["type"] = "unit",
                ["use_absorbHealMode"] = true,
                ["talent"] = {
                    ["multi"] = {
                        [369908] = true
                    }
                },
                ["use_absorbMode"] = true,
                ["event"] = "Talent Known",
                ["unit"] = "player",
                ["use_class"] = true,
                ["class"] = "EVOKER",
                ["use_spec"] = true,
                ["spec"] = 3,
                ["use_talent"] = false,
                ["use_unit"] = true,
                ["debuffType"] = "HELPFUL"
            },
            ["untrigger"] = {}
        },
        ["disjunctive"] = "any",
        ["activeTriggerMode"] = -10
    },
    ["icon_color"] = {
        [1] = 1,
        [2] = 1,
        [3] = 1,
        [4] = 1
    },
    ["enableGradient"] = false,
    ["parent"] = "XephUI-Essences",
    ["selfPoint"] = "CENTER",
    ["sparkOffsetX"] = 0,
    ["barColor"] = {
        [1] = 0.20000001788139,
        [2] = 0.5686274766922,
        [3] = 0.50196081399918,
        [4] = 1
    },
    ["desaturate"] = false,
    ["authorOptions"] = {},
    ["icon"] = false,
    ["version"] = 69,
    ["subRegions"] = {
        [1] = {
            ["type"] = "subbackground"
        },
        [2] = {
            ["type"] = "subforeground"
        },
        [3] = {
            ["type"] = "subborder",
            ["border_anchor"] = "bar",
            ["border_offset"] = 0,
            ["border_color"] = {
                [1] = 0,
                [2] = 0,
                [3] = 0,
                [4] = 1
            },
            ["border_visible"] = true,
            ["border_edge"] = "Square Full White",
            ["border_size"] = 1
        },
        [4] = {
            ["text_text_format_n_format"] = "none",
            ["text_text"] = "%p",
            ["text_shadowColor"] = {
                [1] = 0,
                [2] = 0,
                [3] = 0,
                [4] = 1
            },
            ["text_selfPoint"] = "AUTO",
            ["text_automaticWidth"] = "Auto",
            ["text_fixedWidth"] = 64,
            ["text_text_format_p_time_legacy_floor"] = false,
            ["text_justify"] = "CENTER",
            ["rotateText"] = "NONE",
            ["text_text_format_p_format"] = "timed",
            ["text_text_format_p_time_dynamic_threshold"] = 60,
            ["anchorYOffset"] = 0,
            ["type"] = "subtext",
            ["text_text_format_p_time_mod_rate"] = true,
            ["text_color"] = {
                [1] = 1,
                [2] = 1,
                [3] = 1,
                [4] = 1
            },
            ["text_font"] = "Oswald",
            ["text_text_format_p_time_format"] = 0,
            ["text_shadowYOffset"] = -1,
            ["text_visible"] = false,
            ["text_wordWrap"] = "WordWrap",
            ["text_fontType"] = "None",
            ["text_anchorPoint"] = "INNER_CENTER",
            ["text_anchorYOffset"] = -2,
            ["text_shadowXOffset"] = 1,
            ["text_fontSize"] = 12,
            ["anchorXOffset"] = 0,
            ["text_text_format_p_time_precision"] = 1
        },
        [5] = {
            ["api"] = false,
            ["bar_model_clip"] = true,
            ["model_st_us"] = 40,
            ["model_st_rz"] = 0,
            ["model_st_ry"] = 0,
            ["model_fileId"] = "3618495",
            ["model_path"] = "spells/arcanepower_state_chest.m2",
            ["model_st_ty"] = 0,
            ["model_y"] = 0,
            ["model_st_rx"] = 270,
            ["rotation"] = 0,
            ["type"] = "submodel",
            ["model_st_tx"] = 0,
            ["model_z"] = 0,
            ["model_alpha"] = 1,
            ["model_visible"] = false,
            ["model_st_tz"] = 0,
            ["model_x"] = 0
        }
    },
    ["gradientOrientation"] = "HORIZONTAL",
    ["internalVersion"] = 65,
    ["load"] = {
        ["use_petbattle"] = false,
        ["class_and_spec"] = {
            ["single"] = 1467,
            ["multi"] = {
                [1467] = true,
                [1473] = true
            }
        },
        ["talent"] = {
            ["multi"] = {}
        },
        ["use_vehicle"] = false,
        ["spec"] = {
            ["multi"] = {}
        },
        ["use_vehicleUi"] = false,
        ["class"] = {
            ["multi"] = {}
        },
        ["use_class_and_spec"] = false,
        ["size"] = {
            ["multi"] = {}
        }
    },
    ["sparkBlendMode"] = "ADD",
    ["useAdjustededMax"] = false,
    ["sparkHidden"] = "NEVER",
    ["source"] = "import",
    ["animation"] = {
        ["start"] = {
            ["type"] = "none",
            ["easeStrength"] = 3,
            ["duration_type"] = "seconds",
            ["easeType"] = "none"
        },
        ["main"] = {
            ["type"] = "none",
            ["easeStrength"] = 3,
            ["duration_type"] = "seconds",
            ["easeType"] = "none"
        },
        ["finish"] = {
            ["type"] = "none",
            ["easeStrength"] = 3,
            ["duration_type"] = "seconds",
            ["easeType"] = "none"
        }
    },
    ["information"] = {
        ["forceEvents"] = true
    },
    ["sparkOffsetY"] = 0,
    ["smoothProgress"] = false,
    ["useAdjustededMin"] = false,
    ["regionType"] = "aurabar",
    ["height"] = 16,
    ["backgroundColor"] = {
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0.5
    },
    ["icon_side"] = "RIGHT",
    ["config"] = {},
    ["sparkHeight"] = 30,
    ["texture"] = "Details Flat",
    ["anchorFrameType"] = "SCREEN",
    ["zoom"] = 0,
    ["semver"] = "1.7.1",
    ["tocversion"] = 100007,
    ["id"] = "EssenceClone",
    ["frameStrata"] = 1,
    ["alpha"] = 1,
    ["width"] = 52.9,
    ["spark"] = false,
    ["sparkColor"] = {
        [1] = 1,
        [2] = 1,
        [3] = 1,
        [4] = 1
    },
    ["inverse"] = false,
    ["sparkTexture"] = "Interface\\\\CastingBar\\\\UI-CastingBar-Spark",
    ["orientation"] = "HORIZONTAL",
    ["conditions"] = {
        [1] = {
            ["check"] = {
                ["trigger"] = 1,
                ["op"] = "==",
                ["variable"] = "progressType",
                ["value"] = "timed"
            },
            ["changes"] = {
                [1] = {
                    ["value"] = true,
                    ["property"] = "inverse"
                },
                [2] = {
                    ["value"] = true,
                    ["property"] = "sub.4.text_visible"
                }
            }
        },
        [2] = {
            ["check"] = {
                ["trigger"] = 2,
                ["variable"] = "show",
                ["value"] = 1
            },
            ["changes"] = {
                [1] = {
                    ["value"] = true,
                    ["property"] = "sub.5.model_visible"
                },
                [2] = {
                    ["value"] = 1,
                    ["property"] = "alpha"
                }
            }
        },
        [3] = {
            ["check"] = {
                ["trigger"] = -2,
                ["variable"] = "OR",
                ["checks"] = {
                    [1] = {
                        ["trigger"] = -2,
                        ["variable"] = "AND",
                        ["checks"] = {
                            [1] = {
                                ["trigger"] = 1,
                                ["op"] = "<",
                                ["variable"] = "power",
                                ["value"] = "1"
                            },
                            [2] = {
                                ["trigger"] = 4,
                                ["variable"] = "show",
                                ["value"] = 1
                            }
                        }
                    },
                    [2] = {
                        ["trigger"] = -2,
                        ["variable"] = "AND",
                        ["checks"] = {
                            [1] = {
                                ["trigger"] = 1,
                                ["op"] = "<",
                                ["variable"] = "power",
                                ["value"] = "2"
                            },
                            [2] = {
                                ["trigger"] = 4,
                                ["variable"] = "show",
                                ["value"] = 0
                            }
                        }
                    }
                }
            },
            ["changes"] = {
                [1] = {
                    ["value"] = 0.3,
                    ["property"] = "alpha"
                }
            }
        },
        [4] = {
            ["check"] = {
                ["trigger"] = -2,
                ["variable"] = "OR",
                ["checks"] = {
                    [1] = {
                        ["trigger"] = -2,
                        ["variable"] = "AND",
                        ["checks"] = {
                            [1] = {
                                ["trigger"] = 1,
                                ["variable"] = "power",
                                ["op"] = "<",
                                ["value"] = "2"
                            },
                            [2] = {
                                ["trigger"] = 4,
                                ["variable"] = "show",
                                ["value"] = 1
                            }
                        }
                    },
                    [2] = {
                        ["trigger"] = -2,
                        ["variable"] = "AND",
                        ["checks"] = {
                            [1] = {
                                ["trigger"] = 1,
                                ["variable"] = "power",
                                ["op"] = "<",
                                ["value"] = "3"
                            },
                            [2] = {
                                ["trigger"] = 4,
                                ["variable"] = "show",
                                ["value"] = 0
                            }
                        }
                    }
                }
            },
            ["linked"] = true,
            ["changes"] = {
                [1] = {
                    ["value"] = 0.75,
                    ["property"] = "alpha"
                }
            }
        },
        [5] = {
            ["check"] = {
                ["trigger"] = -2,
                ["variable"] = "OR",
                ["checks"] = {
                    [1] = {
                        ["trigger"] = -2,
                        ["variable"] = "AND",
                        ["checks"] = {
                            [1] = {
                                ["trigger"] = 3,
                                ["variable"] = "show",
                                ["value"] = 0
                            },
                            [2] = {
                                ["trigger"] = 1,
                                ["op"] = ">=",
                                ["variable"] = "power",
                                ["value"] = "4"
                            }
                        }
                    },
                    [2] = {
                        ["trigger"] = -2,
                        ["variable"] = "AND",
                        ["checks"] = {
                            [1] = {
                                ["trigger"] = 3,
                                ["variable"] = "show",
                                ["value"] = 1
                            },
                            [2] = {
                                ["trigger"] = 1,
                                ["op"] = ">=",
                                ["variable"] = "power",
                                ["value"] = "5"
                            }
                        }
                    }
                }
            },
            ["linked"] = false,
            ["changes"] = {
                [1] = {
                    ["value"] = {
                        [1] = 1,
                        [2] = 0.50196081399918,
                        [3] = 0,
                        [4] = 1
                    },
                    ["property"] = "barColor"
                }
            }
        },
        [6] = {
            ["check"] = {
                ["trigger"] = -2,
                ["variable"] = "OR",
                ["checks"] = {
                    [1] = {
                        ["trigger"] = -2,
                        ["variable"] = "AND",
                        ["checks"] = {
                            [1] = {
                                ["trigger"] = 3,
                                ["variable"] = "show",
                                ["value"] = 0
                            },
                            [2] = {
                                ["trigger"] = 1,
                                ["op"] = "==",
                                ["variable"] = "power",
                                ["value"] = "5"
                            }
                        }
                    },
                    [2] = {
                        ["trigger"] = -2,
                        ["variable"] = "AND",
                        ["checks"] = {
                            [1] = {
                                ["trigger"] = 3,
                                ["variable"] = "show",
                                ["value"] = 1
                            },
                            [2] = {
                                ["trigger"] = 1,
                                ["op"] = "==",
                                ["variable"] = "power",
                                ["value"] = "6"
                            }
                        }
                    }
                }
            },
            ["linked"] = false,
            ["changes"] = {
                [1] = {
                    ["value"] = {
                        [1] = 1,
                        [2] = 0.17647059261799,
                        [3] = 0.34117648005486,
                        [4] = 1
                    },
                    ["property"] = "barColor"
                }
            }
        },
        [7] = {
            ["check"] = {
                ["trigger"] = -2,
                ["variable"] = "OR",
                ["checks"] = {
                    [1] = {
                        ["trigger"] = 3,
                        ["variable"] = "show",
                        ["value"] = 1
                    },
                    [2] = {
                        ["trigger"] = 5,
                        ["variable"] = "show",
                        ["value"] = 1
                    }
                }
            },
            ["changes"] = {
                [1] = {
                    ["value"] = 42.9,
                    ["property"] = "width"
                }
            }
        }
    },
    ["barColor2"] = {
        [1] = 0.20000001788139,
        [2] = 0.5686274766922,
        [3] = 0.50196081399918,
        [4] = 0.75
    },
    ["uid"] = "fFDIenrbSlO"
}
