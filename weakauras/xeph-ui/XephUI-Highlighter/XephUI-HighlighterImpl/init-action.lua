aura_env.customEventName = "XEPHUI_Highlighter"
aura_env.active = false
aura_env.nextFrame = nil
aura_env.dirtyIndices = {}

aura_env.queue = function()
    if aura_env.nextFrame then
        return
    end

    aura_env.nextFrame =
        C_Timer.NewTimer(
        0,
        function()
            WeakAuras.ScanEvents(aura_env.customEventName, aura_env.id)
        end
    )
end

--- @class CacheEntry
--- @field icon number
--- @field lastModified number|nil
--- @field total number
--- @field buffTargets table<string, number> map of guid, stacks
--- @field buffAmplifier number by how much % per stack this ability increases values
--- @field buffTrigger number
--- @field buffAllowList table<number, boolean> list of spells that are allowed to count for this trigger
--- @field buffAllowListLength number
--- @field debuffTargets table<string, number> map of guid, stacks
--- @field debuffAmplifier number by how much % per stack this ability increases values
--- @field debuffTrigger number
--- @field debuffAllowList table<number, boolean> list of spells that are allowed to count for this trigger
--- @field debuffAllowListLength number
--- @field damageTrigger table<number, boolean> list of spells that should be merged
--- @field damageTriggerLength number
--- @field healTrigger table<number, boolean> list of spells that should be merged
--- @field healTriggerLength number
--- @field resetOnSpell number whether the spell resets on spellcast success, and which spell to reset on
--- @field ownOnly boolean whether to only count own spells

--- @type table<number, CacheEntry>
local cache = {}

--- @type table<string, table<number, table<number, number>>>
local keyMaps = {}

local function resetKeyMap()
    keyMaps = {
        buff = {},
        debuff = {},
        damage = {},
        heal = {},
        cast = {}
    }
end

--- @class AbilityInfo
--- @field name string
--- @field id number

--- @class DeBuff
--- @field stacking boolean
--- @field amplification number
--- @field id number
--- @field allowlist table<number, AbilityInfo>

--- @class HealingAbility
--- @field name string
--- @field id number

--- @class ConfigAbility
--- @field hasDots boolean whether the ability has dots
--- @field hasHots boolean whether the ability has dots
--- @field active boolean whether the ability is active
--- @field specs table<number, boolean> map of all specs and which to load this abiltiy on
--- @field healing table<number, AbilityInfo>
--- @field damage table<number, AbilityInfo>
--- @field iconId number icon override
--- @field castSpellId number
--- @field buffs table<number, DeBuff>
--- @field debuffs table<number, DeBuff>
--- @field ownOnly boolean whether to only count own spells
--- @field name string

--- @class AuraEnvironmentConfig
--- @field abilities table<number, ConfigAbility>
--- @field duration number

--- @class AuraEnvironment
--- @field config AuraEnvironmentConfig
--- @field active boolean
--- @field nextFrame number|nil
--- @field customEventName string
--- @field id string
--- @field dirtyIndices table<number, boolean>

--- @cast aura_env AuraEnvironment

local hasBuffs = false
local hasDebuffs = false
local hasBuffsOrDebuffs = false
local hasHeal = false
local hasPeriodicHealing = false
local hasPeriodicDamage = false

