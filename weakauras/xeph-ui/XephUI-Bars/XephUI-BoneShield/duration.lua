function ()
    local _, _, count = WA_GetUnitBuff("player", 195181);
    
    if count == nil then
        return 0, 10, true
    end
    
    return count, 10, true
end

