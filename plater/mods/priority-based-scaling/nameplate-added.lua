function (self, unitId, unitFrame, envTable, modTable)
    local npcID = unitFrame.namePlateNpcId or  modTable.parseGUID(unitId)
    
    if npcID then        
        local prio = modTable["npcIDs"][npcID]
        
        if prio then
            local targetScale = modTable.getScale(prio)
            local targetColor = modTable.getColor(prio)
            
            if targetScale then
                Plater.SetNameplateScale(unitFrame, targetScale)
            end
            
            if targetColor then
                Plater.SetNameplateColor (unitFrame, targetColor)
            end
        end
    end
end

