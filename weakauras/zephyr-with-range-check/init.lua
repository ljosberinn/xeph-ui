aura_env.rangeCheckEnabled = select(2, GetSpellCooldown(374227)) < 2
aura_env.lastCheck = nil
aura_env.closePlayers = 0
aura_env.lastZephyrCast = nil
aura_env.isInParty = IsInGroup()

aura_env.raidList = {
    "raid1", "raid2", "raid3", "raid4", "raid5", "raid6", "raid7", "raid8", "raid9", "raid10",
    "raid11", "raid12", "raid13", "raid14", "raid15", "raid16", "raid17", "raid18", "raid19", "raid20",
    "raid21", "raid22", "raid23", "raid24", "raid25", "raid26", "raid27", "raid28", "raid29", "raid30",
    "raid31", "raid32", "raid33", "raid34", "raid35", "raid36", "raid37", "raid38", "raid39", "raid40"
}

aura_env.partyList = {"player", "party1", "party2", "party3", "party4"}

