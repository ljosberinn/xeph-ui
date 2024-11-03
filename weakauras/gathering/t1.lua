---@class GatheringState
---@field changed boolean
---@field show boolean
---@field icon string
---@field stacks number
---@field progressType "static"
---@field value number
---@field total number

function f(states, event, ...)
	if event == "BAG_UPDATE_DELAYED" or event == "STATUS" then
		local changed = false

		for id, snapshot in pairs(aura_env.eligibleItems) do
			local current = C_Item.GetItemCount(id)

			if event == "STATUS" then
				aura_env.eligibleItems[id] = current

				changed = true
			end

			if states[id] == nil or current == 0 or current > snapshot then
				local diff = current == 0 and 0 or current - snapshot

				if states[id] == nil then
					-- on login, this may return nil
					local link = Item:CreateFromItemID(id):GetItemLink()

					if link then
						local reagentQuality = C_TradeSkillUI.GetItemReagentQualityByItemInfo(link)
						local reagentQualityTexture = reagentQuality
								and CreateAtlasMarkupWithAtlasSize(
									"Professions-Icon-Quality-Tier" .. reagentQuality .. "-Small"
								)
							or nil

						states[id] = {
							show = true,
							changed = true,
							progressType = "static",
							value = 1,
							total = 1,
							stacks = 0,
							icon = C_Item.GetItemIconByID(id),
							name = C_Item.GetItemNameByID(id),
							itemId = id,
							reagentQuality = reagentQuality,
							reagentQualityTexture = reagentQualityTexture,
						}

						changed = true
					end
				elseif states[id].stacks ~= diff then
					states[id].changed = true
					states[id].stacks = diff

					changed = true
				end
			end
		end

		return changed
	end

	if event == "GATHERER_RESET" then
		local changed = false

		for id in pairs(aura_env.eligibleItems) do
			if states[id] ~= nil and states[id].stacks > 0 then
				states[id].changed = true
				states[id].stacks = 0

				aura_env.eligibleItems[id] = C_Item.GetItemCount(id)
				changed = true
			end
		end

		return changed
	end

	return false
end
