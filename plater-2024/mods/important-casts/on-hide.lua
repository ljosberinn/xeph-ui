function f(self, unitId, unitFrame, envTable, scriptTable)
	Plater.StopDotAnimation(unitFrame.castBar, envTable.dotAnimation)

	envTable.BackgroundFlash:Stop()

	unitFrame:StopFrameShake(envTable.FrameShake)
end
