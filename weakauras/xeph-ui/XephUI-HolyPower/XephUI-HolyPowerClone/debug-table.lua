local tbl = {
    ["sparkWidth"] = 10,
    ["iconSource"] = -1,
    ["user_x"] = 0,
    ["authorOptions"] = {
    },
    ["adjustedMax"] = "1",
    ["yOffset"] = 0,
    ["anchorPoint"] = "CENTER",
    ["sparkRotation"] = 0,
    ["sameTexture"] = true,
    ["url"] = "https://wago.io/ZuEUctQd3/69",
    ["backgroundColor"] = {
        [1] = 0.43137258291245,
        [2] = 0.29019609093666,
        [3] = 0.35294118523598,
        [4] = 0.75,
    },
    ["icon_color"] = {
        [1] = 1,
        [2] = 1,
        [3] = 1,
        [4] = 1,
    },
    ["enableGradient"] = false,
    ["selfPoint"] = "CENTER",
    ["barColor"] = {
        [1] = 0.96078437566757,
        [2] = 0.54901963472366,
        [3] = 0.7294117808342,
        [4] = 1,
    },
    ["desaturate"] = false,
    ["rotation"] = 0,
    ["font"] = "Friz Quadrata TT",
    ["sparkOffsetY"] = 0,
    ["gradientOrientation"] = "VERTICAL",
    ["crop_y"] = 0.25,
    ["textureWrapMode"] = "CLAMP",
    ["foregroundTexture"] = "Interface\\\\AddOns\\\\WeakAuras\\\\Media\\\\Textures\\\\Square_White",
    ["smoothProgress"] = true,
    ["useAdjustededMin"] = true,
    ["regionType"] = "progresstexture",
    ["blendMode"] = "BLEND",
    ["slantMode"] = "INSIDE",
    ["texture"] = "Details Flat",
    ["sparkTexture"] = "Interface\\\\CastingBar\\\\UI-CastingBar-Spark",
    ["spark"] = false,
    ["tocversion"] = 100007,
    ["alpha"] = 1,
    ["auraRotation"] = 0,
    ["backgroundOffset"] = 0,
    ["sparkOffsetX"] = 0,
    ["wagoID"] = "ZuEUctQd3",
    ["parent"] = "XephUI-HolyPower",
    ["adjustedMin"] = "0",
    ["desaturateBackground"] = false,
    ["sparkRotationMode"] = "AUTO",
    ["desaturateForeground"] = false,
    ["triggers"] = {
        [1] = {
            ["trigger"] = {
                ["type"] = "custom",
                ["custom_type"] = "stateupdate",
                ["custom_hide"] = "timed",
                ["customVariables"] = "{ transparent = \\\"bool\\\", power = \\\"number\\\" }",
                ["event"] = "Health",
                ["subeventPrefix"] = "SPELL",
                ["unit"] = "player",
                ["custom"] = "function (allstates, event, unit, powerType)\\n    local isStatusOrOptions = event == \\\"STATUS\\\" or event == \\\"OPTIONS\\\"\\n    \\n    if event == \\\"UNIT_POWER_UPDATE\\\" and (unit ~= \\\"player\\\" or powerType ~= \\\"HOLY_POWER\\\") then\\n        return false\\n    end\\n    \\n    local next = aura_env.getHolyPower()\\n    \\n    if not isStatusOrOptions and next == aura_env.currentHolyPower then\\n        return false\\n    end\\n    \\n    local transparent = next < 3\\n    local hasChanges = isStatusOrOptions   \\n    \\n    for i = 1, 5, 1 do\\n        local value = next >= i and 1 or 0\\n        \\n        if allstates[i] then\\n            allstates[i].changed = allstates[i].transparent ~= transparent or allstates[i].value ~= value            \\n            allstates[i].power = next\\n            \\n            if allstates[i].changed then\\n                hasChanges = true\\n                allstates[i].value = value\\n                allstates[i].transparent = transparent                \\n            end\\n        else\\n            hasChanges = true\\n            \\n            allstates[i] = {\\n                show = true,\\n                index = i,\\n                progressType = \\\"static\\\",\\n                value = value,\\n                total = 5,\\n                changed = true,\\n                transparent = transparent,\\n                power = next\\n            } \\n        end\\n    end\\n    \\n    aura_env.currentHolyPower = next\\n    \\n    return hasChanges\\nend",
                ["spellIds"] = {
                },
                ["events"] = "UNIT_POWER_UPDATE:player",
                ["check"] = "event",
                ["names"] = {
                },
                ["subeventSuffix"] = "_CAST_START",
                ["debuffType"] = "HELPFUL",
            },
            ["untrigger"] = {
            },
        },
        [2] = {
            ["trigger"] = {
                ["type"] = "aura2",
                ["useExactSpellId"] = true,
                ["auraspellids"] = {
                    [1] = "223819",
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
    ["endAngle"] = 360,
    ["internalVersion"] = 65,
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
    ["version"] = 69,
    ["subRegions"] = {
        [1] = {
            ["type"] = "subbackground",
        },
        [2] = {
            ["border_size"] = 1,
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
        [3] = {
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
    ["height"] = 15.87,
    ["sparkBlendMode"] = "ADD",
    ["useAdjustededMax"] = true,
    ["backgroundTexture"] = "Interface\\\\Addons\\\\WeakAuras\\\\PowerAurasMedia\\\\Auras\\\\Aura3",
    ["source"] = "import",
    ["preferToUpdate"] = false,
    ["barColor2"] = {
        [1] = 1,
        [2] = 1,
        [3] = 0,
        [4] = 1,
    },
    ["conditions"] = {
        [1] = {
            ["check"] = {
                ["trigger"] = 1,
                ["variable"] = "transparent",
                ["value"] = 1,
            },
            ["changes"] = {
                [1] = {
                    ["value"] = 0.4,
                    ["property"] = "alpha",
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
                    ["property"] = "sub.3.model_visible",
                },
                [2] = {
                    ["value"] = 1,
                    ["property"] = "alpha",
                },
            },
        },
        [3] = {
            ["check"] = {
                ["trigger"] = 1,
                ["variable"] = "power",
                ["op"] = "==",
                ["value"] = "5",
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
                    ["property"] = "foregroundColor",
                },
            },
        },
        [4] = {
            ["check"] = {
                ["trigger"] = 1,
                ["op"] = "==",
                ["value"] = "4",
                ["variable"] = "power",
            },
            ["changes"] = {
                [1] = {
                    ["value"] = {
                        [1] = 1,
                        [2] = 0.50196081399918,
                        [3] = 0,
                        [4] = 1,
                    },
                    ["property"] = "foregroundColor",
                },
            },
        },
    },
    ["mirror"] = false,
    ["sparkColor"] = {
        [1] = 1,
        [2] = 1,
        [3] = 1,
        [4] = 1,
    },
    ["config"] = {
    },
    ["compress"] = false,
    ["fontSize"] = 12,
    ["icon_side"] = "LEFT",
    ["load"] = {
        ["use_petbattle"] = false,
        ["class_and_spec"] = {
            ["single"] = 66,
            ["multi"] = {
                [66] = true,
                [70] = true,
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
        ["use_class_and_spec"] = false,
        ["size"] = {
            ["multi"] = {
            },
        },
    },
    ["width"] = 53,
    ["sparkHeight"] = 30,
    ["foregroundColor"] = {
        [1] = 0.96078437566757,
        [2] = 0.54901963472366,
        [3] = 0.7294117808342,
        [4] = 1,
    },
    ["actions"] = {
        ["start"] = {
        },
        ["init"] = {
            ["custom"] = "aura_env.getHolyPower = function()\\n    return UnitPower(\\\"player\\\", Enum.PowerType.HolyPower) \\nend\\n\\naura_env.currentHolyPower = aura_env.getHolyPower()",
            ["do_custom"] = true,
        },
        ["finish"] = {
        },
    },
    ["sparkHidden"] = "NEVER",
    ["semver"] = "1.7.1",
    ["startAngle"] = 0,
    ["id"] = "HolyPowerClone",
    ["icon"] = false,
    ["frameStrata"] = 1,
    ["anchorFrameType"] = "SCREEN",
    ["user_y"] = 0,
    ["xOffset"] = 0,
    ["inverse"] = false,
    ["uid"] = "L4qPXdqqBHE",
    ["orientation"] = "HORIZONTAL",
    ["crop_x"] = 0.36,
    ["information"] = {
    },
    ["zoom"] = 0,
}