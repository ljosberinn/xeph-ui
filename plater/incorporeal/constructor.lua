function f(scriptTable)
	-- taken from https://github.com/Tercioo/Plater-Nameplates/blob/master/libs/DF/spells.lua#L916
	-- but trimmed to only include ccs that would deal with it for good
	local spells = {
		[118699] = "WARLOCK", -- Fear (debuff spellid)
		[710] = "WARLOCK", -- Banish
		[118] = "MAGE", -- Polymorph
		[61305] = "MAGE", -- Polymorph (black cat)
		[28271] = "MAGE", -- Polymorph Turtle
		[161354] = "MAGE", -- Polymorph Monkey
		[161353] = "MAGE", -- Polymorph Polar Bear Cub
		[126819] = "MAGE", -- Polymorph Porcupine
		[277787] = "MAGE", -- Polymorph Direhorn
		[61721] = "MAGE", -- Polymorph Rabbit
		[28272] = "MAGE", -- Polymorph Pig
		[277792] = "MAGE", -- Polymorph Bumblebee
		[391622] = "MAGE", -- Polymorph Duck
		[9484] = "PRIEST", -- Shackle Undead
		[2094] = "ROGUE", -- Blind
		[20066] = "PALADIN", -- Repentance (talent)
		[10326] = "PALADIN", -- Turn Evil
		[2637] = "DRUID", -- Hibernate
		[115078] = "MONK", -- Paralysis
		[51514] = "SHAMAN", -- Hex
		[210873] = "SHAMAN", -- Hex (Compy)
		[211004] = "SHAMAN", -- Hex (Spider)
		[211010] = "SHAMAN", -- Hex (Snake)
		[211015] = "SHAMAN", -- Hex (Cockroach)
		[269352] = "SHAMAN", -- Hex (Skeletal Hatchling)
		[277778] = "SHAMAN", -- Hex (Zandalari Tendonripper)
		[277784] = "SHAMAN", -- Hex (Wicker Mongrel)
		[309328] = "SHAMAN", -- Hex (Living Honey)
		[217832] = "DEMONHUNTER", -- Imprison
		[360806] = "EVOKER", -- Sleep Walk
		[3355] = "HUNTER", -- Freezing Trap
		[1513] = "HUNTER", -- Scare Beast
	}

	--- @return boolean
	scriptTable.isDebuffed = function(unitFrame)
		for spellId in pairs(spells) do
			if Plater.UnitHasAura(unitFrame, spellId) then
				return true
			end
		end

		return false
	end

	scriptTable.hide = function(unitFrame)
		-- no check whether its already hidden as it may reappear for whichever
		-- reason when you turn camera away and back to it again
		Plater.HideHealthBar(unitFrame)
		Plater.DisableHighlight(unitFrame)
		unitFrame._isHidden = true
	end

	scriptTable.show = function(unitFrame)
		if not unitFrame._isHidden then
			return
		end

		Plater.ShowHealthBar(unitFrame)
		Plater.EnableHighlight(unitFrame)
		unitFrame._isHidden = false
	end
end
