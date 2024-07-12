function f(self, unitId, unitFrame, envTable, modTable)
	local npcID = unitFrame.namePlateNpcId or modTable.parseGUID(unitId)

	if not npcID then
		return
	end

	local prio = modTable["npcIDs"][npcID]

	if not prio then
		return
	end

	local targetScale = modTable.getScale(prio)

	if targetScale then
		Plater.SetNameplateScale(unitFrame, targetScale)
	end
end
