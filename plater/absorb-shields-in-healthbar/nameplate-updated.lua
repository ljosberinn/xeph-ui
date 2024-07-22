function f(self, unitId, unitFrame, envTable)
	local hb = unitFrame.healthBar
	if hb.customShieldHookNeedsUpdate and hb.displayedUnit then
		hb:UNIT_MAXHEALTH()
		hb.customShieldHookNeedsUpdate = false
	end
end
