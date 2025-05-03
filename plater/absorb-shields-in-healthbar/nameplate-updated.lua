function f(self, unitId, unitFrame, envTable)
	if unitFrame.healthBar.customShieldHookNeedsUpdate and unitFrame.healthBar.displayedUnit then
		unitFrame.healthBar:UNIT_MAXHEALTH()
		unitFrame.healthBar.customShieldHookNeedsUpdate = false
	end
end
