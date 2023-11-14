aura_env.customEventName = "XEPHUI_EMERALD_TRANCE"
aura_env.emeraldTranecBuffId = 424402

aura_env.timer = nil
aura_env.iterations = 0
aura_env.currentIteration = 0

aura_env.queue = function()
    if aura_env.timer then
        return
    end

    aura_env.timer = C_Timer.NewTimer(5, function()
        WeakAuras.ScanEvents(aura_env.customEventName, aura_env.id)
    end)
end