aura_env.setup = function()
    cache = {}
    resetKeyMap()
    aura_env.active = false

    local specIndex = GetSpecialization()

    if not specIndex then
        return
    end

    local currentSpecId = GetSpecializationInfo(specIndex)

    -- https://wowpedia.fandom.com/wiki/SpecializationID
    local specToIdList = {
        [1] = 250,
        [2] = 251,
        [3] = 252,
        [4] = 577,
        [5] = 581,
        [6] = 102,
        [7] = 103,
        [8] = 104,
        [9] = 105,
        [10] = 1467,
        [11] = 1468,
        [12] = 1473,
        [13] = 253,
        [14] = 254,
        [15] = 255,
        [16] = 62,
        [17] = 63,
        [18] = 64,
        [19] = 268,
        [20] = 270,
        [21] = 269,
        [22] = 65,
        [23] = 66,
        [24] = 70,
        [25] = 256,
        [26] = 257,
        [27] = 258,
        [28] = 259,
        [29] = 260,
        [30] = 261,
        [31] = 262,
        [32] = 263,
        [33] = 264,
        [34] = 265,
        [35] = 266,
        [36] = 267,
        [37] = 71,
        [38] = 72,
        [39] = 73
    }

    local function getIcon(id)
        return select(3, GetSpellInfo(id))
    end

    --- @param ability ConfigAbility
    --- @return number
    local function resolveIcon(ability)
        if ability.iconId > 0 then
            return ability.iconId
        end

        if ability.buffs[1].id > 0 then
            return getIcon(ability.buffs[1].id)
        end

        if ability.debuffs[1].id > 0 then
            return getIcon(ability.debuffs[1].id)
        end

        if #ability.damage > 0 then
            return getIcon(ability.damage[1].id)
        end

        if #ability.healing > 0 then
            return getIcon(ability.healing[1].id)
        end

        if ability.castSpellId > 0 then
            return getIcon(ability.castSpellId)
        end

        -- somehow, couldn't determine an icon. use questionmark to not look stupid
        return 134400
    end

    --- @param ability ConfigAbility
    --- @return boolean
    local function thisSpellShouldLoad(ability)
        if not ability.active then
            return false
        end

        for index, selected in pairs(ability.specs) do
            if selected then
                local specId = specToIdList[index]

                if specId == currentSpecId then
                    return true
                end
            end
        end

        return false
    end

    --- @param tbl table
    --- @return number
    local function getLength(tbl)
        local count = 0

        for _ in pairs(tbl) do
            count = count + 1
        end

        return count
    end

    for _, ability in pairs(aura_env.config.abilities) do
        if thisSpellShouldLoad(ability) then
            local icon = resolveIcon(ability)

            --- @type table<number, boolean>
            local buffAllowList = {}
            if ability.buffs[1].id > 0 then
                for _, info in pairs(ability.buffs[1].allowlist) do
                    buffAllowList[info.id] = true
                end
            end

            --- @type table<number, boolean>
            local debuffAllowList = {}
            if ability.debuffs[1].id > 0 then
                for _, info in pairs(ability.debuffs[1].allowlist) do
                    debuffAllowList[info.id] = true
                end
            end

            --- @type table<number, boolean>
            local damageTrigger = {}
            for _, info in pairs(ability.damage) do
                damageTrigger[info.id] = true
            end

            --- @type table<number, boolean>
            local healTrigger = {}
            for _, info in pairs(ability.healing) do
                healTrigger[info.id] = true
                hasHeal = true
            end

            if ability.hasDots then
                hasPeriodicDamage = true
            end

            if ability.hasHots then
                hasPeriodicHealing = true
            end

            if ability.buffs[1].id > 0 then
                hasBuffs = true
                hasBuffsOrDebuffs = true
            end

            if ability.debuffs[1].id > 0 then
                hasDebuffs = true
                hasBuffsOrDebuffs = true
            end

            --- @type CacheEntry
            local cacheEntry = {
                lastModified = nil,
                icon = icon,
                total = 0,
                buffAmplifier = ability.buffs[1].amplification,
                buffTrigger = ability.buffs[1].id,
                buffAllowList = buffAllowList,
                buffAllowListLength = getLength(buffAllowList),
                buffTargets = {},
                debuffAmplifier = ability.debuffs[1].amplification,
                debuffTrigger = ability.debuffs[1].id,
                debuffAllowList = debuffAllowList,
                debuffAllowListLength = getLength(debuffAllowList),
                debuffTargets = {},
                damageTrigger = damageTrigger,
                damageTriggerLength = getLength(damageTrigger),
                healTrigger = healTrigger,
                healTriggerLength = getLength(healTrigger),
                resetOnSpell = ability.castSpellId,
                ownOnly = ability.ownOnly,
            }

            table.insert(cache, cacheEntry)
        end
    end

    aura_env.active = #cache > 0

    --- @param tbl table<number, table<number, number>>
    --- @param trigger integer
    --- @param index integer
    local function populateForSpell(tbl, trigger, index)
        if not tbl[trigger] then
            tbl[trigger] = {}
        end

        table.insert(tbl[trigger], index)
    end

    for index, entry in pairs(cache) do
        if entry.resetOnSpell > 0 then
            populateForSpell(keyMaps.cast, entry.resetOnSpell, index)
        end

        if entry.buffTrigger > 0 then
            populateForSpell(keyMaps.buff, entry.buffTrigger, index)

            for id in pairs(entry.buffAllowList) do
                populateForSpell(keyMaps.damage, id, index)
            end
        end

        if entry.debuffTrigger > 0 then
            populateForSpell(keyMaps.debuff, entry.debuffTrigger, index)

            for id in pairs(entry.debuffAllowList) do
                populateForSpell(keyMaps.damage, id, index)
            end
        end

        for key in pairs(entry.damageTrigger) do
            populateForSpell(keyMaps.damage, key, index)
        end

        for key in pairs(entry.healTrigger) do
            populateForSpell(keyMaps.heal, key, index)
        end
    end
