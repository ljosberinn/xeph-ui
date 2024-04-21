--- @return number
function aura_env.getStacks()
	return select(3, WA_GetUnitBuff("player", 203981)) or 0
end

function aura_env.talentedSpiritBomb()
	local activeConfigId = C_ClassTalents.GetActiveConfigID()

	if not activeConfigId then
		aura_env.usesSpiritBomb = false
		return
	end

	local spiritBombNodeId = 90978
	local nodeInfo = C_Traits.GetNodeInfo(activeConfigId, spiritBombNodeId)
	aura_env.usesSpiritBomb = nodeInfo.ranksPurchased > 0
end

aura_env.usesSpiritBomb = false
aura_env.talentedSpiritBomb()

aura_env.lastStacks = aura_env.getStacks()
aura_env.currentStacks = aura_env.lastStacks

local isInMeta = WA_GetUnitBuff("player", 187827) ~= nil

-- full update may be required to make conditional colors happen
-- otherwise, only the changed fragments will have their colro adjusted which is giga wonky visually
--- @param event "UNIT_AURA" | "TRIGGER" | "OPTIONS" | "STATUS"
--- @param updatedTriggerNumber number | string | nil
--- @param updatedTriggerStates table | nil
--- @return boolean, boolean
function aura_env.shouldPerformFullUpdate(event, updatedTriggerNumber, updatedTriggerStates)
	if event == "UNIT_AURA" then
		if aura_env.currentStacks == aura_env.lastStacks then
			return false, true
		end

		if aura_env.usesSpiritBomb then
			if isInMeta then
				-- from sub 3 to 3+
				if aura_env.currentStacks >= 3 then
					return aura_env.lastStacks < 3, false
				end

				return false, false
			end

			-- from sub 4 to 4+
			if aura_env.currentStacks >= 4 then
				return aura_env.lastStacks < 4, false
			end

			return false, false
		end

		return false, false
	end

	-- only triggers when you ENTER or LEAVE meta
	if event == "TRIGGER" and updatedTriggerNumber == 2 then
		-- for some reason this table is empty when leaving meta
		for _, trigger in pairs(updatedTriggerStates) do
			if trigger.triggernum == 2 then
				isInMeta = trigger.show

				if aura_env.usesSpiritBomb then
					return aura_env.currentStacks >= 3, false
				end

				-- technically redundant, but without returning while seeing meta
				-- the dropping out of meta check below would get triggered on entering meta
				return aura_env.currentStacks == 5, false
			end
		end

		if isInMeta then
			isInMeta = false
			if aura_env.usesSpiritBomb then
				return aura_env.currentStacks >= 3, false
			end

			return false, false
		end
	end

	-- STATUS event
	return false, false
end
