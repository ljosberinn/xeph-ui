--- @class SoulShardState
--- @field show boolean
--- @field changed boolean
--- @field value number
--- @field formattedShards number
--- @field duration number | nil
--- @field expirationTime number | nil
--- @field autoHide false
--- @field progressType "static"

--- @param states table<number, SoulShardState>
--- @param event "OPTIONS" | "STATUS" | "UNIT_POWER_UPDATE"
--- @return boolean
function (states, event, ...)
    if not states[1] then
        local maxPower = UnitPowerMax("player", Enum.PowerType.SoulShards, true)
        local power = UnitPower("player", Enum.PowerType.SoulShards, true)

        for i = 1, 5 do
            local value = 0
            local maxPowerForThisShard = i * 10
            local progressType = "static"

            if maxPowerForThisShard <= power then
                value = 10
            elseif maxPower - power < 10 then
                value = maxPowerForThisShard - power
            end

            states[i] = {
                show = true,
                changed = true,
                autoHide = false,
                progressType = progressType,
                total = 10,
                value = value,
                formattedShards = power / 10,
            }
        end

        return true
    end

    if event == "UNIT_POWER_UPDATE" then
        local _, powerType = ...

        if powerType ~= "SOUL_SHARDS" then
            return false
        end

        local power = UnitPower("player", Enum.PowerType.SoulShards, true)
        local formattedPower = power / 10

        if formattedPower == states[1].formattedShards then
            return false
        end

        for i = 1, 5 do
            local maxPowerForThisShard = i * 10
            states[i].changed = true -- sadly have to always update this for recoloring condition
            states[i].formattedShards = formattedPower

            if power >= maxPowerForThisShard then
                states[i].value = 10
            elseif power + 10 > maxPowerForThisShard then -- increase
                states[i].value = power % 10
            elseif states[i].value > 0 and power <= maxPowerForThisShard - 10 then -- decrease
                states[i].value = 0
            end
        end

        return true
    end

    return false
end
