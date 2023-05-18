-- UNIT_AURA:player, UNIT_SPELLCAST_SUCCEEDED:player
function (event, unit, _, spellId)
    if event == "UNIT_AURA" and unit == "player" then
        aura_env.onPlayerAuraUpdate()
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" and unit == "player" then
        aura_env.onPlayerSpellCastSuccess(spellId)
    end

    return true
end
