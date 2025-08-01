function f(_, unitId, unitFrame, _, modTable)
	-- when updating this, also update Init and Nameplate Updated

	if not modTable.isActive then
		return
	end

	local npcID = unitFrame.namePlateNpcId or modTable.parseGUID(unitId)

	if not npcID or not modTable.isSpitefulLike(npcID) then
		return
	end

	local specialScale = modTable.getSpitefulLikeScale(npcID)

	Plater.SetNameplateScale(unitFrame, modTable.targetsPlayer(unitId) and specialScale.self or specialScale.others)
end
