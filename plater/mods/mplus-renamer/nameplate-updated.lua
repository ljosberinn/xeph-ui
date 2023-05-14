function (self, unitId, unitFrame, envTable)
    -- @unitId  unitID for mob e.g nameplate1
    -- @marker Raid Target ID
    -- @nameColouring Enables text to be coloured by raid marker 
    -- @isBoss Boolean for enabling this on boss mobs
    -- @debugMode Test mode for using dummy's
    -- @debugEntry Which hook it came from
    -- Catch all 
    envTable.namer(unitId, GetRaidTargetIndex(unitId), false, false, false, "Updated")
    
end


