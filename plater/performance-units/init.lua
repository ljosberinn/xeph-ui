function f(modTable)
	if not Plater.AddPerformanceUnits or not Plater.PERF_UNIT_OVERRIDES_BIT then
		return
	end

	local castDisabled = Plater.PERF_UNIT_OVERRIDES_BIT.CAST
	local auraDisabled = Plater.PERF_UNIT_OVERRIDES_BIT.AURA
	local threatDisabled = Plater.PERF_UNIT_OVERRIDES_BIT.THREAT
	local allDisabled = 0

	-- local castAndAuraDisabled = bit.bor(castDisabled, auraDisabled)

	local units = {
		-- Raids
		[189706] = { enabled = true, flag = 0 }, -- Chaotic Essence
		[189707] = { enabled = true, flag = 0 }, -- Chaotic mote
		[176920] = { enabled = true, flag = 0 }, -- Domination Arrow -- Sylv
		[196679] = { enabled = true, flag = 0 }, -- Frozen Shroud -- Broodkeeper
		[194999] = { enabled = true, flag = 0 }, -- Volatile Spark -- Raszageth
		[191714] = { enabled = true, flag = 0 }, -- Seeking Stormling -- Raszageth
		[210231] = { enabled = true, flag = 0 }, -- Tainted Lasher -- Gnarlroot
		[211306] = { enabled = true, flag = 0 }, -- Fiery vines -- Tindral
		[219746] = { enabled = true, flag = 0 }, -- Tomb - Ansurek
	}

	for unit, meta in pairs(units) do
		if meta.enabled and modTable.config.performance then
			Plater.AddPerformanceUnits(unit, meta.flag)
		else
			Plater.RemovePerformanceUnits(unit)
		end

		if meta.enabled and modTable.config.forceBlizz then
			Plater.AddForceBlizzardNameplateUnits(unit)
		else
			Plater.RemoveForceBlizzardNameplateUnits(unit)
		end
	end
end
