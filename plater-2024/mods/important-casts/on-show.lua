function f(self, unitId, unitFrame, envTable, scriptTable)
	envTable.dotAnimation = Plater.PlayDotAnimation(
		unitFrame.castBar,
		5,
		scriptTable.config.dotColor,
		scriptTable.config.xOffset,
		scriptTable.config.yOffset
	)

	envTable.BackgroundFlash:Play()

	Plater.FlashNameplateBorder(unitFrame, 0.05)
	Plater.FlashNameplateBody(unitFrame, "", 0.075)

	unitFrame:PlayFrameShake(envTable.FrameShake)

	Plater.SetCastBarColorForScript(self, scriptTable.config.useCastbarColor, scriptTable.config.castBarColor, envTable)

	--Dominator on Shadowmoon Burial Grounds
	if envTable._SpellID == 154327 then
		if UnitHealth(unitId) == UnitHealthMax(unitId) then
			if envTable._Duration == 604800 then
				Plater.SetCastBarColorForScript(self, scriptTable.config.useCastbarColor, { 1, 0, 0, 1 }, envTable)
			end
		end
	end
end
