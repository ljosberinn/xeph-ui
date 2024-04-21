function aura_env.getSoulFragmentCount()
	return select(3, WA_GetUnitBuff("player", 203981)) or 0
end

function aura_env.getPlayerMaxHealth()
	return UnitHealthMax("player")
end

function aura_env.getCurrentPlayerHealth()
	return UnitHealth("player")
end

function aura_env.maybeToggleDivineHymn()
	aura_env.divineHymnStacks = select(3, WA_GetUnitBuff("player", 64844)) or 0
end

function aura_env.maybeToggleGuardianSpirit()
	aura_env.guardianSpiritActive = WA_GetUnitBuff("player", 47788) ~= nil
end

function aura_env.maybeToggleLuckyOfTheDraw()
	aura_env.luckyOfTheDrawStacks = select(3, WA_GetUnitBuff("player", 72221)) or 0
end

function aura_env.maybeToggleBlessingOfSpring()
	aura_env.blessingOfSpringActive = WA_GetUnitBuff("player", 388013) ~= nil
end

aura_env.luckyOfTheDrawStacks = 0
aura_env.divineHymnStacks = 0
aura_env.guardianSpiritActive = false
aura_env.blessingOfSpringActive = false

aura_env.maybeToggleGuardianSpirit()
aura_env.maybeToggleDivineHymn()
aura_env.maybeToggleLuckyOfTheDraw()
aura_env.maybeToggleBlessingOfSpring()

aura_env.currentHealth = aura_env.getCurrentPlayerHealth()
aura_env.maxHealth = aura_env.getPlayerMaxHealth()

aura_env.lastFragments = aura_env.getSoulFragmentCount()
aura_env.currentFragments = aura_env.lastFragments

local damageTaken = {}

function aura_env.appendDamageTaken(timestamp, amount)
	table.insert(damageTaken, { timestamp, amount })
end

function aura_env.getSumOfRecentDamageTaken()
	local i = 1
	local sum = 0
	local now = time()

	while damageTaken[i] do
		if now > damageTaken[i][1] + 5 then
			table.remove(damageTaken, i)
		else
			sum = sum + damageTaken[i][2]
		end

		i = i + 1
	end

	return sum
end

function aura_env.getCurrentVersatilityFactor()
	return 1
		+ (GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)) / 100
end

do
	local region = WeakAuras.GetRegion(aura_env.id)

	if region then
		local frame = SUFUnitplayer or PlayerFrame
		local _, _, width, height = frame:GetRect()

		region:SetSize(width, height)
	end
end

aura_env.hasT302SetEquipped = nil
