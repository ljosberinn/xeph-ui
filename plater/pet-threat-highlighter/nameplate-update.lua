function f(self, unitId, unitFrame, envTable)
	if not self.InCombat then
		return
	end

	if self.namePlateThreatIsTanking then
		return
	end

	if UnitIsTapDenied(unitId) then
		return
	end

	local exists = UnitExists(self.targetUnitID)

	if not exists then
		return
	end

	local isTank = UnitGroupRolesAssigned(self.targetUnitID) == "TANK"

	if isTank then
		return
	end

	if UnitIsPlayer(self.targetUnitID) then
		return
	end

	local guid = UnitGUID(self.targetUnitID)
	if envTable.shallHighlight(guid) then
		Plater.SetNameplateColor(unitFrame, envTable.color)
	end
end
