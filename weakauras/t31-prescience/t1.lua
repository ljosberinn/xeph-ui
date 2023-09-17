-- CLEU:SPELL_AURA_APPLIED, CLEU:SPELL_AURA_REFRESH
--- @class T31_PrescienceState
--- @field show boolean
--- @field changed boolean
--- @field stacks number
--- @field autoHide boolean
--- @field progressType "static"

--- @param states table<"", T31_PrescienceState>
--- @param event "OPTIONS" | "STATUS" | "XEPHUI_T31_Prescience" | "COMBAT_LOG_EVENT_UNFILTERED"
--- @return boolean
function (states, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local _, _, _, sourceGUID, _, _, _, targetGUID, _, _, _, spellId = ...

        if spellId ~= 410089 then
            return false
        end

        if sourceGUID ~= WeakAuras.myGUID then
            return false
        end

        local unit = UnitTokenFromGUID(targetGUID)

        if not unit then
            return false
        end

        for i = 1, 255 do
            local _, _, _, _, duration, _, _, _, _, auraSpellId = UnitAura(unit, i, "HELPFUL")

            if auraSpellId == 410089 then
                if not states[""] then
                    states[""] = {
                        stacks = 2,
                        show = true,
                        changed = true,
                        autoHide = false,
                        progressType = "static"
                    }
                end

                states[""].stacks = duration > 30 and 2 or states[""].stacks - 1
                states[""].changed = true
                states[""].show = true

                return true
            end
        end
    end

    return false
end