end

aura_env.setup()

--- @param key number
--- @param now number
--- @param force boolean
--- @return boolean
local function reset(key, now, force)
    local hasChanges = false

    if
        force or
            (cache[key].total > 0 and cache[key].lastModified ~= nil and
                now > cache[key].lastModified + aura_env.config.duration)
     then
        hasChanges = true

        aura_env.dirtyIndices[key] = nil
        cache[key].total = 0
        cache[key].lastModified = nil
    end

    return hasChanges
end

--- @param tbl table<integer, boolean>
--- @param force boolean
--- @return boolean
aura_env.expireOutdatedData = function(tbl, force)
    local hasChanges = false
    local now = GetTime()

    for key in pairs(tbl) do
        local updated = reset(key, now, force)
        if not hasChanges and updated then
            hasChanges = true
        end
    end

    return hasChanges
end

--- @param spellId number
--- @return boolean
aura_env.onSpellCastSuccess = function(spellId)
    local keysToAdditionallyReset = keyMaps.cast[spellId] or {}

    local copy = {}

    for _, index in pairs(keysToAdditionallyReset) do
        table.insert(copy, index, true)
    end

    return aura_env.expireOutdatedData(copy, true) or aura_env.expireOutdatedData(aura_env.dirtyIndices, false) or false
end

--- @type table<string, boolean>
local unknownGuidIsMyPet = {}

--- @param guid string
--- @return boolean
local function isMyPet(guid)
    if unknownGuidIsMyPet[guid] ~= nil then
        return unknownGuidIsMyPet[guid]
    end

    local tooltipData = C_TooltipInfo.GetHyperlink("unit:" .. guid)

    if not tooltipData then
        unknownGuidIsMyPet[guid] = false
        return false
    end

    for _, line in ipairs(tooltipData.lines) do
        TooltipUtil.SurfaceArgs(line)

        if line.type == Enum.TooltipDataLineType.UnitOwner then
            local result = line.guid == WeakAuras.myGUID
            unknownGuidIsMyPet[guid] = result

            return result
        end
    end

    unknownGuidIsMyPet[guid] = false

    return false
end

--- @param guid string
--- @return boolean
local function isBasicallyMe(guid)
    return guid == WeakAuras.myGUID or isMyPet(guid) or false
end

