aura_env.debuffId = 433522
aura_env.executeId = 433549

---@type table<string, number>
aura_env.debuffedEnemies = {}

aura_env.progress = {
	total = 0,
	unitCount = 0,
}

---@type string|nil
aura_env.trinketLink = nil

do
	local slots = { INVSLOT_TRINKET1, INVSLOT_TRINKET2 }

	for i = 1, #slots do
		local itemLoc = ItemLocation:CreateFromEquipmentSlot(slots[i])

		if itemLoc:IsValid() and C_Item.GetItemID(itemLoc) == 212684 then
			aura_env.trinketLink = C_Item.GetItemLink(itemLoc)
			break
		end
	end

	if not aura_env.trinketLink then
		aura_env.trinketLink = "Umbreskul's"
	end
end

---ty for @Domi94_ for this idea
---@param executeValue number
---@param timestamp number
---@param sourceGUID string
---@param sourceName string
---@param sourceFlags number
---@param targetGUID string
---@param targetName string
---@param targetFlags number
---@param targetRaidFlags number
---@param spellId number
---@param spellName string
---@param spellType number
function aura_env.maybeAddToDetails(
	timestamp,
	sourceGUID,
	sourceName,
	sourceFlags,
	targetGUID,
	targetName,
	targetFlags,
	targetRaidFlags,
	spellId,
	spellName,
	spellType,
	executeValue
)
	if not _G._detalhes or not _G._detalhes.parser then
		return
	end

	_G._detalhes.parser:spell_dmg(
		"SPELL_DAMAGE",
		timestamp,
		sourceGUID,
		sourceName,
		sourceFlags,
		targetGUID,
		targetName,
		targetFlags,
		targetRaidFlags,
		spellId,
		spellName,
		spellType,
		executeValue
	)
end

local chatOutputChannel = aura_env.config.chatOutput == 1 and "SAY"
	or aura_env.config.chatOutput == 2 and "EMOTE"
	or nil

---@param message string
function aura_env.sendMessage(message)
	if chatOutputChannel and IsInInstance() then
		SendChatMessage(message, chatOutputChannel)
	else
		print(message)
	end
end
