function f(_, unitId, unitFrame, _, modTable)
	-- when updating this, also update Init and Leave Combat

	if not modTable.config.scale then
		return
	end

	local npcID = unitFrame.namePlateNpcId or modTable.parseGUID(unitId)

	if not npcID or not modTable.isSpitefulLike(npcID) then
		return
	end

	local specialScale = modTable.getSpitefulLikeScale(npcID)
	local scale = modTable.targetsPlayer(unitId) and specialScale.self or specialScale.others

	if scale ~= unitFrame.nameplateScaleAdjust then
		Plater.SetNameplateScale(unitFrame, scale)
	end
end
