-- UNIT_ABSORB_AMOUNT_CHANGED:player, UNIT_MAXHEALTH:player
--- @param event "UNIT_ABSORB_AMOUNT_CHANGED" | "UNIT_MAXHEALTH"
--- @return boolean
function (states, event, ...)
    if event ~= "UNIT_ABSORB_AMOUNT_CHANGED" and event ~= "UNIT_MAXHEALTH" then
        return false
    end

    local totalAbsorb = aura_env.getTotalAbsorb()
    local maxHealth = aura_env.getMaxHealth()

    if not states[""] then
        states[""] = {
            changed = true,
            show = false,
            stacks = totalAbsorb,
            autoHide = true,
            progressType = "static",
            maxHealth = maxHealth
        }
    end

    if totalAbsorb == states[""].stacks and maxHealth == states[""].maxHealth then
        return false
    end

    local ratio = totalAbsorb / maxHealth

    states[""].stacks = totalAbsorb
    states[""].maxHealth = maxHealth
    states[""].ratio = (ratio) * 100
    states[""].changed = true
    states[""].show = ratio >= aura_env.ratio

    return true
end
