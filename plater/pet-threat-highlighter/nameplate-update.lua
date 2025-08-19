function f(self, unitId, unitFrame, envTable)
	if
		not self.InCombat
		or self.namePlateThreatIsTanking
		or not self.targetUnitID
		or UnitIsTapDenied(unitId)
		or not UnitExists(self.targetUnitID)
		or UnitGroupRolesAssigned(self.targetUnitID) == "TANK"
		or UnitIsPlayer(self.targetUnitID)
	then
		return
	end

	local guid = UnitGUID(self.targetUnitID)
	if envTable.shallHighlight(guid) then
		Plater.SetNameplateColor(unitFrame, envTable.color)
	end
end
