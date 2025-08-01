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

-- https://www.raidbots.com/static/data/xptr/bonuses.json
-- copy(JSON.stringify(Object.values(JSON.parse($0.textContent)).filter(x => x.upgrade?.seasonId === 30).reduce((acc, data) => {
--     acc[data.id] = data.upgrade.name
--     return acc
-- }, {})))

local bonusToTierMap = {
	[12265] = "Explorer",
	[12266] = "Explorer",
	[12267] = "Explorer",
	[12268] = "Explorer",
	[12269] = "Explorer",
	[12270] = "Explorer",
	[12271] = "Explorer",
	[12272] = "Explorer",
	[12274] = "Adventurer",
	[12275] = "Adventurer",
	[12276] = "Adventurer",
	[12277] = "Adventurer",
	[12278] = "Adventurer",
	[12279] = "Adventurer",
	[12280] = "Adventurer",
	[12281] = "Adventurer",
	[12282] = "Veteran",
	[12283] = "Veteran",
	[12284] = "Veteran",
	[12285] = "Veteran",
	[12286] = "Veteran",
	[12287] = "Veteran",
	[12288] = "Veteran",
	[12289] = "Veteran",
	[12290] = "Champion",
	[12291] = "Champion",
	[12292] = "Champion",
	[12293] = "Champion",
	[12294] = "Champion",
	[12295] = "Champion",
	[12296] = "Champion",
	[12297] = "Champion",
	[12350] = "Hero",
	[12351] = "Hero",
	[12352] = "Hero",
	[12353] = "Hero",
	[12354] = "Hero",
	[12355] = "Hero",
	[12356] = "Myth",
	[12357] = "Myth",
	[12358] = "Myth",
	[12359] = "Myth",
	[12360] = "Myth",
	[12361] = "Myth",
}

-- copy(JSON.stringify(Object.values(JSON.parse($0.textContent)).filter(x => x.upgrade?.seasonId === 25).reduce((acc, data) => {
--     const [tier] = data.upgrade.fullName.split(' ')
--     if (acc[tier]) {
--         if (data.upgrade.itemLevel > acc[tier].max) {
--             acc[tier].max = data.upgrade.itemLevel
--         } else if (data.upgrade.itemLevel < acc[tier].min) {
--             acc[tier].min = data.upgrade.itemLevel
--         }
--     } else {
--         acc[tier] = {
--             min: data.upgrade.itemLevel,
--             max: data.upgrade.itemLevel,
--         }
--     }

--     return acc
-- }, {})).replaceAll(':', '=').replaceAll('"', ''))

local tiers = {
	Explorer = { min = 642, max = 665 },
	Adventurer = { min = 655, max = 678 },
	Veteran = { min = 668, max = 691 },
	Champion = { min = 681, max = 704 },
	Hero = { min = 694, max = 710 },
	Myth = { min = 707, max = 723 },
}

local crestFreeItemLevelUpgradeThreshold = 580

---@param id ?number
---@return boolean
local function isCraftedBonusId(id)
	return id == 9498 -- Dream Crafted
		or id == 10249 -- Awakened Crafted
		or id == 10222 -- Omen Crafted
		or id == 12040 -- Fortune Crafted
		or id == 12050 -- Starlight Crafted
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

			if currentItemLevel >= tiers.Explorer.min then
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
						elseif currentItemLevel < crestFreeItemLevelUpgradeThreshold then
							found = found + 1
							local msg = format(
								"%s can be upgraded to item level %d without crests!",
								itemLink,
								crestFreeItemLevelUpgradeThreshold
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
