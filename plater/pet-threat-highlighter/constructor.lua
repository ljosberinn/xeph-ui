function f(self, unitId, unitFrame, envTable)
	envTable.color = "#5d00ff"

	envTable.npcs = {
		[61056] = "Greater Earth Elemental",
		[61146] = "Black Ox Statue",
		[95072] = "Earth Elemental",
		[103822] = "Treant",
	}

	envTable.rules = {
		["Pet"] = true,
		["Creature"] = function(npcID)
			return (envTable.npcs[npcID] ~= nil)
		end,
	}

	envTable.getTypeAndID = function(guid)
		local unitType, _, _, _, _, npcID = strsplit("-", guid)
		return unitType, tonumber(npcID or "0") or 0
	end

	envTable.shallHighlight = function(guid)
		local unitType, npcID = envTable.getTypeAndID(guid)

		if not unitType then
			return false
		end

		if unitType == "Pet" then
			return true
		end

		if unitType == "Creature" then
			return envTable.npcs[npcID] ~= nil
		end

		return false
	end
end
