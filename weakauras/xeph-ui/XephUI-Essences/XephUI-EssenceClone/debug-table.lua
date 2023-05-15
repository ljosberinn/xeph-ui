local tbl = {
    ["sparkWidth"] = 10,
    ["iconSource"] = -1,
    ["wagoID"] = "ZuEUctQd3",
    ["xOffset"] = 0,
    ["preferToUpdate"] = false,
    ["yOffset"] = 0,
    ["anchorPoint"] = "CENTER",
    ["sparkRotation"] = 0,
    ["sparkRotationMode"] = "AUTO",
    ["url"] = "https://wago.io/ZuEUctQd3/69",
    ["icon"] = false,
    ["triggers"] = {
        [1] = {
            ["trigger"] = {
                ["use_absorbMode"] = true,
                ["subeventPrefix"] = "SPELL",
                ["debuffType"] = "HELPFUL",
                ["type"] = "custom",
                ["use_absorbHealMode"] = true,
                ["subeventSuffix"] = "_CAST_START",
                ["essence"] = 1,
                ["names"] = {
                },
                ["event"] = "Evoker Essence",
                ["custom_type"] = "stateupdate",
                ["custom"] = "function(states, event, unit, powerType)\\n    local isStatusOrOptions = event == \\\"OPTIONS\\\" or event == \\\"STATUS\\\"\\n    \\n    if not isStatusOrOptions and powerType and powerType ~= \\\"ESSENCE\\\" then\\n        return\\n    end\\n    \\n    if not isStatusOrOptions and unit ~= \\\"player\\\" then\\n        return false\\n    end\\n    \\n    local power = aura_env.getCurrentPower()\\n    local maxPower = aura_env.getMaxPower()\\n    \\n    -- skip if power didn't change since last update, events trigger too many times it weird\\n    if not isStatusOrOptions and power == aura_env.lastPower and maxPower == aura_env.lastMaxPower then\\n        --return\\n    end\\n    \\n    local rechargeRate = aura_env.getCurrentRegenerationRate()\\n    local now = GetTime()\\n    \\n    local anyUpdate = false\\n    \\n    for essence = 1, 6 do\\n        if essence > maxPower then\\n            if states[essence] then\\n                states[essence].show = false\\n                states[essence].changed = true\\n            end\\n        else\\n            states[essence] = states[essence] or {\\n                progressType = \\\"timed\\\",\\n                index = essence\\n            }\\n            \\n            if essence == power + 1 then\\n                local lastRemaining = 0\\n                \\n                if aura_env.lastPower and essence < aura_env.lastPower then\\n                    local lastState = states[aura_env.lastPower + 1]\\n                    \\n                    if lastState and lastState.progressType == \\\"timed\\\" then\\n                        local remaining =  lastState.duration - ((lastState.expirationTime or 0) - now)\\n                        if remaining > 0 then\\n                            lastRemaining = remaining\\n                        end\\n                    end\\n                end\\n                \\n                local updated = aura_env.updateState(states[essence], {\\n                        duration = rechargeRate,\\n                        expirationTime = (rechargeRate - lastRemaining) + now ,\\n                        progressType = \\\"timed\\\",\\n                        show = true,                        \\n                        power = power,\\n                })\\n                anyUpdate = anyUpdate or updated\\n            elseif essence <= power then\\n                local updated = aura_env.updateState(states[essence], {\\n                        value = 1,\\n                        total = 1,\\n                        progressType = \\\"static\\\",\\n                        show = true,\\n                        power = power,\\n                })\\n                anyUpdate = anyUpdate or updated\\n            else\\n                local updated = aura_env.updateState(states[essence], {\\n                        value = 0,\\n                        total = 1,\\n                        progressType = \\\"static\\\",\\n                        show = true,\\n                        power = power,\\n                })\\n                anyUpdate = anyUpdate or updated\\n            end\\n        end\\n    end\\n    \\n    aura_env.lastPower = power\\n    aura_env.lastMaxPower = maxPower\\n    \\n    return anyUpdate\\nend",
                ["spellIds"] = {
                },
                ["events"] = "UNIT_POWER_FREQUENT:player, UNIT_MAXPOWER:player, OPTIONS, STATUS",
                ["unit"] = "player",
                ["check"] = "event",
                ["use_unit"] = true,
                ["use_essence"] = true,
                ["customVariables"] = "{ \\n    duration = true,\\n    progressType = {\\n        type = \\\"select\\\",\\n        values = { static = \\\"static\\\", timed = \\\"timed\\\" }\\n    },\\n    power = \\\"number\\\",\\n}",
            },
            ["untrigger"] = {
            },
        },
        [2] = {
            ["trigger"] = {
                ["type"] = "aura2",
                ["useExactSpellId"] = true,
                ["auraspellids"] = {
                    [1] = "359618",
                    [2] = "369299",
                },
                ["unit"] = "player",
                ["debuffType"] = "HELPFUL",
            },
            ["untrigger"] = {
            },
        },
        [3] = {
            ["trigger"] = {
                ["type"] = "unit",
                ["use_absorbHealMode"] = true,
                ["talent"] = {
                    ["multi"] = {
                        [369908] = true,
                    },
                },
                ["class"] = "EVOKER",
                ["event"] = "Talent Known",
                ["unit"] = "player",
                ["use_class"] = true,
                ["spec"] = 1,
                ["use_spec"] = true,
                ["use_absorbMode"] = true,
                ["use_unit"] = true,
                ["use_talent"] = false,
                ["debuffType"] = "HELPFUL",
            },
            ["untrigger"] = {
            },
        },
        [4] = {
            ["trigger"] = {
                ["type"] = "aura2",
                ["useExactSpellId"] = true,
                ["auraspellids"] = {
                    [1] = "411055",
                },
                ["unit"] = "player",
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
    ["enableGradient"] = false,
    ["backgroundColor"] = {
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0.5,
    },
    ["selfPoint"] = "CENTER",
    ["sparkOffsetX"] = 0,
    ["barColor"] = {
        [1] = 0.20000001788139,
        [2] = 0.5686274766922,
        [3] = 0.50196081399918,
        [4] = 1,
    },
    ["desaturate"] = false,
    ["parent"] = "XephUI-Essences",
    ["actions"] = {
        ["start"] = {
        },
        ["init"] = {
            ["custom"] = "--- @return number\\naura_env.getCurrentPower = function()\\n    return UnitPower(\\\"player\\\", Enum.PowerType.Essence)\\nend\\n\\n--- @return number\\naura_env.getMaxPower = function()\\n    return UnitPowerMax(\\\"player\\\", Enum.PowerType.Essence)\\nend\\n\\n--- @return number\\naura_env.getCurrentRegenerationRate = function()\\n    local rate = GetPowerRegenForPowerType(Enum.PowerType.Essence)\\n    \\n    if rate == nil or rate == 0 then\\n        rate = 0.2\\n    end\\n    \\n    return 5 / (5 / (1 / rate))\\nend\\n\\n--- @param state table<number, State>\\n--- @param changes table\\n--- @return boolean\\naura_env.updateState = function(state, changes)\\n    local updated = false\\n    \\n    for key, value in pairs(changes) do\\n        if state[key] ~= value then\\n            state[key] = value\\n            state.changed = true\\n            updated = true\\n        end\\n    end\\n    \\n    return updated\\nend\\n\\naura_env.lastPower = 0\\naura_env.lastMaxPower = 0\\n\\n-- Hide SHadowedUnitFrames Essence dot display on player frame which cannot be hidden via settings\\nif SUFUnitplayer and SUFUnitplayer.essence then\\n    SUFUnitplayer.essence:Hide()\\nend",
            ["do_custom"] = true,
        },
        ["finish"] = {
        },
    },
    ["version"] = 69,
    ["subRegions"] = {
        [1] = {
            ["type"] = "subbackground",
        },
        [2] = {
            ["type"] = "subforeground",
        },
        [3] = {
            ["border_size"] = 1,
            ["border_anchor"] = "bar",
            ["border_offset"] = 0,
            ["border_color"] = {
                [1] = 0,
                [2] = 0,
                [3] = 0,
                [4] = 1,
            },
            ["border_visible"] = true,
            ["border_edge"] = "Square Full White",
            ["type"] = "subborder",
        },
        [4] = {
            ["text_shadowXOffset"] = 1,
            ["text_text"] = "%p",
            ["text_shadowColor"] = {
                [1] = 0,
                [2] = 0,
                [3] = 0,
                [4] = 1,
            },
            ["text_selfPoint"] = "AUTO",
            ["text_automaticWidth"] = "Auto",
            ["text_fixedWidth"] = 64,
            ["text_text_format_p_time_legacy_floor"] = false,
            ["text_justify"] = "CENTER",
            ["rotateText"] = "NONE",
            ["text_text_format_p_format"] = "timed",
            ["text_text_format_p_time_dynamic_threshold"] = 60,
            ["text_text_format_p_time_precision"] = 1,
            ["type"] = "subtext",
            ["text_text_format_p_time_mod_rate"] = true,
            ["text_color"] = {
                [1] = 1,
                [2] = 1,
                [3] = 1,
                [4] = 1,
            },
            ["text_font"] = "Oswald",
            ["text_text_format_p_time_format"] = 0,
            ["text_anchorYOffset"] = -2,
            ["text_visible"] = false,
            ["text_wordWrap"] = "WordWrap",
            ["text_fontType"] = "None",
            ["text_anchorPoint"] = "INNER_CENTER",
            ["text_shadowYOffset"] = -1,
            ["anchorYOffset"] = 0,
            ["text_fontSize"] = 12,
            ["anchorXOffset"] = 0,
            ["text_text_format_n_format"] = "none",
        },
        [5] = {
            ["api"] = false,
            ["model_x"] = 0,
            ["model_st_us"] = 40,
            ["model_st_rz"] = 0,
            ["model_alpha"] = 1,
            ["model_fileId"] = "3618495",
            ["model_path"] = "spells/arcanepower_state_chest.m2",
            ["model_st_ty"] = 0,
            ["model_y"] = 0,
            ["model_st_rx"] = 270,
            ["rotation"] = 0,
            ["type"] = "submodel",
            ["model_st_tx"] = 0,
            ["model_st_ry"] = 0,
            ["model_z"] = 0,
            ["model_visible"] = false,
            ["model_st_tz"] = 0,
            ["bar_model_clip"] = true,
        },
    },
    ["gradientOrientation"] = "HORIZONTAL",
    ["internalVersion"] = 65,
    ["load"] = {
        ["use_petbattle"] = false,
        ["class_and_spec"] = {
            ["single"] = 1467,
            ["multi"] = {
            },
        },
        ["talent"] = {
            ["multi"] = {
            },
        },
        ["use_vehicle"] = false,
        ["class"] = {
            ["multi"] = {
            },
        },
        ["use_vehicleUi"] = false,
        ["spec"] = {
            ["multi"] = {
            },
        },
        ["use_class_and_spec"] = true,
        ["size"] = {
            ["multi"] = {
            },
        },
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
            ["easeType"] = "none",
        },
        ["main"] = {
            ["type"] = "none",
            ["easeStrength"] = 3,
            ["duration_type"] = "seconds",
            ["easeType"] = "none",
        },
        ["finish"] = {
            ["type"] = "none",
            ["easeStrength"] = 3,
            ["duration_type"] = "seconds",
            ["easeType"] = "none",
        },
    },
    ["information"] = {
        ["forceEvents"] = true,
    },
    ["sparkOffsetY"] = 0,
    ["smoothProgress"] = false,
    ["useAdjustededMin"] = false,
    ["regionType"] = "aurabar",
    ["height"] = 16,
    ["authorOptions"] = {
    },
    ["icon_side"] = "RIGHT",
    ["sparkColor"] = {
        [1] = 1,
        [2] = 1,
        [3] = 1,
        [4] = 1,
    },
    ["sparkHeight"] = 30,
    ["texture"] = "Details Flat",
    ["anchorFrameType"] = "SCREEN",
    ["sparkTexture"] = "Interface\\\\CastingBar\\\\UI-CastingBar-Spark",
    ["semver"] = "1.7.1",
    ["tocversion"] = 100007,
    ["id"] = "XephUI-EssenceClone",
    ["alpha"] = 1,
    ["frameStrata"] = 1,
    ["width"] = 52.9,
    ["spark"] = false,
    ["config"] = {
    },
    ["inverse"] = false,
    ["zoom"] = 0,
    ["orientation"] = "HORIZONTAL",
    ["conditions"] = {
        [1] = {
            ["check"] = {
                ["trigger"] = 1,
                ["op"] = "==",
                ["variable"] = "progressType",
                ["value"] = "timed",
            },
            ["changes"] = {
                [1] = {
                    ["value"] = true,
                    ["property"] = "inverse",
                },
                [2] = {
                    ["value"] = true,
                    ["property"] = "sub.4.text_visible",
                },
            },
        },
        [2] = {
            ["check"] = {
                ["trigger"] = 2,
                ["variable"] = "show",
                ["value"] = 1,
            },
            ["changes"] = {
                [1] = {
                    ["value"] = true,
                    ["property"] = "sub.5.model_visible",
                },
                [2] = {
                    ["value"] = 1,
                    ["property"] = "alpha",
                },
            },
        },
        [3] = {
            ["check"] = {
                ["trigger"] = 3,
                ["variable"] = "show",
                ["value"] = 1,
            },
            ["changes"] = {
                [1] = {
                    ["value"] = 42.9,
                    ["property"] = "width",
                },
            },
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
                                ["op"] = "<",
                                ["variable"] = "power",
                                ["value"] = "1",
                            },
                            [2] = {
                                ["trigger"] = 4,
                                ["variable"] = "show",
                                ["value"] = 1,
                            },
                        },
                    },
                    [2] = {
                        ["trigger"] = -2,
                        ["variable"] = "AND",
                        ["checks"] = {
                            [1] = {
                                ["trigger"] = 1,
                                ["op"] = "<",
                                ["variable"] = "power",
                                ["value"] = "2",
                            },
                            [2] = {
                                ["trigger"] = 4,
                                ["variable"] = "show",
                                ["value"] = 0,
                            },
                        },
                    },
                },
            },
            ["changes"] = {
                [1] = {
                    ["value"] = 0.3,
                    ["property"] = "alpha",
                },
            },
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
                                ["trigger"] = 1,
                                ["op"] = "<",
                                ["variable"] = "power",
                                ["value"] = "2",
                            },
                            [2] = {
                                ["trigger"] = 4,
                                ["variable"] = "show",
                                ["value"] = 1,
                            },
                        },
                    },
                    [2] = {
                        ["trigger"] = -2,
                        ["variable"] = "AND",
                        ["checks"] = {
                            [1] = {
                                ["trigger"] = 1,
                                ["op"] = "<",
                                ["variable"] = "power",
                                ["value"] = "3",
                            },
                            [2] = {
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
                    ["value"] = 0.75,
                    ["property"] = "alpha",
                },
            },
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
                                ["value"] = 0,
                            },
                            [2] = {
                                ["trigger"] = 1,
                                ["op"] = ">=",
                                ["variable"] = "power",
                                ["value"] = "4",
                            },
                        },
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
                                ["trigger"] = 1,
                                ["op"] = ">=",
                                ["variable"] = "power",
                                ["value"] = "5",
                            },
                        },
                    },
                },
            },
            ["linked"] = false,
            ["changes"] = {
                [1] = {
                    ["value"] = {
                        [1] = 1,
                        [2] = 0.50196081399918,
                        [3] = 0,
                        [4] = 1,
                    },
                    ["property"] = "barColor",
                },
            },
        },
        [7] = {
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
                                ["value"] = 0,
                            },
                            [2] = {
                                ["trigger"] = 1,
                                ["op"] = "==",
                                ["variable"] = "power",
                                ["value"] = "5",
                            },
                        },
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
                                ["trigger"] = 1,
                                ["op"] = "==",
                                ["variable"] = "power",
                                ["value"] = "6",
                            },
                        },
                    },
                },
            },
            ["linked"] = false,
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
        [1] = 0.20000001788139,
        [2] = 0.5686274766922,
        [3] = 0.50196081399918,
        [4] = 0.75,
    },
    ["uid"] = "fFDIenrbSlO",
}