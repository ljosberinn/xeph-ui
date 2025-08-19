function f(modTable)
	---@type PlaterRecolorNameConfig
	---@key ids number[]
	---@key color number[]
	local config = {}

	local colors = {
		color1 = modTable.config.color1,
		color2 = modTable.config.color2,
		color3 = modTable.config.color3,
	}

	for idString, colorReference in pairs(modTable.config.ids) do
		if colors[colorReference] then
			local ids = {}

			for num in idString:gmatch("%d+") do
				table.insert(ids, tonumber(num))
			end

			if #ids > 0 then
				table.insert(config, {
					ids = ids,
					color = colors[colorReference],
				})
			end
		end
	end

	-- sort config by amount of #ids present in desc order for matching reasons below
	table.sort(config, function(a, b)
		return #a.ids > #b.ids
	end)

	local defaultColor = { 1, 1, 1, 1 }

	function modTable.MaybePerformColorChange(unitFrame)
		local possibleNextColors = {}
		local prioritiesSeen = {}

		for _, auraInfo in pairs(config) do
			local match = true

			for _, id in pairs(auraInfo.ids) do
				if not Plater.NameplateHasAura(unitFrame, id) then
					match = false
					break
				end
			end

			if match then
				local priority = #auraInfo.ids

				table.insert(possibleNextColors, {
					color = auraInfo.color,
					priority = priority,
				})

				prioritiesSeen[priority] = true
			end

			-- the moment we see 2 diff matches with varying priority, since we traversed desc we must have a match since all further possible matches
			-- must have an even lower priority which can never match
			if #prioritiesSeen > 1 then
				break
			end
		end

		table.sort(possibleNextColors, function(a, b)
			return a.priority > b.priority
		end)

		local currentR, currentG, currentB, currentA = unitFrame.healthBar.unitName:GetTextColor()
		local nextR, nextG, nextB, nextA = unpack(possibleNextColors[1] and possibleNextColors[1].color or defaultColor)

		if currentR ~= nextR or currentG ~= nextG or currentB ~= nextB or currentA ~= nextA then
			unitFrame.healthBar.unitName:SetTextColor(nextR, nextG, nextB, nextA)
		end
	end
end
