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
	[10321] = "Explorer",
	[10322] = "Explorer",
	[10323] = "Explorer",
	[10324] = "Explorer",
	[10325] = "Explorer",
	[10326] = "Explorer",
	[10327] = "Explorer",
	[10328] = "Explorer",
	[10305] = "Adventurer",
	[10306] = "Adventurer",
	[10307] = "Adventurer",
	[10308] = "Adventurer",
	[10309] = "Adventurer",
	[10310] = "Adventurer",
	[10311] = "Adventurer",
	[10312] = "Adventurer",
	[10341] = "Veteran",
	[10343] = "Veteran",
	[10344] = "Veteran",
	[10345] = "Veteran",
	[10346] = "Veteran",
	[10347] = "Veteran",
	[10348] = "Veteran",
	[10313] = "Champion",
	[10314] = "Champion",
	[10315] = "Champion",
	[10316] = "Champion",
	[10317] = "Champion",
	[10318] = "Champion",
	[10319] = "Champion",
	[10320] = "Champion",
	[10329] = "Hero",
	[10330] = "Hero",
	[10331] = "Hero",
	[10332] = "Hero",
	[10333] = "Hero",
	[10334] = "Hero",
	[10335] = "Myth",
	[10336] = "Myth",
	[10337] = "Myth",
	[10338] = "Myth",
	[10407] = "Awakened",
	[10408] = "Awakened",
	[10409] = "Awakened",
	[10410] = "Awakened",
	[10411] = "Awakened",
	[10412] = "Awakened",
	[10413] = "Awakened",
	[10414] = "Awakened",
	[10415] = "Awakened",
	[10416] = "Awakened",
	[10417] = "Awakened",
	[10418] = "Awakened",
	--Rare Awakened Drops go to 1/14
	[10490] = "Awakened+",
	[10491] = "Awakened+",
	[10492] = "Awakened+",
	[10493] = "Awakened+",
	[10494] = "Awakened+",
	[10495] = "Awakened+",
	[10496] = "Awakened+",
	[10497] = "Awakened+",
	[10498] = "Awakened+",
	[10499] = "Awakened+",
	[10500] = "Awakened+",
	[10501] = "Awakened+",
	[10502] = "Awakened+",
	[10503] = "Awakened+",
}

local tiers = {
	Explorer = { min = 454, max = 476 },
	Adventurer = { min = 467, max = 489 },
	Veteran = { min = 480, max = 502 },
	Champion = { min = 493, max = 515 },
	Hero = { min = 506, max = 522 },
	Myth = { min = 519, max = 528 },
	Awakened = { min = 493, max = 528 },
	["Awakened+"] = { min = 493, max = 535 },
}

---@param id ?number
---@return boolean
local function isCraftedBonusId(id)
	return id == 9498 -- Dream Crafted
		or id == 10249 -- Awakened Crafted
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

			if currentItemLevel >= 454 then
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
