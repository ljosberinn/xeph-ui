function f(self, unitId, unitFrame, envTable, modTable)
	-- Get players current talent specialization
	envTable.spec = GetSpecialization()

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

	-- Get the primary interrupt ID of the players current class/spec.
	-- All non-warlock classes have straight forward primary interrupt skills.
	if envTable.class ~= 9 then
		envTable.interruptID = modTable.primaryInterrupts[envTable.class][envTable.spec]
	else
		-- Warlock interrupt changes based on pet being used.
		envTable.interruptID = envTable.GetWarlockInterrupt()
	end

	envTable.EnhancedCastBar(unitId, unitFrame.castBar)
end
