aura_env.active = false

do
    local equipped = 0

    local items = {
        207225, -- shoulder
        207226, -- legs
        207227, -- head
        207228, -- gloves
        207230 -- chest
    }

    for _, id in pairs(items) do
        if IsEquippedItem(id) then
            equipped = equipped + 1
        end
    end

    aura_env.active = equipped >= 2
end