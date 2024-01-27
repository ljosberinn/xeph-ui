aura_env.lastUpdate = nil
aura_env.total = 0
aura_env.nextFrame = nil
aura_env.customEventName = "XEPHUI_FYRALATH"

--- intentionally ignoring mark (414532)
--- @param id number
--- @return boolean
function aura_env.isFyralathDamageId(id)
    return id == 424094 or id == 417134 or id == 413584
end

function aura_env.queue()
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
