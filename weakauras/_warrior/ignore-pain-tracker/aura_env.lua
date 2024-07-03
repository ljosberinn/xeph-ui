---@type false|number
local numberOfDecimalPlaces = false

if aura_env.config.textOptions.numberOfDecimalPlaces == 2 then
	numberOfDecimalPlaces = 0
elseif aura_env.config.textOptions.numberOfDecimalPlaces == 3 then
	numberOfDecimalPlaces = 1
elseif aura_env.config.textOptions.numberOfDecimalPlaces == 4 then
	numberOfDecimalPlaces = 2
elseif aura_env.config.textOptions.numberOfDecimalPlaces == 5 then
	numberOfDecimalPlaces = 3
end

function aura_env.shortenNumber(number)
	local shortenedNumber = number

	local wasNegative = false
	if number < 0 then
		number = number * -1
		wasNegative = true
	end

	local suffix = ""
	if number >= 1000000 then
		shortenedNumber = shortenedNumber / 1000000
		suffix = "m"
	elseif number >= 1000 then
		shortenedNumber = shortenedNumber / 1000
		suffix = "k"
	end

	if not numberOfDecimalPlaces then
		if shortenedNumber >= 100 then
			shortenedNumber = string.format("%.0f", shortenedNumber)
		elseif shortenedNumber >= 10 then
			shortenedNumber = string.format("%.1f", shortenedNumber)
		elseif shortenedNumber >= 1 then
			shortenedNumber = string.format("%.2f", shortenedNumber)
		end
	elseif number >= 1000 then
		shortenedNumber = string.format("%." .. numberOfDecimalPlaces .. "f", shortenedNumber)
	end

	if aura_env.config.textOptions.dontShortenThousands and (number >= 1000 and number < 10000) then
		if wasNegative then
			number = number * -1
		end
		return number
	end

	return shortenedNumber .. suffix
end

function aura_env.shortenPercent(number)
	local shortenedNumber = number

	shortenedNumber =
		string.format("%." .. aura_env.config.textOptions.percentNumOfDecimalPlaces .. "f", shortenedNumber)

	if number <= 0 then
		shortenedNumber = 0
	end

	return shortenedNumber .. "%"
end

function aura_env.parseIgnorePainTooltipValue()
	local description = ""

	if GetSpellDescription then
		description = GetSpellDescription(190456)
	else
		description = C_Spell.GetSpellDescription(190456)
	end

	aura_env.tooltipAbsorb = tonumber((description:match("%%.+%d"):gsub("%D", ""))) or 0
end

aura_env.currentMaxHealth = UnitHealthMax("player")
aura_env.tooltipAbsorb = 0
aura_env.currentIgnorePainAbsorb = 0
aura_env.parseIgnorePainTooltipValue()
aura_env.overabsorb = 0
aura_env.lastIgnorePainAbsorb = 0
aura_env.changed = false

function aura_env.calcCurrentIgnorePainCap()
	return math.floor(aura_env.currentMaxHealth * 0.3)
end

function aura_env.determineTextOne(currentIgnorePainAbsorb, percentOfCap, additionalAbsorb, percentOfMaxHP)
	if aura_env.config.textOptions.text1 == 1 then
		return currentIgnorePainAbsorb
	end

	if aura_env.config.textOptions.text1 == 2 then
		return percentOfCap
	end

	if aura_env.config.textOptions.text1 == 3 then
		return additionalAbsorb
	end

	if aura_env.config.textOptions.text1 == 4 then
		return percentOfMaxHP
	end

	return ""
end

function aura_env.determineTextTwo(currentIgnorePainAbsorb, percentOfCap, additionalAbsorb, percentOfMaxHP)
	if aura_env.config.textOptions.text2 == 1 then
		return currentIgnorePainAbsorb
	end

	if aura_env.config.textOptions.text2 == 2 then
		return percentOfCap
	end

	if aura_env.config.textOptions.text2 == 3 then
		return additionalAbsorb
	end

	if aura_env.config.textOptions.text2 == 4 then
		return percentOfMaxHP
	end

	return ""
end

local function setVisuals(r, g, b, a, glow)
	local region = aura_env.region

	for i, subRegion in pairs(aura_env.region.subRegions) do
		if subRegion.type == "subtext" then
			local shouldUpdate = (i == 2 and aura_env.config.textOptions.colorText1)
				or (i == 3 and aura_env.config.textOptions.colorText2)

			if shouldUpdate then
				subRegion.text:SetTextColor(r, g, b, a)
				subRegion:Color(r, g, b, a)
			end
		end
	end

	if aura_env.config.iconOptions.glowCondition ~= 1 then
		region:SetGlow(glow)
	end
end

function aura_env.updateVisuals()
	if not aura_env.changed then
		return
	end

	local ignorePainCap = aura_env.calcCurrentIgnorePainCap()

	if
		(aura_env.currentIgnorePainAbsorb + aura_env.tooltipAbsorb <= ignorePainCap)
		or (aura_env.overabsorb >= aura_env.config.textOptions.thresholdPerc)
	then -- full cast
		local glow = aura_env.config.iconOptions.glowCondition == 2 or aura_env.config.iconOptions.glowCondition == 4

		setVisuals(
			aura_env.config.textOptions.fullCastColor[1],
			aura_env.config.textOptions.fullCastColor[2],
			aura_env.config.textOptions.fullCastColor[3],
			aura_env.config.textOptions.fullCastColor[4],
			glow
		)
	elseif aura_env.overabsorb >= 1 - aura_env.config.textOptions.thresholdPerc then -- cap cast
		local glow = aura_env.config.iconOptions.glowCondition == 3 or aura_env.config.iconOptions.glowCondition == 4

		setVisuals(
			aura_env.config.textOptions.capColor[1],
			aura_env.config.textOptions.capColor[2],
			aura_env.config.textOptions.capColor[3],
			aura_env.config.textOptions.capColor[4],
			glow
		)
	else -- capped
		setVisuals(
			aura_env.config.textOptions.clipColor[1],
			aura_env.config.textOptions.clipColor[2],
			aura_env.config.textOptions.clipColor[3],
			aura_env.config.textOptions.clipColor[4]
		)
	end
end
