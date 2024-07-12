function f(self, unitId, unitFrame, envTable, modTable)
	-- Flashing nameplate options
	envTable.optionsHideFlashSolo = modTable.config.hideNameplateFlashSolo
	envTable.optionsNameplateFlash = modTable.config.nameplateFlash
	envTable.optionsHideFlashAsTank = modTable.config.hideFlashAsTank

	-- Target name options
	envTable.optionsShowTargetName = modTable.config.showTargetName
	envTable.optionsReplaceMyName = modTable.config.replaceName
	envTable.optionsHideNameSolo = modTable.config.hideNameSolo
	envTable.optionsCastNameSize = modTable.config.castNameSize

	-- Cast bar interrupt coloring
	envTable.optionsShowInterruptColor = modTable.config.showInterruptColor
	envTable.optionsShowSecondaryInterrupts = modTable.config.showSecondaryInterrupts
	envTable.optionsColorNoInterrupt = modTable.config.colorNoInterrupt
	envTable.optionsColorInterruptAvailable = modTable.config.colorInterruptAvailable
	envTable.optionsColorInterruptSoon = modTable.config.colorInterruptSoon
	envTable.optionsColorSecondaryAvailable = modTable.config.colorSecondaryInterrupt
	envTable.optionsColorProtected = modTable.config.colorProtected
	envTable.optionsColorTick = modTable.config.colorTick

	envTable.interruptID = envTable.GetInterruptId()

	envTable.EnhancedCastBar(unitId, unitFrame.castBar)
end
