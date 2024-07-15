function f(self, unitId, unitFrame, envTable)
	local color = "gray"

	---@class StackBasedInvalidation
	---@field stacks number
	---@field auraId number

	---@type table<number, StackBasedInvalidation>
	local stackBasedInvalidation = {
		[218884] = { stacks = 3, auraId = 438706 }, -- Hardened Carapace stacks on Shattershell Scarab
	}

	function envTable.updateNameplateColor(unitFrame)
		if not InCombatLockdown() then
			return
		end

		local stackInfo = stackBasedInvalidation[unitFrame.namePlateNpcId]

		if stackInfo ~= nil then
			local auraInfo = C_UnitAuras.GetAuraDataBySpellName(unitId, C_Spell.GetSpellName(stackInfo.auraId))

			if auraInfo and auraInfo.applications and auraInfo.applications <= stackInfo.stacks then
				Plater.SetNameplateColor(unitFrame) -- omitting a color should reset it
				return
			end
		end

		Plater.SetNameplateColor(unitFrame, color)
	end
end
