function f(self, unitId, unitFrame, envTable)
	local inCombat = self.InCombat
	local isTanking = self.namePlateThreatIsTanking
	local isTapDenied = UnitIsTapDenied(unitId)

	if inCombat and not isTanking and not isTapDenied then
		local exists = UnitExists(self.targetUnitID)
		if exists then
			local role = UnitGroupRolesAssigned(self.targetUnitID)
			local isTank = (role == "TANK")

			if not isTank then
				local guid = UnitGUID(self.targetUnitID)
				if envTable.shallHighlight(self, guid) then
					Plater.SetNameplateColor(unitFrame, envTable.color)
				end
			end
		end
	end
end
