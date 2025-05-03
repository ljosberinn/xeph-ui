---@class Spell
---@field interruptable boolean
---@field aoe boolean
---@field stoppable boolean
---@field name string
---@field icon number
---@field glowBelow number

---@type table<number, Spell>
aura_env.spells = {}

---@type table<string, string>
aura_env.unitsByGuid = {}

do
	local interruptable = 0
	local aoe = 0
	local stoppable = 0

	for _, spell in pairs(aura_env.config.spells) do
		local spellInfo = C_Spell.GetSpellInfo(spell.id)

		aura_env.spells[spell.id] = {
			interruptable = spell.interruptable,
			aoe = spell.aoe,
			stoppable = spell.stoppable,
			name = spellInfo.name,
			icon = spellInfo.iconID,
			glowBelow = spell.glowBelow,
		}

		if spell.interruptable then
			interruptable = interruptable + 1
		end

		if spell.aoe then
			aoe = aoe + 1
		end

		if spell.stoppable then
			stoppable = stoppable + 1
		end
	end

	print(
		format(
			"[%s] added %d spells (%s interruptable, %s stoppable, %s aoe)",
			aura_env.id,
			#aura_env.config.spells,
			interruptable,
			stoppable,
			aoe
		)
	)
end

local id = aura_env.id

local StartNameplateCallback = function(...)
	WeakAuras.ScanEvents("BWSPELLS_ADD", id, ...)
end

local StopNameplateCallback = function(...)
	WeakAuras.ScanEvents("BWSPELLS_REMOVE", id, ...)
end

local DisableCallback = function(...)
	WeakAuras.ScanEvents("BWSPELLS_DISABLE", id, ...)
end

BigWigsLoader.RegisterMessage(WeakAuras, "BigWigs_StartNameplate", StartNameplateCallback)
BigWigsLoader.RegisterMessage(WeakAuras, "BigWigs_StopNameplate", StopNameplateCallback)
BigWigsLoader.RegisterMessage(WeakAuras, "BigWigs_ClearNameplate", StopNameplateCallback)
BigWigsLoader.RegisterMessage(WeakAuras, "BigWigs_StopBars", DisableCallback)
BigWigsLoader.RegisterMessage(WeakAuras, "BigWigs_OnBossDisable", DisableCallback)
BigWigsLoader.RegisterMessage(WeakAuras, "BigWigs_OnBossWipe", DisableCallback)
