aura_env.lastScan = 0
aura_env.remainingTime = 0

aura_env.active = false
aura_env.icon = nil
aura_env.lastSeenItemCount = 0

local enchantIdToUse = nil
local mainHandEnchanted = false
local offHandEnchanted = false

function aura_env.setup()
	enchantIdToUse = nil
	mainHandEnchanted = false
	offHandEnchanted = false

	aura_env.active = false
	aura_env.lastSeenItemCount = 0
	aura_env.lastScan = 0
	aura_env.icon = nil
	aura_env.remainingTime = 0

	local specIndex = GetSpecialization()

	if not specIndex then
		return
	end

	local currentSpecId = GetSpecializationInfo(specIndex)

	local consumableIdToMap = {
		-- 1 equals disabled
		[2] = {
			[194820] = 6518, -- Howling Rune q3
		},
		[3] = {
			[194823] = 6514, -- Buzzing Rune q3
		},
		[4] = {
			[191940] = 6381, -- Primal Whetstone (135)
		},
		[5] = {
			[204973] = 6839, -- Hissing Rune q3
		},
	}

	for _, config in pairs(aura_env.config.spec) do
		if config.specId == currentSpecId then
			if config.consumable > 1 then
				aura_env.active = true

				for itemId, enchantId in pairs(consumableIdToMap[config.consumable]) do
					aura_env.icon = aura_env.icon or select(10, C_Item.GetItemInfo(itemId))
					enchantIdToUse = enchantId

					local count = C_Item.GetItemCount(itemId)

					if count > 0 then
						aura_env.lastSeenItemCount = count
					end
				end
			end

			break
		end
	end
end

aura_env.setup()

function aura_env.isEnchanted()
	if not aura_env.active or enchantIdToUse == nil then
		return false
	end

	aura_env.lastScan = GetTime()

	local _, mainHandExpiration, _, mainHandEnchantID, _, _, _, offHandEnchantID = GetWeaponEnchantInfo()

	mainHandEnchanted = mainHandEnchantID == enchantIdToUse
	offHandEnchanted = IsDualWielding() and offHandEnchantID == enchantIdToUse or true

	if mainHandEnchanted and offHandEnchanted then
		aura_env.remainingTime = math.floor(mainHandExpiration / 1000)
		return true
	end

	aura_env.remainingTime = 0

	return false
end
