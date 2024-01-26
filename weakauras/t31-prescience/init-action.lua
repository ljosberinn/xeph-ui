aura_env.active = false
aura_env.customEventName = "XEPHUI_PRESCIENCE_T31"

do
    local equipped = 0

    local items = {
        207225, -- shoulder
        207226, -- legs
        207227, -- head
        207228, -- gloves
        207230 -- chest
    }

    for _, id in pairs(items) do
        if IsEquippedItem(id) then
            equipped = equipped + 1
        end
    end

    aura_env.active = equipped >= 2
end

aura_env.timer = nil
--- @param unit string
--- @param count number
aura_env.queue = function(unit, count)
    if count == 6 then
        return
    end

    if aura_env.timer and not aura_env.timer:IsCancelled() then
        aura_env.timer:Cancel()
    end

    aura_env.timer =
        C_Timer.After(
        0.33,
        function()
            WeakAuras.ScanEvents(aura_env.customEventName, aura_env.id, unit, count)
        end
    )
end

--- @param states table<"", T31_PrescienceState>
--- @param duration number
aura_env.performUpdate = function(states, duration)
    if not states[""] then
        states[""] = {
            stacks = 0,
            show = true,
            changed = true,
            autoHide = false,
            progressType = "static"
        }
    end

    states[""].stacks = duration > 30 and 0 or states[""].stacks + 1
    states[""].changed = true
end
