function f(_, unitId, unitFrame, _, modTable)
	-- when updating this, also update Init and Nameplate Updated

	if not modTable.config.scale then
		return
	end

	local npcID = unitFrame.namePlateNpcId or modTable.parseGUID(unitId)

	if not npcID or not modTable.isSpitefulLike(npcID) then
		return
	end

	Plater.SetNameplateScale(
		unitFrame,
		modTable.targetsPlayer(unitId) and modTable.config.higherScale or modTable.config.extraLowScale
	)
end
