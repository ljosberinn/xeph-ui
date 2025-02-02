function f(modTable)
	if not Plater.AddPerformanceUnits or not Plater.PERF_UNIT_OVERRIDES_BIT then
		return
	end

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

		-- Dungeons
		[196642] = { enabled = true, flag = 0 }, -- Hungry Lasher (Boss add)
		[197398] = { enabled = true, flag = 0 }, -- Hungry Lasher
		[208994] = { enabled = true, flag = 0 }, -- Infected Lasher
		[189363] = { enabled = true, flag = 0 }, -- Infected Lasher
		[96247] = { enabled = true, flag = 0 }, -- Vileshard Crawler
		[100529] = { enabled = true, flag = 0 }, -- Hatespawn Slime
		[84401] = { enabled = true, flag = 0 }, -- Swift Sproutling (boss add)

		--Testing
		[198594] = { enabled = false, flag = 0 }, -- Testing target dummy
		[87329] = { enabled = false, flag = 0 }, -- testing
		[217126] = { enabled = true, flag = 0 }, -- Over-Indulged Patron
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
