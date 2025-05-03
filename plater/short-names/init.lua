function f(modTable)
	-- used for nameColouring
	-- AARRGGBB
	local markerToHex = {
		[1] = "FFEAEA0D", -- Yellow 5 Point Star
		[2] = "FFEAB10D", -- Orange Circle
		[3] = "FFCD00FF", -- Purple Diamond
		[4] = "FF06D425", -- Green Triangle
		[5] = "FFB3E3D8", -- Light Blue Moon
		[6] = "FF0CD2EA", -- Blue Square
		[7] = "FFD6210B", -- Red Cross
		[8] = "FFFFFFFF", -- White Skull
	}

	local isFrenchLocale = ((GAME_LOCALE or GetLocale()) == "frFR")

	-- Makes it so you take their first name e.g Jessie Howlis -> Jessie
	local nameBlacklist = isFrenchLocale
			and {
				["d'entraînement"] = true,
				["le"] = true,
				["la"] = true,
				["les"] = true,
				["un"] = true,
				["une"] = true,
				["des"] = true,
				["d'"] = true,
				["de"] = true,
				["du"] = true,
				["et"] = true,
				["en"] = true,
				["terreur"] = true,
			}
		or {
			["the"] = true,
			["of"] = true,
			["Tentacle"] = true,
			["Apprentice"] = true,
			["Denizen"] = true,
			["Emissary"] = true,
			["Howlis"] = true,
			["Terror"] = true,
			["Totem"] = true,
			["Waycrest"] = true,
			["Aspect"] = true,
		}

	local function RemoveTrailingPunctuation(word)
		return word and word:gsub("[%p]+$", "") or word
	end

	local function GetSanitizedParts(name)
		local a, b, c, d, e, f = strsplit(" ", name, 5)

		if not isFrenchLocale then
			return a, b, c, d, e, f
		end

		return RemoveTrailingPunctuation(a),
			RemoveTrailingPunctuation(b),
			RemoveTrailingPunctuation(c),
			RemoveTrailingPunctuation(d),
			RemoveTrailingPunctuation(e),
			RemoveTrailingPunctuation(f)
	end

	local function Capitalize(str)
		return str and str:gsub("^%l", string.upper) or str
	end

	---@type table<number, fun(name: string): string>
	local specialTreatmentNpcIdMap = {
		[228463] = function(name)
			local locales = {
				"Reel Assistant", -- en
				"Walzenassistent", -- de
				"Assistant des bobines", --fr
				"Технический ассистент", -- ru
				"转轮助理", -- cn
				"Ayudante de palanca", -- es
				"Assistente al Rullo", -- it
				"Assistente de Cilindro", -- pt
				"굴림판 도우미", -- ko
			}

			for _, locale in ipairs(locales) do
				if name ~= locale and name:find(locale) then
					return name:gsub(locale, ""):match("^%s*(.-)%s*$")
				end
			end

			return name
		end,
		-- for testing purposes, replace -1 with the npc id
		[-1] = function(name)
			return "lmao"
		end,
	}

	-- @unitId unitID for mob e.g nameplate1
	function modTable.renamer(unitFrame, unitId)
		if not (unitId and unitFrame) then
			return
		end

		local currentName = unitFrame.namePlateUnitName or UnitName(unitId) or ""
		local nextName = currentName

		if modTable.config.short_names and not unitFrame.unitName.isRenamed then
			if unitFrame.namePlateNpcId and specialTreatmentNpcIdMap[unitFrame.namePlateNpcId] then
				nextName = specialTreatmentNpcIdMap[unitFrame.namePlateNpcId](nextName)
			else
				local a, b, c, d, e, f = GetSanitizedParts(nextName)

				local unitName

				if isFrenchLocale then
					if a and nameBlacklist[a:lower()] then
						unitName = Capitalize(f or e or d or c or b or a)
					else
						unitName = a
					end
				else
					if nameBlacklist[b] then
						unitName = a or b or c or d or e or f
					else
						unitName = f or e or d or c or b or a
					end
				end
				nextName = unitName or nextName
			end
		end

		if modTable.config.colour_names then
			local marker = GetRaidTargetIndex(unitId)
			if marker then
				local color = markerToHex[marker or 8]
				nextName = WrapTextInColorCode(nextName, color)
			end
		end

		if nextName == currentName then
			return
		end

		unitFrame.healthBar.unitName:SetText(nextName)
	end
end
