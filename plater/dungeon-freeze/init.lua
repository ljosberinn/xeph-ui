function f(modTable)
	-- Populated with root immune npcIds from MDT.
	local immuneMap = {
		-- not stun immune in MDT
		[205408] = true, -- Infinite Timeslicer
	}

	local hasMDT = false

	if MDT and MDT.dungeonEnemies then
		hasMDT = true

		for _, dungeon in pairs(MDT.dungeonEnemies) do
			for _, npc in pairs(dungeon) do
				if npc.characteristics and npc.characteristics and not npc.characteristics["Stun"] then
					immuneMap[npc.id] = true
				end
			end
		end
	end

	function modTable.maybeUpdateColor(unitFrame)
		if not hasMDT then
			return
		end

		if immuneMap[unitFrame.namePlateNpcId] == nil then
			return
		end

		if modTable.config.useNameplateColor then
			Plater.SetNameplateColor(unitFrame, modTable.config.healthBarColor)
			Plater.DenyColorChange(unitFrame, true)
		end

		if modTable.config.useBorderColor then
			Plater.SetBorderColor(unitFrame, modTable.config.borderColor)
			Plater.DenyColorChange(unitFrame, true)
		end

		if modTable.config.useNameColor then
			Plater:SetFontColor(unitFrame.unitName, modTable.config.nameColor)
			Plater.DenyColorChange(unitFrame, true)
		end
	end
end
