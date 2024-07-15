function f(self, unitId, unitFrame, envTable)
	envTable.color = "#5d00ff"

	envTable.npcs = {
		[61056] = "Greater Earth Elemental",
		[61146] = "Black Ox Statue",
		[95072] = "Earth Elemental",
		[103822] = "Treant",
	}

	function envTable.getTypeAndID(guid)
		local unitType, _, _, _, _, npcID = strsplit("-", guid)
		return unitType, tonumber(npcID or "0") or 0
	end

	function envTable.shallHighlight(self, guid)
		local unitType, npcID = envTable.getTypeAndID(guid)

		if not unitType then
			return false
		end

		if unitType == "Pet" then
			return true
		end

		return envTable.npcs[npcID] ~= nil
	end
end
