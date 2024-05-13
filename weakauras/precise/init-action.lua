aura_env.customEventName = "XEPHUI_Precise_" .. (aura_env.config.type == 1 and "Damage" or "Healing")
aura_env.nextFrame = nil

local openRaidLib = LibStub:GetLibrary("LibOpenRaid-1.0")
openRaidLib.RegisterCallback(aura_env, "UnitInfoUpdate", "OnUnitUpdate")

local throttleRate = 0.25

do
    throttleRate = aura_env.config.throttleRate / 1000

    if throttleRate < 0 then
        throttleRate = 0.25
    end
end

aura_env.data = {}
--- @type table<string, boolean>
local friendlyUnitsCache = {}
--- @type table<string, string>
local petToOwnerCache = {}
--- @type table<string, string>
local unitToSourceGUIDMap = {}

aura_env.queue = function()
    if aura_env.nextFrame then
        return
    end

    aura_env.nextFrame =
        C_Timer.NewTimer(
        throttleRate,
        function()
            WeakAuras.ScanEvents(aura_env.customEventName, aura_env.id)
        end
    )
end

aura_env.wipeCache = function()
    wipe(aura_env.data)
end

local FALLBACK_SPEC_ICON_ID = 134400

--- @param guid string
--- @return number
local function getSpecIcon(guid)
    if guid == WeakAuras.myGUID then
        local specIndex = GetSpecialization()
        local classId = select(3, UnitClass("player"))
        return select(4, GetSpecializationInfoByID(GetSpecializationInfoForClassID(classId, specIndex)))
    end

    if Details and Details.cached_specs and Details.cached_specs[guid] then
        return select(4, GetSpecializationInfoByID(Details.cached_specs[guid]))
    end

    if not openRaidLib then
        return FALLBACK_SPEC_ICON_ID
    end

    local unit = UnitTokenFromGUID(guid)

    if unit == nil then
        return FALLBACK_SPEC_ICON_ID
    end

    local name, realm = UnitName(unit)

    if name == nil then
        return FALLBACK_SPEC_ICON_ID
    end

    if realm == nil then
        realm = ""
    else
        realm = "-" .. realm
    end

    local nameAndRealm = name .. realm
    local playersInfoData = openRaidLib.GetAllUnitsInfo()

    if not playersInfoData then
        return FALLBACK_SPEC_ICON_ID
    end

    if
        playersInfoData[nameAndRealm] and playersInfoData[nameAndRealm].specId and
            aura_env.IsPossible(unit, playersInfoData[nameAndRealm].specId)
     then
        return select(4, GetSpecializationInfoByID(playersInfoData[nameAndRealm].specId))
    end

    return FALLBACK_SPEC_ICON_ID
end

aura_env.onUnitUpdate = function(...)
    local unit, unitInfo = ...
    local specID = unitInfo.specId

    if not specID then
        return false
    end

    -- presence in this map indicates we're looking for the spec
    local sourceGUID = unitToSourceGUIDMap[unit]

    if not sourceGUID then
        return false
    end

    local icon = getSpecIcon(sourceGUID)

    if icon > 0 then
        aura_env.data[sourceGUID].icon = icon
    end
end