--- @param key number
--- @param sourceGUID string
--- @param targetGUID string
--- @param spellId number
--- @param kind "heal" | "damage"
--- @return boolean, number
local function validateAndDetermineAmplification(key, sourceGUID, targetGUID, spellId, kind)
    local ability = cache[key]

    if ability.ownOnly and not isBasicallyMe(sourceGUID) then
        return false, 0
    end

    if ability.buffTrigger > 0 then
        if
            ability.buffTargets[sourceGUID] == nil or ability.buffAllowListLength == 0 or
                ability.buffAllowList[spellId] ~= true
         then
            return false, 0
        end

        if ability.buffAmplifier > 0 then
            return true, ability.buffTargets[sourceGUID] * ability.buffAmplifier
        end

        return true, 0
    end

    if ability.debuffTrigger > 0 then
        if
            ability.debuffTargets[targetGUID] == nil or ability.debuffAllowListLength == 0 or
                ability.debuffAllowList[spellId] ~= true
         then
            return false, 0
        end

        -- spell is debuff trigger, implying its already amplified
        if ability.debuffAmplifier > 0 and ability.debuffTrigger ~= spellId then
            return true, ability.debuffTargets[targetGUID] * ability.debuffAmplifier
        end

        return true, 0
    end

    local genericTriggers = kind == "damage" and ability.damageTrigger or ability.healTrigger
    local length = kind == "damage" and ability.damageTriggerLength or ability.healTriggerLength

    if length > 0 and genericTriggers[spellId] == nil then
        return false, 0
    end

    return true, 0
end

--- @param amount number
--- @param amplification number
--- @return number
local function calculateTotal(amount, amplification)
    if amplification == 0 then
        return amount
    end

    local result = amount / (100 + amplification) * amplification

    if amplification < 1 then
        return result * 100
    end

    return result
end

--- @param key number
--- @param total number
local function updateCacheAndDirty(key, total)
    cache[key].total = cache[key].total + total
    cache[key].lastModified = GetTime()

    aura_env.dirtyIndices[key] = true
end

--- @return boolean
local function handleDamageEvent(...)
    if not InCombatLockdown() then -- cannot possibly be our damage event
        return false
    end

    local _, _, _, sourceGUID, _, _, _, targetGUID, _, _, _, spellId, _, _, amount, _, _, _, _, absorbed = ...

    local keys = keyMaps.damage[spellId]

    if not keys then
        return false
    end

    local hasChanges = false

    for _, key in pairs(keys) do
        local mayProceed, amplification =
            validateAndDetermineAmplification(key, sourceGUID, targetGUID, spellId, "damage")

        if mayProceed then
            local total = calculateTotal(amount + (absorbed or 0), amplification)

            if total > 0 then
                hasChanges = true

                updateCacheAndDirty(key, total)
            end
        end
    end

    return hasChanges
end

--- @return boolean
local function handleHealEvent(...)
    local _, _, _, sourceGUID, _, _, _, targetGUID, _, _, _, spellId, _, _, amount, overheal = ...

    local keys = keyMaps.heal[spellId]

    if not keys then
        return false
    end

    local hasChanges = false

    for _, key in pairs(keys) do
        local mayProceed, amplification =
            validateAndDetermineAmplification(key, sourceGUID, targetGUID, spellId, "heal")

        if mayProceed then
            local total = calculateTotal(amount - overheal, amplification)

            if total > 0 then
                hasChanges = true
                updateCacheAndDirty(key, total)
            end
        end
    end

    return hasChanges
end

--- @return boolean
local function handleAuraApplication(...)
    local _, _, _, sourceGUID, _, _, _, targetGUID, _, _, _, spellId, _, _, type, stacks = ...

    if sourceGUID ~= WeakAuras.myGUID then
        return false
    end

    if type == "BUFF" then
        if not hasBuffs then
            return false
        end

        local keys = keyMaps.buff[spellId]

        if not keys then
            return false
        end

        stacks = stacks or 1

        for _, key in pairs(keys) do
            cache[key].buffTargets[targetGUID] = stacks
        end
    end

    if not hasDebuffs then
        return false
    end

    local keys = keyMaps.debuff[spellId]

    if not keys then
        return false
    end

    stacks = stacks or 1

    for _, key in pairs(keys) do
        cache[key].debuffTargets[targetGUID] = stacks
    end

    return false
