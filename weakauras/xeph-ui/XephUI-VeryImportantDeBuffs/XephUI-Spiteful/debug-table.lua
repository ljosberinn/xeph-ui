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
            ["sound"] = "Interface\\\\AddOns\\\\WeakAuras\\\\Media\\\\Sounds\\\\RunAway.ogg",
            ["do_message"] = false,
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
                ["useMatch_count"] = true,
                ["useGroup_count"] = false,
                ["subeventPrefix"] = "SPELL",
                ["match_count"] = "0",
                ["debuffType"] = "HARMFUL",
                ["showClones"] = false,
                ["type"] = "aura2",
                ["auraspellids"] = {
                    [1] = "350209",
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
        ["use_vehicle"] = false,
        ["class"] = {
            ["multi"] = {
            },
        },
        ["role"] = {
            ["single"] = "TANK",
            ["multi"] = {
            },
        },
        ["use_affixes"] = true,
        ["use_vehicleUi"] = false,
        ["spec"] = {
            ["multi"] = {
            },
        },
        ["use_never"] = false,
        ["affixes"] = {
            ["single"] = 123,
            ["multi"] = {
                [123] = true,
                [4] = true,
            },
        },
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
    ["id"] = "XephUI-Spiteful",
    ["useCooldownModRate"] = true,
    ["frameStrata"] = 1,
    ["anchorFrameType"] = "SCREEN",
    ["zoom"] = 0.45,
    ["uid"] = "zfGfIg5a6pJ",
    ["inverse"] = false,
    ["authorOptions"] = {
    },
    ["conditions"] = {
    },
    ["cooldown"] = true,
    ["color"] = {
        [1] = 1,
        [2] = 1,
        [3] = 1,
        [4] = 1,
    },
}