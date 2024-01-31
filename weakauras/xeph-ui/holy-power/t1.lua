--- UNIT_POWER_UPDATE:player, CLEU:SPELL_DAMAGE, CLEU:SPELL_MISSED, CLEU:SPELL_ENERGIZE, XEPHUI_CRUSADING_STRIKES
function f(states, event, ...)
    local hasChanges = false

    if states[1] == nil then
        local nextValue = aura_env.getHolyPower()
        local transparent = nextValue < 3

        for i = 1, 5 do
            local value = nextValue >= i and 1 or 0

            states[i] = {
                show = true,
                index = i,
                progressType = "static",
                value = value,
                total = 1,
                changed = true,
                transparent = transparent,
                power = nextValue
            }
        end

        hasChanges = true
    end

    if event == "UNIT_POWER_UPDATE" then
        local unit, powerType = ...

        if unit ~= "player" or powerType ~= "HOLY_POWER" then
            return false
        end

        local nextValue = aura_env.getHolyPower()

        if nextValue == aura_env.currentHolyPower then
            return false
        end

        local transparent = nextValue < 3

        local progressData = {
            duration = nil,
            expirationTime = nil,
            index = nil
        }

        for i = 1, 5 do
            if states[i].progressType == "timed" then
                progressData.expirationTime = states[i].expirationTime
                progressData.duration = states[i].duration

                if nextValue < aura_env.currentHolyPower then
                    progressData.index = nextValue + 1
                else
                    progressData.index = i == 5 and 5 or nextValue + 1
                end

                states[i].progressType = "static"
                states[i].duration = nil
                states[i].expirationTime = nil
                states[i].changed = true
                states[i].value = nextValue >= i and 1 or 0
                states[i].total = 1
                states[i].inverse = false

                hasChanges = true
                break
            end
        end

        for i = 1, 5 do
            local individualStackChanged = false
            local value = nextValue >= i and 1 or 0

            if states[i].transparent ~= transparent then
                individualStackChanged = true
                states[i].transparent = transparent
            end

            if states[i].value ~= value then
                individualStackChanged = true
                states[i].value = value
            end

            if states[i].power ~= nextValue then
                individualStackChanged = true
                states[i].power = nextValue
            end

            if progressData.index == i then
                individualStackChanged = true
                states[i].progressType = "timed"
                states[i].duration = progressData.duration
                states[i].expirationTime = progressData.expirationTime
                states[i].inverse = true
                states[i].paused = false
            end

            states[i].changed = individualStackChanged

            if individualStackChanged then
                hasChanges = true
            end
        end

        aura_env.currentHolyPower = nextValue

        return hasChanges
    end

    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local timestamp, _, _, sourceGUID, _, _, _, _, _, _, _, spellId = ...

        if sourceGUID ~= WeakAuras.myGUID then
            return false
        end

        if spellId == 406834 then
            aura_env.ignoreNextCrusadingStrike = false

            return false
        end

        if spellId == 408385 then
            if timestamp == aura_env.lastCrusadingStrikesDamage then
                return false
            end

            if aura_env.ignoreNextCrusadingStrike then
                aura_env.cancelTimer()

                for i = 1, 5 do
                    if states[i].progressType == "timed" then
                        local swingTimer = aura_env.getAttackSpeed()

                        states[i].changed = true
                        states[i].paused = false
                        states[i].expirationTime = GetTime() + swingTimer

                        return true
                    end
                end

                return false
            end

            aura_env.ignoreNextCrusadingStrike = true
            aura_env.lastCrusadingStrikesDamage = timestamp

            for i = 1, 5 do
                if states[i].value == 0 then
                    local swingTimer = aura_env.getAttackSpeed()
                    local duration = swingTimer * 2

                    states[i].changed = true
                    states[i].progressType = "timed"
                    states[i].duration = duration
                    states[i].expirationTime = GetTime() + duration
                    states[i].value = nil
                    states[i].total = nil
                    states[i].inverse = true

                    aura_env.queue(swingTimer)

                    hasChanges = true
                    break
                end
            end

            return hasChanges
        end

        return false
    end

    if event == aura_env.customEventName then
        local id = ...

        if id ~= aura_env.id then
            return false
        end

        for i = 1, 5 do
            if states[i].progressType == "timed" then
                states[i].changed = true
                states[i].paused = true
                states[i].remaining = aura_env.getAttackSpeed()

                return true
            end
        end
    end

    return hasChanges
end
