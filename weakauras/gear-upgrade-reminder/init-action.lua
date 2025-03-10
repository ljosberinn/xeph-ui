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
-- copy(JSON.stringify(Object.values(JSON.parse($0.textContent)).filter(x => x.upgrade?.seasonId === 25).reduce((acc, data) => {
--     acc[data.id] = data.upgrade.name
--     return acc
-- }, {})))

local bonusToTierMap = {
	[11942] = "Explorer",
	[11943] = "Explorer",
	[11944] = "Explorer",
	[11945] = "Explorer",
	[11946] = "Explorer",
	[11947] = "Explorer",
	[11948] = "Explorer",
	[11949] = "Explorer",
	[11950] = "Adventurer",
	[11951] = "Adventurer",
	[11952] = "Adventurer",
	[11953] = "Adventurer",
	[11954] = "Adventurer",
	[11955] = "Adventurer",
	[11956] = "Adventurer",
	[11957] = "Adventurer",
	[11969] = "Veteran",
	[11970] = "Veteran",
	[11971] = "Veteran",
	[11972] = "Veteran",
	[11973] = "Veteran",
	[11974] = "Veteran",
	[11975] = "Veteran",
	[11976] = "Veteran",
	[11977] = "Champion",
	[11978] = "Champion",
	[11979] = "Champion",
	[11980] = "Champion",
	[11982] = "Champion",
	[11983] = "Champion",
	[11984] = "Champion",
	[11985] = "Hero",
	[11986] = "Hero",
	[11987] = "Hero",
	[11988] = "Hero",
	[11989] = "Hero",
	[11990] = "Hero",
	[11991] = "Myth",
	[11992] = "Myth",
	[11993] = "Myth",
	[11994] = "Myth",
	[11995] = "Myth",
	[11996] = "Myth",
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
	Explorer = { min = 597, max = 619 },
	Adventurer = { min = 610, max = 632 },
	Veteran = { min = 623, max = 645 },
	Champion = { min = 636, max = 658 },
	Hero = { min = 649, max = 665 },
	Myth = { min = 662, max = 678 },
}

local crestFreeItemLevelUpgradeThreshold = 580

---@param id ?number
---@return boolean
local function isCraftedBonusId(id)
	return id == 9498 -- Dream Crafted
		or id == 10249 -- Awakened Crafted
		or id == 10222 -- Omen Crafted
		or id == 12040 -- Fortune Crafted
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
