function f(event)
	if event == "PLAYER_EQUIPMENT_CHANGED" then
		for i = 1, #aura_env.itemSlots do
			local slot = aura_env.itemSlots[i]
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
						local upgradeTrack = aura_env.getUpgradeTrack(bonusIds)

						if upgradeTrack and currentItemLevel < upgradeTrack.max then
							local redundancySlot = C_ItemUpgrade.GetHighWatermarkSlotForItem(C_Item.GetItemID(itemLoc))

							local characterWatermark, accountWatermark =
								C_ItemUpgrade.GetHighWatermarkForSlot(redundancySlot)

							local watermark = characterWatermark < accountWatermark and characterWatermark
								or accountWatermark

							local finalIlvlToCompareWith = upgradeTrack.max < watermark and upgradeTrack.max
								or watermark

							if currentItemLevel < finalIlvlToCompareWith then
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
	end
end
