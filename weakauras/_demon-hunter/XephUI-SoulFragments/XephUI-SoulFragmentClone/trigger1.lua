---UNIT_AURA:player

---@class SoulFragmentCloneState
---@field show boolean
---@field total 1
---@field value number
---@field index number
---@field progressType "static"
---@field changed boolean
---@field isInMeta boolean
---@field stacks number

---@param states table<number, SoulFragmentCloneState>
---@param event "UNIT_AURA" | "STATUS" | "OPTIONS"
function f(states, event, ...)
	if event == "STATUS" then
		local fragmentsInfo = C_UnitAuras.GetPlayerAuraBySpellID(aura_env.soulFragmentsBuffId)
		local currentFragments = fragmentsInfo and fragmentsInfo.applications or 0

		local metamorphosisInfo = C_UnitAuras.GetPlayerAuraBySpellID(aura_env.metamorphosisBuffId)
		local isInMeta = metamorphosisInfo ~= nil

		for i = 1, 5 do
			states[i] = {
				show = true,
				changed = true,
				value = currentFragments >= i and 1 or 0,
				total = 1,
				progressType = "static",
				index = i,
				isInMeta = isInMeta,
				stacks = currentFragments,
			}
		end

		return true
	end

	if event == "UNIT_AURA" then
		---@type string, UnitAuraUpdateInfo?
		local _, updateInfo = ...

		if not updateInfo then
			return false
		end

		-- taken from https://github.com/Gethe/wow-ui-source/blob/88f272e94c202ecbe11fa44945f6035c65c15176/Interface/AddOns/Blizzard_UnitFrame/EvokerEbonMightBar.lua#L51-L55
		local isUpdatePopulated = updateInfo.isFullUpdate
			or (updateInfo.addedAuras ~= nil and #updateInfo.addedAuras > 0)
			or (updateInfo.removedAuraInstanceIDs ~= nil and #updateInfo.removedAuraInstanceIDs > 0)
			or (updateInfo.updatedAuraInstanceIDs ~= nil and #updateInfo.updatedAuraInstanceIDs > 0)

		if not isUpdatePopulated then
			return false
		end

		local fragmentsInfo = C_UnitAuras.GetPlayerAuraBySpellID(aura_env.soulFragmentsBuffId)
		local currentFragments = fragmentsInfo and fragmentsInfo.applications or 0

		local metamorphosisInfo = C_UnitAuras.GetPlayerAuraBySpellID(aura_env.metamorphosisBuffId)
		local isInMeta = metamorphosisInfo ~= nil

		if states[1].isInMeta == isInMeta and states[1].stacks == currentFragments then
			return false
		end

		local hasChanges = false

		for i = 1, 5 do
			local state = states[i]

			if state.isInMeta ~= isInMeta then
				state.isInMeta = isInMeta
			end

			if state.stacks ~= currentFragments then
				state.stacks = currentFragments
				state.changed = true
				hasChanges = true
			end

			local value = currentFragments >= i and 1 or 0

			if value ~= state.value then
				state.value = value
				state.changed = true
				hasChanges = true
			end
		end

		return hasChanges
	end
end
