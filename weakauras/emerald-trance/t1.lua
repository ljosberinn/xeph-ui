--- @class EmeraldTranceState
--- @field show boolean
--- @field changed boolean
--- @field value number
--- @field duration number | nil
--- @field expirationTime number | nil
--- @field autoHide true
--- @field progressType "static"

--- @param states table<number, EmeraldTranceState>
--- @param event "OPTIONS" | "STATUS" | "COMBAT_LOG_EVENT_UNFILTERED" | "XEPHUI_EMERALD_TRANCE"
--- @return boolean
function (states, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local subEvent = select(2, ...)

        if subEvent == "SPELL_AURA_APPLIED" then
            local _, _, _, sourceGUID, _, _, _, _, _, _, _, spellId = ...

            if sourceGUID ~= WeakAuras.myGUID or spellId ~= aura_env.emeraldTranecBuffId then
                return false
            end

            local duration = select(5, WA_GetUnitBuff("player", aura_env.emeraldTranecBuffId))
            aura_env.iterations = math.floor(duration / 5)
            aura_env.currentIteration = 1

            states[""] = {
                show = true,
                changed = true,
                progressType = "timed",
                autoHide = true,
                expirationTime = GetTime() + 5,
                duration = 5
            }

            aura_env.queue()

            return true
        end

        if subEvent == "SPELL_AURA_REMOVED" then
            local _, _, _, sourceGUID, _, _, _, _, _, _, _, spellId = ...

            if sourceGUID ~= WeakAuras.myGUID or spellId ~= aura_env.emeraldTranecBuffId or not states[""] then
                return false
            end

            states[""].show = false
            states[""].changed = true

            return true
        end
    end

    if event == aura_env.customEventName then
        local id = ...

        if id ~= aura_env.id then
            return false
        end

        aura_env.timer = nil

        aura_env.currentIteration = aura_env.currentIteration + 1

        states[""] = {
            show = true,
            changed = true,
            progressType = "timed",
            autoHide = true,
            expirationTime = GetTime() + 5,
            duration = 5
        }

        if aura_env.currentIteration + 1 <= aura_env.iterations then
            aura_env.queue()
        end

        return true
    end

    return false
end
