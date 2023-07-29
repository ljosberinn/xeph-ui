aura_env.lastCheck = nil

aura_env.raidList = {
    "raid1",
    "raid2",
    "raid3",
    "raid4",
    "raid5",
    "raid6",
    "raid7",
    "raid8",
    "raid9",
    "raid10",
    "raid11",
    "raid12",
    "raid13",
    "raid14",
    "raid15",
    "raid16",
    "raid17",
    "raid18",
    "raid19",
    "raid20",
    "raid21",
    "raid22",
    "raid23",
    "raid24",
    "raid25",
    "raid26",
    "raid27",
    "raid28",
    "raid29",
    "raid30",
    "raid31",
    "raid32",
    "raid33",
    "raid34",
    "raid35",
    "raid36",
    "raid37",
    "raid38",
    "raid39",
    "raid40"
}

aura_env.partyList = {"player", "party1", "party2", "party3", "party4"}

aura_env.knownEvokers = {}

aura_env.itemId = nil

do
    -- ref https://github.com/WeakAuras/LibRangeCheck-2.0/blob/master/LibRangeCheck-2.0/LibRangeCheck-2.0.lua#L309
    local itemMap = {
        [5] = 8149,
        [8] = 33278,
        [10] = 17626,
        [15] = 1251,
        [20] = 21519
    }

    local rangeSelectionToYards = {
        [1] = 5,
        [2] = 8,
        [3] = 10,
        [4] = 15,
        [5] = 20
    }

    local yards = rangeSelectionToYards[aura_env.config.range]
    aura_env.itemId = itemMap[yards]
end