local spellIdToSpecMap = {
    [12294] = {1, 1}, -- arms, mortal strike
    [201363] = {1, 2}, -- fury, rampage
    [23922] = {1, 3}, -- protection, shield slam
    [25912] = {2, 1}, -- holy, holy shock damage
    [25914] = {2, 1}, -- holy, holy shock healing
    [31935] = {2, 2}, -- protection, avengers shield
    [255937] = {2, 30}, -- retribution, wake of ashes
    [217200] = {3, 1}, -- bm, barbed shot
    [257045] = {3, 2}, -- mm, rapid fire
    [259387] = {3, 3}, -- surv, mongoose bite
    [5374] = {4, 1}, -- assa, mutilate
    [185763] = {4, 2}, -- outlaw, pistol shot
    [200758] = {4, 3}, -- sub, gloomblade
    [47666] = {5, 1}, -- disc, penance damage
    [81751] = {5, 1}, -- disc, atonement healing
    [14914] = {5, 2}, -- holy, holy fire damage
    [77489] = {5, 2}, -- holy, echo of light healing
    [335467] = {5, 3}, -- shadow, devouring plague
    [206930] = {6, 1}, -- bdk, heartstrike
    [155166] = {6, 2}, -- fdk, breath of sindragosa
    [207311] = {6, 3}, -- udk, clawing shadows
    [45284] = {7, 1}, -- ele, lightning bolt overload
    [45297] = {7, 1}, -- ele, chain lightning overload
    [32175] = {7, 2}, -- enh, stormstrike
    [378597] = {7, 3}, -- resto, acid rain
    [73921] = {7, 3}, -- resto, healing rain
    [30451] = {8, 1}, -- arcane, arcane blast
    [11366] = {8, 2}, -- fire, pyroblast
    [228598] = {8, 3}, -- frost, ice lance
    [316099] = {9, 1}, -- affliction, unstable affliction
    [264178] = {9, 2}, -- demo, demonbolt
    [116858] = {9, 3}, -- destru, chaos bolt
    [121253] = {10, 1}, -- brew, keg smash
    [400145] = {10, 2}, -- mistweaver, lesson of anger
    [388609] = {10, 2}, -- mistweaver, zen pulse
    [388025] = {10, 2}, -- mistweaver, ancient teachings healing
    [117418] = {10, 3}, -- ww, fists of fury
    [202497] = {11, 1}, -- balance, shooting stars
    [391140] = {11, 2}, -- feral, frenzied assault
    [219432] = {11, 3}, -- guardian, rage of the sleeper
    [124991] = {11, 4}, -- resto, natures vigil damage
    [81269] = {11, 4}, -- resto, efflorescence healing
    [201428] = {12, 1}, -- havoc, annihilation
    [225919] = {12, 2}, -- veng, fracture
    [356995] = {13, 1}, -- devoker, disintegrate
    -- [] = {13, 2}, -- prevoker,
    [363534] = {13, 2}, -- prevoker, rewind healing
    [395160] = {13, 3} -- aug, eruption
}

--- @param spellId number
--- @return number, number
local function inferFromSpell(spellId)
    local match = spellIdToSpecMap[spellId]

    if match then
        local classId = 0
        local specIndex = 0
        print(match)
        return classId, select(4, GetSpecializationInfoByID(GetSpecializationInfoForClassID(classId, specIndex)))
    end

    return 0, 0
end

--- @param guid string
--- @return string
local function getPetOwner(guid)
    if petToOwnerCache[guid] ~= nil then
        return petToOwnerCache[guid]
    end

    local tooltipData = C_TooltipInfo.GetHyperlink("unit:" .. guid)

    if not tooltipData then
        petToOwnerCache[guid] = "unknown"
        return petToOwnerCache[guid]
    end

    for _, line in ipairs(tooltipData.lines) do
        TooltipUtil.SurfaceArgs(line)

        -- special case for Sub Rogue Secret Technique. These units are not pets,
        -- have no _formal_ tooltip but can still be queried
        if line.type == Enum.TooltipDataLineType.UnitName and line.unitToken then
            local ownerGuid = UnitGUID(line.unitToken)

            petToOwnerCache[guid] = ownerGuid or "unknown"

            return petToOwnerCache[guid]
        end

        if line.type == Enum.TooltipDataLineType.UnitOwner then
            if line.guid then
                petToOwnerCache[guid] = line.guid

                return petToOwnerCache[guid]
            end
        end
    end

    petToOwnerCache[guid] = "unknown"

    return petToOwnerCache[guid]
end

