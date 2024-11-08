function f(_, unitId, unitFrame, _, modTable)
	-- do nothing while spiteful is disabled
	-- when updating this, also update Init and Leave Combat

	if not modTable.config.scale then
		return
	end

	local npcID = unitFrame.namePlateNpcId or modTable.parseGUID(unitId)

	if not npcID or not modTable.isSpiteful(npcID) then
		return
	end

	Plater.SetNameplateScale(
		unitFrame,
		modTable.spitefulTargetsPlayer(unitId) and modTable.config.higherScale or modTable.config.extraLowScale
	)
end
