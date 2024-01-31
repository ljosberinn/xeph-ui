--- @return number
function aura_env.getHolyPower()
    return UnitPower("player", Enum.PowerType.HolyPower)
end

aura_env.currentHolyPower = aura_env.getHolyPower()
aura_env.lastCrusadingStrikesDamage = nil
aura_env.ignoreNextCrusadingStrike = false

aura_env.customEventName = "XEPHUI_CRUSADING_STRIKES"

--- @type cbObject|nil
aura_env.timer = nil

--- @param time number
function aura_env.queue(time)
    aura_env.timer =
        C_Timer.NewTimer(
        time + 0.1,
        function()
            WeakAuras.ScanEvents(aura_env.customEventName, aura_env.id)
        end
    )
end

function aura_env.getAttackSpeed()
    return UnitAttackSpeed("player")
end

function aura_env.cancelTimer()
    if aura_env.timer and not aura_env.timer:IsCancelled() then
        aura_env.timer:Cancel()
        aura_env.timer = nil
    end
end
