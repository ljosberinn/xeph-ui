local itemSlots = {
	INVSLOT_HEAD,
	INVSLOT_NECK,
	INVSLOT_SHOULDER,
	INVSLOT_CHEST,
	INVSLOT_WAIST,
	INVSLOT_LEGS,
	INVSLOT_FEET,
	INVSLOT_WRIST,
	INVSLOT_HAND,
	INVSLOT_FINGER1,
	INVSLOT_FINGER2,
	INVSLOT_TRINKET1,
	INVSLOT_TRINKET2,
	INVSLOT_BACK,
	INVSLOT_MAINHAND,
	INVSLOT_OFFHAND,
}

local bonusToTierMap = {
	[10256] = "Hero",
	[10257] = "Myth",
	[10258] = "Myth",
	[10259] = "Myth",
	[10260] = "Myth",
	[10261] = "Hero",
	[10262] = "Hero",
	[10263] = "Hero",
	[10264] = "Hero",
	[10265] = "Hero",
	[10266] = "Champion",
	[10267] = "Champion",
	[10268] = "Champion",
	[10269] = "Champion",
	[10270] = "Champion",
	[10271] = "Champion",
	[10272] = "Champion",
	[10273] = "Champion",
	[10274] = "Veteran",
	[10275] = "Veteran",
	[10276] = "Veteran",
	[10277] = "Veteran",
	[10278] = "Veteran",
	[10279] = "Veteran",
	[10280] = "Veteran",
	[10281] = "Veteran",
	[10282] = "Explorer",
	[10283] = "Explorer",
	[10284] = "Explorer",
	[10285] = "Explorer",
	[10286] = "Explorer",
	[10287] = "Explorer",
	[10288] = "Explorer",
	[10289] = "Explorer",
	[10290] = "Adventurer",
	[10291] = "Adventurer",
	[10292] = "Adventurer",
	[10293] = "Adventurer",
	[10294] = "Adventurer",
	[10295] = "Adventurer",
	[10296] = "Adventurer",
	[10297] = "Adventurer",
}

local tiers = {
	Explorer = {
		min = 558,
		max = 580,
	},
	Adventurer = {
		min = 571,
		max = 593,
	},
	Veteran = {
		min = 584,
		max = 606,
	},
	Champion = {
		min = 597,
		max = 619,
	},
	Hero = {
		min = 610,
		max = 626,
	},
	Myth = {
		min = 623,
		max = 632,
	},
}

---@param id ?number
---@return boolean
local function isCraftedBonusId(id)
	return id == 9498 -- Dream Crafted
		or id == 10249 -- Awakened Crafted
		or id == 10222 -- Omen Crafted
end

local function getUpgradeTrack(bonusIds)
	for i = 1, #bonusIds do
		local id = tonumber(bonusIds[i])

		if isCraftedBonusId(id) then
			return
		end

		local key = bonusToTierMap[id]

		if key then
			return tiers[key]
		end
	end
end

---@return number
function aura_env.doUpgradeCheck()
	local found = 0

	for i = 1, #itemSlots do
		local slot = itemSlots[i]
		local itemLoc = ItemLocation:CreateFromEquipmentSlot(slot)

		if itemLoc:IsValid() then
			local currentItemLevel = C_Item.GetCurrentItemLevel(itemLoc)

			if currentItemLevel >= 558 then
				local itemLink = C_Item.GetItemLink(itemLoc)

				if itemLink then
					local itemLinkValues = StringSplitIntoTable(":", itemLink)
					local numBonusIDs = itemLinkValues[14]
					numBonusIDs = numBonusIDs and tonumber(numBonusIDs) or 0
					local bonusIds = numBonusIDs > 0 and { unpack(itemLinkValues, 15, 15 + numBonusIDs - 1) } or {}
					local upgradeTrack = getUpgradeTrack(bonusIds)

					if upgradeTrack and currentItemLevel < upgradeTrack.max then
						local redundancySlot = slot == INVSLOT_OFFHAND and Enum.ItemRedundancySlot.Offhand
							or C_ItemUpgrade.GetHighWatermarkSlotForItem(C_Item.GetItemID(itemLoc))

						local characterWatermark, accountWatermark =
							C_ItemUpgrade.GetHighWatermarkForSlot(redundancySlot)

						local watermark = characterWatermark < accountWatermark and characterWatermark
							or accountWatermark

						local finalIlvlToCompareWith = upgradeTrack.max < watermark and upgradeTrack.max or watermark

						if currentItemLevel < finalIlvlToCompareWith then
							found = found + 1
							local msg = format(
								"%s can be upgraded to item level %d without using crests!",
								itemLink,
								finalIlvlToCompareWith
							)

							print(msg)
						end
					end
				end
			end
		end
	end

	return found
end
