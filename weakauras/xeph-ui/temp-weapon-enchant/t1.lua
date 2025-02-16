--BAG_UPDATE_DELAYED, ACTIVE_PLAYER_SPECIALIZATION_CHANGED, STATUS, XEPHUI_TEMP_WEAPON_DELAYED
---@class TempWeaponEnchantState
---@field changed boolean
---@field show boolean
---@field icon string
---@field stacks number
---@field progressType string
---@field value number
---@field total number
---@field duration number
---@field expirationTime number

---@param states table<"", TempWeaponEnchantState>
---@param event "BAG_UPDATE_DELAYED" | "ACTIVE_PLAYER_SPECIALIZATION_CHANGED" | "STATUS"
---@param ... any
function f(states, event, ...)
	if aura_env.config.enchant == 0 or aura_env.config.item == 0 then
		return false
	end

	if
		event == "BAG_UPDATE_DELAYED"
		or event == "STATUS"
		or event == "ACTIVE_PLAYER_SPECIALIZATION_CHANGED"
		or event == "XEPHUI_TEMP_WEAPON_DELAYED"
	then
		states[""] = states[""]
			or {
				changed = true,
				show = false,
				icon = C_Item.GetItemIconByID(aura_env.config.item),
				stacks = 0,
				progressType = "static",
			}

		local effectiveItemId = aura_env.config.item
		local changed = false

		for i = aura_env.config.item, aura_env.config.item - 2, -1 do
			local stacks = C_Item.GetItemCount(i)

			if stacks > 0 then
				effectiveItemId = i

				if stacks ~= states[""].stacks then
					states[""].stacks = stacks
					states[""].changed = true
					states[""].show = stacks > 0
					changed = true
				end

				break
			end
		end

		local _, mainHandExpiration, _, mainHandEnchantID, _, offHandExpiration, _, offHandEnchantID =
			GetWeaponEnchantInfo()

		if event == "STATUS" and mainHandEnchantID ~= nil and mainHandExpiration == 0 then
			C_Timer.After(2, function()
				WeakAuras.ScanEvents("XEPHUI_TEMP_WEAPON_DELAYED")
			end)
			return false
		end

		local effectiveEnchantId = aura_env.config.enchant

		if aura_env.config.item ~= effectiveItemId then
			local diff = aura_env.config.item - effectiveItemId
			effectiveEnchantId = effectiveEnchantId - diff
		end

		local mainHandEnchanted = mainHandEnchantID == effectiveEnchantId
		local offHandEnchanted = IsDualWielding() and offHandEnchantID == effectiveEnchantId or true

		local threeHoursInMilliseconds = 3 * 60 * 60 * 1000

		mainHandExpiration = math.floor((mainHandExpiration or threeHoursInMilliseconds) / 1000)
		offHandExpiration = math.floor((offHandExpiration or threeHoursInMilliseconds) / 1000)

		local nextState = {
			show = true,
			progressType = "static",
			duration = nil,
			expirationTime = nil,
		}

		if mainHandEnchanted and offHandEnchanted then
			local leastRemainingTime = math.min(mainHandExpiration, offHandExpiration)

			if leastRemainingTime > 0 then
				nextState.show = leastRemainingTime <= 300
				nextState.progressType = "timed"
				nextState.duration = 2 * 60 * 60
				nextState.expirationTime = GetTime() + leastRemainingTime
			end
		end

		for k, v in pairs(nextState) do
			if states[""][k] ~= v then
				states[""][k] = v
				changed = true
			end
		end

		if changed then
			states[""].changed = true
		end

		local debug = {
			event = event,
			effectiveItemId = effectiveItemId,
			effectiveEnchantId = effectiveEnchantId,
			mainHandEnchanted = mainHandEnchanted,
			offHandEnchanted = offHandEnchanted,
			mainHandExpiration = mainHandExpiration,
			offHandExpiration = offHandExpiration,
		}

		for k, v in pairs(debug) do
			print(k, v)
		end

		return changed
	end

	return false
end
