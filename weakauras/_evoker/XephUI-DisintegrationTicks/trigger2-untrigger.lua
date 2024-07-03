-- UNIT_SPELLCAST_CHANNEL_START:player UNIT_SPELLCAST_CHANNEL_UPDATE:player UNIT_SPELLCAST_CHANNEL_STOP:player
function (event, _, _, spellId)
    if spellId ~= aura_env.disintegrate or event ~= "UNIT_SPELLCAST_CHANNEL_STOP" then
        return
    end

    aura_env.untrigger()
end
