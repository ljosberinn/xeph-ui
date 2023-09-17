-- UNIT_POWER_UPDATE:player, UNIT_SPELLCAST_CHANNEL_START:player, UNIT_SPELLCAST_CHANNEL_STOP:player, CLEU:SPELL_EMPOWER_START, CLEU:SPELL_EMPOWER_INTERRUPT, CLEU:SPELL_EMPOWER_END, CLEU:SPELL_CAST_START, CLEU:SPELL_CAST_SUCCESS, CLEU:SPELL_CAST_FAILED, PLAYER_DEAD
--- @class State
--- @field show boolean
--- @field changed boolean
--- @field name string
--- @field icon number
--- @field progressType "timed"
--- @field duration number
--- @field expirationTime number
--- @field autoHide true
--- @field spellId number
--- @field paused boolean
--- @field start number
--- @field desaturated boolean
--- @field interrupted boolean
--- @field specialNumber number
--- @field isPet boolean
--- @field remaining number | nil

--- @param states table<number, State>
--- @param event "STATUS" | "OPTIONS" | "COMBAT_LOG_EVENT_UNFILTERED" | "UNIT_POWER_UPDATE" | "UNIT_SPELLCAST_CHANNEL_START" | "UNIT_SPELLCAST_CHANNEL_STOP" | "PLAYER_DEAD"
--- @return boolean
function (states, event, ...)
    if event == "PLAYER_DEAD" then
        local hasChanges = false
        local now = GetTime()

        for _, state in pairs(states) do
            if state.paused then
                hasChanges = true
                state.paused = false
                state.changed = true
                state.desaturated = false
                state.remaining = now - state.start
            end
        end

        return hasChanges
    end

    if event == "UNIT_SPELLCAST_CHANNEL_START" then
        local unit, _, spellId = ...

        if unit ~= "player" or not spellId then
            return false
        end

        for _, state in pairs(states) do
            -- pause everything that isn't already paused
            if state then
                if not state.paused then
                    state.paused = true
                    state.changed = true
                end

                -- chain channeling by eg skipping ticks of Disintegrate leaves the previous cast still desaturated, so correct this here
                if state.desaturated then
                    state.desaturated = false
                    state.changed = true
                end
            end
        end

        local _, _, _, channelStartTime, channelEndTime = UnitChannelInfo("player")
        local castTime = channelEndTime - channelStartTime
        local castTimeInSeconds = castTime / 1000
        local name, _, icon = GetSpellInfo(spellId)

        local now = GetTime()
        local duration = aura_env.config.general.duration + castTimeInSeconds

        states[aura_env.spellcasts] = {
            show = true,
            changed = true,
            name = name,
            icon = icon,
            progressType = "timed",
            duration = duration,
            expirationTime = now + duration,
            autoHide = true,
            spellId = spellId,
            paused = true,
            start = now,
            desaturated = true,
            specialNumber = 0,
            interrupted = false
        }

        aura_env.spellcasts = aura_env.spellcasts + 1

        return true
    end

    if event == "UNIT_SPELLCAST_CHANNEL_STOP" then
        local unit, _, spellId = ...

        if unit ~= "player" or not spellId then
            return false
        end

        local previousCast = states[aura_env.spellcasts - 1]

        if not previousCast then
            return false
        end

        previousCast.changed = true
        previousCast.paused = false
        previousCast.desaturated = false
        -- initial duration is based on max channel, but we don't always fully channel
        previousCast.duration = aura_env.config.general.duration + GetTime() - previousCast.start
        previousCast.expirationTime = previousCast.start + previousCast.duration

        return true
    end

    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local _, subEvent, _, sourceGUID, _, _, _, _, _, _, _, spellId, _, _, stage = ...
        --- @cast subEvent "SPELL_EMPOWER_START" | "SPELL_EMPOWER_INTERRUPT" | "SPELL_EMPOWER_END" | "SPELL_CAST_START" | "SPELL_CAST_SUCCESS" | "SPELL_CAST_FAILED"
        --- @cast sourceGUID string
        --- @cast spellId number
        --- @cast stage number

        if not subEvent or aura_env.ignorelist[spellId] ~= nil or not aura_env.isBasicallyMe(sourceGUID) then
            return false
        end


        if subEvent == "SPELL_CAST_START" then
            local now = GetTime()
            local name, _, icon, castTime = GetSpellInfo(spellId)
            local paused = false

            if castTime == 0 then
                local _, _, _, channelStartTime, channelEndTime = UnitChannelInfo("player")

                if channelStartTime ~= nil then
                    castTime = channelEndTime - channelStartTime
                end
            end

            local castTimeInSeconds = castTime / 1000
            local duration = aura_env.config.general.duration + castTimeInSeconds

            if castTime > 0 then
                paused = true

                for _, state in pairs(states) do
                    -- pause everything that isn't already paused
                    if state then
                        if not state.paused then
                            state.paused = true
                            state.changed = true
                        end

                        -- chain channeling by eg skipping ticks of Disintegrate leaves the previous cast still desaturated, so correct this here
                        if state.desaturated then
                            state.desaturated = false
                            state.changed = true
                        end
                    end
                end
            end

            states[aura_env.spellcasts] = {
                show = true,
                changed = true,
                name = name,
                icon = icon,
                progressType = "timed",
                duration = duration,
                expirationTime = now + duration,
                autoHide = true,
                spellId = spellId,
                paused = paused,
                start = now,
                desaturated = paused,
                specialNumber = 0,
                interrupted = false,
                isPet = aura_env.isPet(sourceGUID),
            }

            aura_env.spellcasts = aura_env.spellcasts + 1

            return true
        end

        if subEvent == "SPELL_CAST_SUCCESS" then
            local name, _, icon, castTime = GetSpellInfo(spellId)

            if castTime > 0 then
                local now = GetTime()
                local hasChanges = false

                local previousIndex = aura_env.spellcasts - 1
                local previousCast = states[previousIndex]

                -- revert marking item use as interrupted when trying to use an
                -- item that was already being casted
                if previousCast and previousCast.spellId == spellId and previousCast.interrupted then
                    hasChanges = true
                    previousCast.interrupted = false
                    previousCast.changed = true
                end

                -- unpause everything paused
                for _, state in pairs(states) do
                    if state.paused then
                        hasChanges = true
                        state.paused = false
                        state.changed = true
                        state.desaturated = false
                        state.remaining = now - state.start
                    end
                end

                return hasChanges
            end

            local _, _, _, channelStartTime = UnitChannelInfo("player")

            -- channels are handled separately due to sending SPELL_CAST_SUCCESS at channel start
            if channelStartTime ~= nil then
                return false
            end

            local now = GetTime()

            -- unpause everything paused
            for _, state in pairs(states) do
                if state.paused then
                    state.paused = false
                    state.changed = true
                    state.desaturated = false
                    state.remaining = now - state.start
                end
            end

            local specialNumber = 0

            if aura_env.isRogue and aura_env.attachComboPointsToNext then
                specialNumber = aura_env.lastComboPoints
                aura_env.attachComboPointsToNext = false
            end

            states[aura_env.spellcasts] = {
                show = true,
                changed = true,
                name = name,
                icon = icon,
                progressType = "timed",
                duration = aura_env.config.general.duration,
                expirationTime = now + aura_env.config.general.duration,
                autoHide = true,
                spellId = spellId,
                paused = false,
                start = now,
                desaturated = false,
                specialNumber = specialNumber,
                interrupted = false,
                isPet = aura_env.isPet(sourceGUID),
            }

            aura_env.spellcasts = aura_env.spellcasts + 1

            return true
        end

        if subEvent == "SPELL_CAST_FAILED" then
            local previousIndex = aura_env.spellcasts - 1
            local previousCast = states[previousIndex]

            if not previousCast or not previousCast.paused then
                return false
            end

            -- ignore spamcasting an ability you currently cannot cast
            -- for whichever reason (already casting, cd, range, line of sight, missing resources)
            if previousCast.spellId ~= spellId then
                return false
            end

            local now = GetTime()

            -- ignore spamming buttons but be sensible enough about instant aborts
            if now - previousCast.start < 0.05 then
                return false
            end

            local _, _, _, channelStartTime, _, _, _, channelSpellId = UnitChannelInfo("player")

            -- ignore spamming channels. why would you anyways?
            if channelStartTime ~= nil and channelSpellId == spellId then
                return false
            end

            local hasChanges = false

            -- unpause everything paused
            for index, state in pairs(states) do
                if state.paused then
                    hasChanges = true
                    state.paused = false
                    state.changed = true
                    state.desaturated = false
                    state.remaining = now - state.start

                    if index == previousIndex then
                        state.interrupted = true
                    end
                end
            end

            return hasChanges
        end

        if subEvent == "SPELL_EMPOWER_START" then
            local now = GetTime()
            local _, _, _, channelStartTime, channelEndTime = UnitChannelInfo("player")
            local name, _, icon = GetSpellInfo(spellId)
            local castTimeInSeconds = (channelEndTime - channelStartTime) / 1000
            local duration = aura_env.config.general.duration + castTimeInSeconds

            states[aura_env.spellcasts] = {
                show = true,
                changed = true,
                name = name,
                icon = icon,
                progressType = "timed",
                duration = duration,
                expirationTime = now + duration,
                autoHide = true,
                spellId = spellId,
                paused = true,
                start = now,
                desaturated = true,
                specialNumber = 0,
                interrupted = false,
                isPet = aura_env.isPet(sourceGUID),
            }

            aura_env.spellcasts = aura_env.spellcasts + 1

            return true
        end

        if subEvent == "SPELL_EMPOWER_INTERRUPT" then
            local previousCast = states[aura_env.spellcasts - 1]

            if not previousCast then
                return false
            end

            previousCast.changed = true
            previousCast.interrupted = true

            return true
        end

        if subEvent == "SPELL_EMPOWER_END" then
            local previousCast = states[aura_env.spellcasts - 1]

            if not previousCast then
                return false
            end

            previousCast.changed = true
            previousCast.paused = false
            previousCast.desaturated = false
            previousCast.specialNumber = stage
            -- initial duration is based on max channel, but we don't always fully empower
            previousCast.duration = aura_env.config.general.duration + GetTime() - previousCast.start
            previousCast.expirationTime = previousCast.start + previousCast.duration

            return true
        end

        return false
    end

    if event == "UNIT_POWER_UPDATE" then
        if not aura_env.isRogue then
            return false
        end

        local unit, powerType = ...

        if unit ~= "player" or powerType ~= "COMBO_POINTS" then
            return false
        end

        local next = aura_env.getComboPoints()

        if next == aura_env.currentComboPoints then
            return false
        end

        aura_env.lastComboPoints = aura_env.currentComboPoints
        aura_env.currentComboPoints = next
        aura_env.attachComboPointsToNext = aura_env.currentComboPoints < aura_env.lastComboPoints

        return false
    end

    return false
end
