-- GROUP_ROSTER_UPDATE, UNIT_SPECIALIZATION_CHANGED, PLAYER_STARTED_MOVING, PLAYER_STOPPED_MOVING, UNIT_SPELLCAST_START:player
--- @class AugmentationEvokerRangeCheckState
--- @field show boolean
--- @field changed boolean
--- @field name string
--- @field icon number
--- @field progressType "static"
--- @field autoHide false

--- @param states table<number, AugmentationEvokerRangeCheckState>
--- @param event "STATUS" | "GROUP_ROSTER_UPDATE" | "UNIT_SPECIALIZATION_CHANGED" | "PLAYER_STARTED_MOVING" | "PLAYER_STOPPED_MOVING" | "UNIT_SPELLCAST_START"
--- @returns boolean
function f(states, event)
    if aura_env.itemId == nil then
        return false
    end

    if event == "GROUP_ROSTER_UPDATE" or event == "UNIT_SPECIALIZATION_CHANGED" or event == "STATUS" then
        local units = IsInRaid() and aura_env.raidList or aura_env.partyList
        local hasChanges = false

        aura_env.knownEvokers = {}

        for _, state in pairs(states) do
            hasChanges = true
            state.changed = true
            state.show = false
        end

        for i = 1, GetNumGroupMembers() do
            local unit = units[i]

            if UnitExists(unit) and WeakAuras.myGUID ~= UnitGUID(unit) and GetInspectSpecialization(unit) == 1473 then
                local guid = UnitGUID(unit) or unit
                local name = UnitName(unit) or "Unknown"

                aura_env.knownEvokers[unit] = {
                    guid = guid,
                    name = name
                }
            end
        end

        return hasChanges
    end

    if event == "PLAYER_REGEN_ENABLED" then
        aura_env.inCombat = false
        return false
    end

    if event == "PLAYER_REGEN_DISABLED" then
        aura_env.inCombat = true
    end

    if not aura_env.inCombat then
        return false
    end

    local hasChanges = false
    local playerInstanceId = select(4, UnitPosition("player"))

    -- fallthrough case for: PLAYER_STARTED_MOVING, UNIT_SPELLCAST_START:player, UNIT_STOPPED_MOVING
    for unit, info in pairs(aura_env.knownEvokers) do
        local show =
            not UnitIsDead(unit) and not UnitPhaseReason(unit) and WeakAuras.myGUID ~= UnitGUID(unit) and
            select(4, UnitPosition(unit)) == playerInstanceId and
            IsItemInRange(aura_env.itemId, unit)

        if states[info.guid] then
            states[info.guid].changed = states[info.guid].show ~= show
            states[info.guid].show = show
            states[info.guid].name = info.name
            states[info.guid].progressType = "static"
        else
            states[info.guid] = {
                changed = true,
                show = show,
                name = info.name,
                progressType = "static",
                autoHide = false,
                icon = 5198700 -- augmentation spec icon
            }
        end

        hasChanges = hasChanges or states[info.guid].changed
    end

    return hasChanges
end