end

--- @return boolean
local function handleAuraRemoval(...)
    local _, _, _, sourceGUID, _, _, _, targetGUID, _, _, _, spellId, _, _, type, stacks = ...

    if sourceGUID ~= WeakAuras.myGUID then
        return false
    end

    if type == "BUFF" then
        if not hasBuffs then
            return false
        end

        local keys = keyMaps.buff[spellId]

        if not keys then
            return false
        end

        -- since this fn is used for both general aura removal and individual stacks
        stacks = stacks or nil

        for _, key in pairs(keys) do
            if cache[key].buffTargets[targetGUID] then
                cache[key].buffTargets[targetGUID] = stacks
            end
        end

        return false
    end

    if not hasDebuffs then
        return false
    end

    local keys = keyMaps.debuff[spellId]

    if not keys then
        return false
    end

    -- since this fn is used for both general aura removal and individual stacks
    stacks = stacks or nil

    for _, key in pairs(keys) do
        if cache[key].debuffTargets[targetGUID] then
            cache[key].debuffTargets[targetGUID] = stacks
        end
    end

    return false
end

--- @return boolean
local function handleSpellMissed(...)
    local _, _, _, sourceGUID, _, _, _, targetGUID, _, _, _, spellId, _, _, missType, _, amount = ...

    if missType ~= "ABSORB" then
        return false
    end

    return handleDamageEvent(
        nil,
        nil,
        nil,
        sourceGUID,
        nil,
        nil,
        nil,
        targetGUID,
        nil,
        nil,
        nil,
        spellId,
        nil,
        nil,
        amount
    )
end

aura_env.cleuMap = {
    ["SPELL_AURA_APPLIED_DOSE"] = function(...)
        if not hasBuffsOrDebuffs then
            return false
        end

        return handleAuraApplication(...)
    end,
    ["SPELL_AURA_REMOVED_DOSE"] = function(...)
        if not hasBuffsOrDebuffs then
            return false
        end

        return handleAuraRemoval(...)
    end,
    ["SPELL_AURA_APPLIED"] = function(...)
        if not hasBuffsOrDebuffs then
            return false
        end

        return handleAuraApplication(...)
    end,
    ["SPELL_AURA_REMOVED"] = function(...)
        if not hasBuffsOrDebuffs then
            return false
        end

        return handleAuraRemoval(...)
    end,
    ["SPELL_DAMAGE"] = function(...)
        return handleDamageEvent(...)
    end,
    ["SPELL_PERIODIC_DAMAGE"] = function(...)
        if not hasPeriodicDamage then
            return false
        end

        return handleDamageEvent(...)
    end,
    ["SPELL_HEAL"] = function(...)
        if not hasHeal then
            return false
        end

        return handleHealEvent(...)
    end,
    ["SPELL_PERIODIC_HEAL"] = function(...)
        if not hasPeriodicHealing then
            return false
        end

        return handleHealEvent(...)
    end,
    ["SPELL_MISSED"] = function(...)
        return handleSpellMissed(...)
    end,
    ["SPELL_PERIODIC_MISSED"] = function(...)
        if not hasPeriodicDamage then
            return false
        end

        return handleSpellMissed(...)
    end
}
--- @param index number
--- @return number, number
aura_env.getDisplayDataForIndex = function(index)
    return cache[index].total, cache[index].icon
end

--- we don't track which enemies die, so unless we did, we'd be carrying around
--- a growing list of enemies with debuffs active despite them being long dead.
--- however, many enemies don't die event-wise, so it's safer and more performant
--- to just assume whenever you leave combat, we can drop all seen debuff stacks
--- @return boolean
aura_env.onPlayerRegenEnabled = function()
    if not hasDebuffs then
        return false
    end

    for _, keys in pairs(keyMaps.debuff) do
        for _, key in pairs(keys) do
            for guid in pairs(cache[key].debuffTargets) do
                cache[key].debuffTargets[guid] = nil
            end
        end
    end

    return false
end
