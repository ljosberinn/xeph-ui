function f(self, unitId, unitFrame, envTable, modTable)
	if not modTable.config.scale then
		return
	end

	local npcID = unitFrame.namePlateNpcId or modTable.parseGUID(unitId)

	if not npcID then
		return
	end

	local scale = modTable.npcIDs[npcID]

	if scale and scale ~= unitFrame.nameplateScaleAdjust then
		Plater.SetNameplateScale(unitFrame, scale)
	end
end
