aura_env.isAugvoker = false
aura_env.lastUpdate = nil
aura_env.total = 0
aura_env.nextFrame = nil
aura_env.customEventName = "XEPHUI_BREATH_OF_EONS"

aura_env.determineSpec = function()
    local specIndex = GetSpecialization()

    if not specIndex then
        aura_env.isAugvoker = false
        return
    end

    local currentSpecId = GetSpecializationInfo(specIndex)

    aura_env.isAugvoker = currentSpecId == 1473
end

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