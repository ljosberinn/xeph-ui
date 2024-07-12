function f(self, unitId, unitFrame, envTable)
	Plater.StopDotAnimation(unitFrame.healthBar, unitFrame.healthBar.MainTargetDotAnimation)
	envTable.FixateTarget:Hide()
end
