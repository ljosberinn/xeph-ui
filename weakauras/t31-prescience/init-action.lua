aura_env.active = false
aura_env.customEventName = "XEPHUI_PRESCIENCE_T31"

--- @return boolean
function aura_env.checkGear()
    local function hasAtLeastTwoEquipped(tbl)
        local equipped = 0

        for _, id in pairs(tbl) do
            if C_Item.IsEquippedItem(id) then
                equipped = equipped + 1

                if equipped == 2 then
                    return true
                end
            end
        end

        return false
    end

    local awakened = {
        217176, -- chest
        217177, -- gloves
        217178, -- head
        217179, -- legs
        217180 -- shoulders
    }

    if hasAtLeastTwoEquipped(awakened) then
        return true
    end

    local amirdrassil = {
        207225, -- shoulder
        207226, -- legs
        207227, -- head
        207228, -- gloves
        207230 -- chest
    }

    return hasAtLeastTwoEquipped(amirdrassil)
end

aura_env.timer = nil
--- @param unit string
--- @param count number
function aura_env.queue(unit, count)
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
function aura_env.performUpdate(states, duration)
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

function aura_env.reset(states)
    if states[""] ~= nil and states[""].stacks > 0 then
        states[""].changed = true
        states[""].stacks = 0
        states[""].show = false
    end
end
