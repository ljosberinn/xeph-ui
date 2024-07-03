aura_env.lastUpdate = nil
aura_env.critical = false
aura_env.total = 0
aura_env.nextFrame = nil
aura_env.customEventName = "XEPHUI_BEACON"

aura_env.queue = function()
    if aura_env.nextFrame then
        return
    end
    
    aura_env.nextFrame =
    C_Timer.NewTimer(
        0,
        function()
            WeakAuras.ScanEvents(aura_env.customEventName, aura_env.id)
        end
    )
end