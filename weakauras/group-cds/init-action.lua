aura_env.customEventName = "XEPHUI_CD_CHECK"

--- @type table<number, number>
aura_env.trackedCasts = {}

--- @type table<number, true>
aura_env.trackedBuffs = {}

for _, buff in pairs(aura_env.config.buffs) do
    if buff.active then
        aura_env.trackedBuffs[buff.id] = true
    end
end
for _, cast in pairs(aura_env.config.casts) do
    if cast.active then
        aura_env.trackedCasts[cast.id] = cast.duration
    end
end

--- @param unit string
--- @param spellId number
--- @return number, number, number
function aura_env.getAuraMeta(unit, spellId)
    local duration = 0
    local expirationTime = 0
    local icon = 0

    AuraUtil.ForEachAura(
        unit,
        "HELPFUL",
        nil,
        function(...)
            local _, _, _, _, auraDuration, auraExpirationTime, _, _, _, auraSpellId = ...

            if spellId == auraSpellId then
                duration = auraDuration
                expirationTime = auraExpirationTime
                icon = select(3, GetSpellInfo(spellId))
                return true
            end

            return false
        end
    )

    return duration, expirationTime, icon
end

--- @type table<string, cbObject>
local tickers = {}

--- @param guid string
--- @param spellId number
--- @return string
function aura_env.createKey(guid, spellId)
    return guid .. "|" .. spellId
end

--- @param unit string
--- @param guid string
--- @param spellId number
--- @param key string
function aura_env.enqueuePoll(unit, guid, spellId, key)
    local id = aura_env.id
    local customEventName = aura_env.customEventName

    -- refresh events shouldn't enqueue another ticker, so clear out old
    aura_env.clearTickerFor(key)

    tickers[key] =
        C_Timer.NewTicker(
        2,
        function()
            WeakAuras.ScanEvents(customEventName, id, unit, guid, spellId)
        end
    )
end

--- @param key string
function aura_env.clearTickerFor(key)
    if tickers[key] ~= nil then
        tickers[key]:Cancel()
        tickers[key] = nil
    end
end

--- @type table<string, string>
local guidUnitCache = {}

local function guidIsDps(guid)
    local unit = UnitTokenFromGUID(guid)

    guidUnitCache[guid] = unit

    if not unit or not UnitIsFriend("player", unit) then
        return false
    end

    local role = UnitGroupRolesAssigned(unit)

    if role == "TANK" or role == "HEALER" then
        return false
    end

    return true
end

--- @param spellId number
--- @param sourceGUID string
--- @param targetGUID string
--- @return string|nil, string|nil
function aura_env.getBuffedPlayerGuid(spellId, sourceGUID, targetGUID)
    if guidIsDps(sourceGUID) then
        return sourceGUID, guidUnitCache[sourceGUID]
    end

    -- show pi on target
    if spellId == 10060 and guidIsDps(targetGUID) then
        return targetGUID, guidUnitCache[targetGUID]
    end
end
