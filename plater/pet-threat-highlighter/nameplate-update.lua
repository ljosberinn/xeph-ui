function f(self, unitId, unitFrame, envTable)
	if self.InCombat and not self.namePlateThreatIsTanking and not UnitIsTapDenied(unitId) then
		local exists = UnitExists(self.targetUnitID)
		if exists then
			local isTank = UnitGroupRolesAssigned(self.targetUnitID) == "TANK"

			if not isTank then
				local guid = UnitGUID(self.targetUnitID)
				if envTable.shallHighlight(guid) then
					Plater.SetNameplateColor(unitFrame, envTable.color)
				end
			end
		end
	end
end
