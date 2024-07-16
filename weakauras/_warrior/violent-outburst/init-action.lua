aura_env.rageSpent = 0

aura_env.seeingRed = {
	stacks = 0,
	getStackBuff = function()
		return WA_GetUnitBuff("player", 386486)
	end,
	getOutburstBuff = function()
		return WA_GetUnitBuff("player", 386478)
	end,
}

local hasBarbaricTrainingTalentActive = false

aura_env.checkBarbaricTrainingTalentState = function()
	local activeConfigId = C_ClassTalents.GetActiveConfigID()
	if not activeConfigId then
		hasBarbaricTrainingTalentActive = false
		return
	end

	local barbaricTrainingNodeId = 90377
	local nodeInfo = C_Traits.GetNodeInfo(activeConfigId, barbaricTrainingNodeId)
	hasBarbaricTrainingTalentActive = nodeInfo.ranksPurchased > 0
end

aura_env.checkBarbaricTrainingTalentState()

local function calcRageSpentOnExecuteOrCondemn()
	if WA_GetUnitBuff("player", 52437) ~= nil then
		return 0
	end

	return aura_env.prevRage - aura_env.currentRage
end

local abilities = {
	[6572] = { -- revenge
		determineCostAndResetRequirement = function()
			if WA_GetUnitBuff("player", 5302) ~= nil then
				return 0
			end

			if hasBarbaricTrainingTalentActive then
				return 30
			end

			return 20
		end,
	},
	[1680] = { -- whirlwind
		determineCostAndResetRequirement = function()
			return 20
		end,
	},
	[190456] = { -- ignore pain
		determineCostAndResetRequirement = function()
			return 35
		end,
	},
	[163201] = { --execute
		determineCostAndResetRequirement = calcRageSpentOnExecuteOrCondemn,
	},
	[317349] = { -- condemn
		determineCostAndResetRequirement = calcRageSpentOnExecuteOrCondemn,
	},
	[2565] = { -- shield block
		determineCostAndResetRequirement = function()
			return 30
		end,
	},
	[394062] = { -- rend
		determineCostAndResetRequirement = function()
			return 20
		end,
	},
	[1715] = { -- harmstring
		determineCostAndResetRequirement = function()
			return 10
		end,
	},
	[202168] = { -- impending victory
		determineCostAndResetRequirement = function()
			if WA_GetUnitBuff("player", 118779) ~= nil then
				return 0
			end

			return 10
		end,
	},
	[1464] = { -- slam
		determineCostAndResetRequirement = function()
			return 20
		end,
	},
}

do
	local currentRage = UnitPower("player", 1)
	aura_env.prevRage = currentRage
	aura_env.currentRage = currentRage

	local _, _, stacks = aura_env.seeingRed.getStackBuff()

	if stacks then
		aura_env.rageSpent = stacks * 30
		aura_env.seeingRed.stacks = stacks
	end
end

local function resetRageSpent()
	local remainder = aura_env.rageSpent - 240

	if remainder <= 0 then
		aura_env.rageSpent = 0
	else
		aura_env.rageSpent = remainder
	end
end

function aura_env.onPlayerSpellCastSuccess(spellId)
	if not abilities[spellId] then
		return
	end

	local cost = abilities[spellId].determineCostAndResetRequirement()

	if cost > 0 then
		aura_env.rageSpent = aura_env.rageSpent + cost
	end
end

function aura_env.onRageChange()
	aura_env.prevRage = aura_env.currentRage
	aura_env.currentRage = UnitPower("player", 1)
end

function aura_env.onPlayerAuraUpdate()
	local _, _, stacks = aura_env.seeingRed.getStackBuff()

	if stacks ~= nil then -- restacking
		if stacks < aura_env.seeingRed.stacks then
			resetRageSpent()
		end

		aura_env.seeingRed.stacks = stacks
	else
		if aura_env.seeingRed.stacks > 0 then
			resetRageSpent()
		end

		aura_env.seeingRed.stacks = 0
	end
end
