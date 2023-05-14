function (self, unitId, unitFrame, envTable, modTable)        
    if not modTable.config.scale then 
        return
    end
    
    local npcID = unitFrame.namePlateNpcId or  modTable.parseGUID(unitId)
    
    if npcID and modTable.isSpiteful(npcID)  then
        Plater.SetNameplateScale(
            unitFrame,
            modTable.spitefulTargetsPlayer(unitId) and 1.1 or 0.7
        )
    end    
end

