function (states, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local _, _, _, _, _, _, _, targetGUID, _, _, _, spellId = ...

        if targetGUID ~= WeakAuras.myGUID then
            return false
        end

        if spellId ~= 224127 and spellId ~= 224125 and spellId ~= 224126 then
            return false
        end

        local isFirst = true
        local now = GetTime()

        for _, state in pairs(states) do
            if state.expirationTime > now then
                isFirst = false
                break
            end
        end

        local GetSpellInfo = C_Spell.GetSpellInfo and C_Spell.GetSpellInfo or GetSpellInfo

        states[#states + 1] = {
            spellId = spellId,
            show = true,
            changed = true,
            duration = 15,
            expirationTime = now + 15,
            autoHide = true,
            progressType = "timed",
            icon = select(3, GetSpellInfo(spellId)),
            isFirst = isFirst
        }

        if isFirst then
            local id = aura_env.id

            aura_env.timer =
                C_Timer.After(
                15,
                function()
                    WeakAuras.ScanEvents("XEPHUI_FERAL_SPIRITS", id, now + 15)
                end
            )
        end

        return true
    end

    if event == "XEPHUI_FERAL_SPIRITS" then
        local id, now = ...

        if id ~= aura_env.id then
            return false
        end

        for _, state in pairs(states) do
            if state.show and state.expirationTime > now and not state.isFirst then
                state.isFirst = true
                state.changed = true
                local nextExpiration = state.expirationTime - now

                aura_env.timer =
                    C_Timer.After(
                    nextExpiration,
                    function()
                        WeakAuras.ScanEvents("XEPHUI_FERAL_SPIRITS", id, now + nextExpiration)
                    end
                )

                return true
            end
        end

        return false
    end

    if event == "PLAYER_DEAD" then
        local changed = false

        for _, state in pairs(states) do
            state.changed = true
            state.show = false
            changed = true
        end

        if aura_env.timer ~= nil and not aura_env.timer:IsCancelled() then
            aura_env.timer:Cancel()
        end

        return changed
    end

    return false
end