--- @param sourceGUID string
--- @param sourceFlags number
--- @param targetName string
--- @param total number
--- @param spellId number
--- @param critical number
--- @return boolean
local function populateAndUpdate(sourceGUID, sourceFlags, targetName, total, spellId, critical)
    if total <= 0 then
        return false
    end
    
    if string.find(sourceGUID, "Pet-") ~= nil then
        local petOwnerSourceGuid = getPetOwner(sourceGUID)

        if petOwnerSourceGuid == "unknown" then
            return false
        end

        sourceGUID = petOwnerSourceGuid
    end

    if friendlyUnitsCache[sourceGUID] == nil then
        friendlyUnitsCache[sourceGUID] = bit.band(sourceFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) > 0
    end

    if not friendlyUnitsCache[sourceGUID] then
        return false
    end

    local now = GetTime()

    if aura_env.data[sourceGUID] == nil then
        aura_env.data[sourceGUID] = {
            name = sourceGUID,
            classId = sourceGUID == WeakAuras.myGUID and select(3, UnitClass("player")) or 0,
            total = 0,
            -- targets = {},
            start = now,
            lastUpdate = now,
            icon = getSpecIcon(sourceGUID)
        }

        if aura_env.data[sourceGUID].icon == 0 then
            local unit = UnitTokenFromGUID(sourceGUID)
            if unit then
                unitToSourceGUIDMap[unit] = sourceGUID
            end
        end
    end

    if aura_env.data[sourceGUID].class == 0 or aura_env.data[sourceGUID].icon == FALLBACK_SPEC_ICON_ID then
        local inferredClass, inferredIcon = inferFromSpell(spellId)

        if inferredClass > 0 then
            aura_env.data[sourceGUID].class = inferredClass
        end

        if inferredIcon > 0 then
            aura_env.data[sourceGUID].icon = inferredIcon
        end
    end

    aura_env.data[sourceGUID].lastUpdate = now

    -- if aura_env.data[sourceGUID].targets[targetName] == nil then
    --     aura_env.data[sourceGUID].targets[targetName] = {}
    -- end

    -- if aura_env.data[sourceGUID].targets[targetName][spellId] == nil then
    --     aura_env.data[sourceGUID].targets[targetName][spellId] = {
    --         total = 0,
    --         hit = 0,
    --         crit = 0
    --     }
    -- end

    aura_env.data[sourceGUID].total = aura_env.data[sourceGUID].total + total
    -- aura_env.data[sourceGUID].targets[targetName][spellId].total = aura_env.data[sourceGUID].targets[targetName][spellId].total + total

    -- if critical then
    --     aura_env.data[sourceGUID].targets[targetName][spellId].crit = aura_env.data[sourceGUID].targets[targetName][spellId].crit + 1
    -- else
    --     aura_env.data[sourceGUID].targets[targetName][spellId].hit = damageDone[sourceGUID].targets[targetName][spellId].hit + 1
    -- end

    return true
end

aura_env.cleuMap = {}

if aura_env.config.type == 1 then
    --- @return boolean
    local function handleSpellDamageEvent(...)
        local _,
            _,
            _,
            sourceGUID,
            _,
            sourceFlags,
            _,
            _,
            targetName,
            _,
            _,
            spellId,
            _,
            _,
            amount,
            _,
            _,
            _,
            _,
            absorbed,
            critical = ...

        return populateAndUpdate(sourceGUID, sourceFlags, targetName, amount + (absorbed or 0), spellId, critical)
    end

    aura_env.cleuMap["SPELL_DAMAGE"] = function(...)
        return handleSpellDamageEvent(...)
    end

    aura_env.cleuMap["SPELL_PERIODIC_DAMAGE"] = function(...)
        return handleSpellDamageEvent(...)
    end
else
    --- @return boolean
    local function handleHealEvent(...)
        local _,
            _,
            _,
            sourceGUID,
            _,
            sourceFlags,
            _,
            _,
            targetName,
            _,
            _,
            spellId,
            _,
            _,
            amount,
            overheal,
            absorbed,
            critical = ...

        return populateAndUpdate(
            sourceGUID,
            sourceFlags,
            targetName,
            amount + (absorbed or 0) - overheal,
            spellId,
            critical
        )
    end

    aura_env.cleuMap["SPELL_HEAL"] = function(...)
        return handleHealEvent(...)
    end

    aura_env.cleuMap["SPELL_PERIODIC_HEAL"] = function(...)
        return handleHealEvent(...)
    end
end
