-- CLEU:SPELL_DAMAGE, XEPHUI_FYRALATH, UNIT_SPELLCAST_SUCCEEDED:player
--- @class FyralathHighlighter
--- @field show boolean
--- @field changed boolean
--- @field stacks number
--- @field duration number
--- @field expirationTime number
--- @field autoHide boolean
--- @field progressType "timed"
--- @field icon number

--- @param states table<number, FyralathHighlighter>
--- @param event "STATUS" | "OPTIONS" | "COMBAT_LOG_EVENT_UNFILTERED" | "XEPHUI_BEACON" | "UNIT_SPELLCAST_SUCCEEDED"
--- @return boolean
function (states, event, ...)
    if not states[""] then
        states[""] = {
            stacks = 0,
            show = false,
            changed = true,
            progressType = "timed",
            icon = 5205711,
            duration = 5,
            expirationTime = 0,
            autoHide = true
        }

        return false
    end

    if event == "UNIT_SPELLCAST_SUCCEEDED" then
        if aura_env.total == 0 then
            return false
        end

        local now = GetTime()

        if now - aura_env.lastUpdate < 5 then
            return false
        end

        if aura_env.config.chatEnabled and IsInInstance() then
            pcall(function()
                SendChatMessage("|cffff8000|Hitem:206448::::::::70:::::|h[Fyr'alath the Dreamrender]|h|r hit for " .. AbbreviateLargeNumbers(aura_env.total), "SAY")
            end)
        end

        aura_env.total = 0
        states[""].stacks = 0
        states[""].expirationTime = now
        states[""].changed = true
        states[""].show = false

        return true
    end

    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local _, subEvent, _, sourceGUID, _, _, _, _, _, _, _, spellId, _, _, amount, _, _, _, _, absorbed, critical = ...

        if subEvent ~= "SPELL_DAMAGE" or not aura_env.isFyralathDamageId(spellId) or sourceGUID ~= WeakAuras.myGUID then
            return false
        end

        local total = amount + (absorbed or 0)

        if total == 0 then
            return false
        end

        aura_env.total = aura_env.total + total
        aura_env.lastUpdate = GetTime()
        aura_env.queue()

        return false
    end

    if event ~= aura_env.customEventName then
        return false
    end

    local id = ...

    if id ~= aura_env.id then
        return false
    end

    aura_env.nextFrame = nil

    states[""].stacks = aura_env.total
    states[""].changed = true
    states[""].show = true
    states[""].expirationTime = GetTime() + 5
    states[""].duration = 5

    return true
end