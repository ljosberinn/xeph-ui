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
            ["do_custom"] = false,
        },
        ["finish"] = {
        },
    },
    ["triggers"] = {
        [1] = {
            ["trigger"] = {
                ["use_showAbsorb"] = true,
                ["class"] = "DRUID",
                ["use_showCost"] = false,
                ["use_unit"] = true,
                ["use_class"] = false,
                ["powertype"] = 0,
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
                ["use_requirePowerType"] = false,
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
                    [1] = "768",
                    [2] = "5487",
                },
                ["unit"] = "player",
                ["debuffType"] = "HELPFUL",
            },
            ["untrigger"] = {
            },
        },
        [3] = {
            ["trigger"] = {
                ["use_specId"] = true,
                ["type"] = "unit",
                ["use_absorbHealMode"] = true,
                ["use_absorbMode"] = true,
                ["event"] = "Class/Spec",
                ["unit"] = "player",
                ["specId"] = {
                    ["single"] = 66,
                },
                ["use_unit"] = true,
                ["debuffType"] = "HELPFUL",
            },
            ["untrigger"] = {
            },
        },
        [4] = {
            ["trigger"] = {
                ["use_specId"] = true,
                ["type"] = "unit",
                ["use_absorbHealMode"] = true,
                ["use_absorbMode"] = true,
                ["event"] = "Class/Spec",
                ["unit"] = "player",
                ["specId"] = {
                    ["single"] = 1467,
                },
                ["use_unit"] = true,
                ["debuffType"] = "HELPFUL",
            },
            ["untrigger"] = {
            },
        },
        [5] = {
            ["trigger"] = {
                ["use_specId"] = true,
                ["type"] = "unit",
                ["use_absorbHealMode"] = true,
                ["use_absorbMode"] = true,
                ["event"] = "Class/Spec",
                ["use_unit"] = true,
                ["specId"] = {
                    ["single"] = 70,
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
    ["internalVersion"] = 65,
    ["iconSource"] = 2,
    ["selfPoint"] = "CENTER",
    ["xOffset"] = 0,
    ["adjustedMax"] = "100%",
    ["barColor"] = {
        [1] = 0,
        [2] = 0.43921571969986,
        [3] = 0.8705883026123,
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
            ["multi"] = {
                [66] = true,
                [105] = true,
                [70] = true,
                [1467] = true,
                [1468] = true,
            },
        },
        ["use_class_and_spec"] = false,
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
    ["height"] = 8,
    ["icon_side"] = "RIGHT",
    ["id"] = "XephUI-Mana",
    ["uid"] = "EF0zwQMc()v",
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
                ["trigger"] = 2,
                ["variable"] = "show",
                ["value"] = 1,
            },
            ["changes"] = {
                [1] = {
                    ["value"] = 0.25,
                    ["property"] = "alpha",
                },
            },
        },
        [2] = {
            ["check"] = {
                ["trigger"] = -2,
                ["variable"] = "OR",
                ["checks"] = {
                    [1] = {
                        ["trigger"] = 3,
                        ["variable"] = "show",
                        ["value"] = 1,
                    },
                    [2] = {
                        ["trigger"] = 4,
                        ["variable"] = "show",
                        ["value"] = 1,
                    },
                    [3] = {
                        ["trigger"] = 5,
                        ["variable"] = "show",
                        ["value"] = 1,
                    },
                },
            },
            ["changes"] = {
                [1] = {
                    ["value"] = 1,
                    ["property"] = "height",
                },
                [2] = {
                    ["value"] = false,
                    ["property"] = "sub.3.border_visible",
                },
                [3] = {
                    ["property"] = "alpha",
                },
            },
        },
    },
    ["barColor2"] = {
        [1] = 1,
        [2] = 1,
        [3] = 0,
        [4] = 1,
    },
    ["config"] = {
    },
}