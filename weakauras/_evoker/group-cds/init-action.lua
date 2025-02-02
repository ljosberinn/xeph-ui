aura_env.customEventName = "XEPHUI_CD_CHECK"
aura_env.breathOfSindragosaBuffId = 152279

--- @type table<number, number>
aura_env.trackedCasts = {}

--- @type table<number, true>
aura_env.trackedBuffs = {}

for _, buff in pairs(aura_env.config.buffs) do
	if buff.active then
		aura_env.trackedBuffs[buff.id] = true
	end
end

for _, cast in pairs(aura_env.config.casts) do
	if cast.active then
		aura_env.trackedCasts[cast.id] = cast.duration
	end
end

---@param spellId number
---@return string, number
function aura_env.getSpellInfo(spellId)
	local name = C_Spell.GetSpellName(spellId)
	local icon = C_Spell.GetSpellTexture(spellId)
	return name, icon
end

--- @param unit string
--- @param spellId number
--- @return number, number, number, string
function aura_env.getAuraMeta(unit, spellId)
	if spellId == aura_env.breathOfSindragosaBuffId then
		return 60, GetTime() + 60, 1029007, C_Spell.GetSpellName(spellId)
	end

	local duration = 0
	local expirationTime = 0
	local name = "Unknown"
	local icon = 0

	AuraUtil.ForEachAura(
		unit,
		"HELPFUL",
		nil,
		---@param AuraData
		function(auraInfo)
			if auraInfo.spellId == spellId then
				if DevTool then
					DevTool:AddData(auraInfo)
					print(string.format("[%s] added DevTool entry, use /dev", aura_env.id))
				end

				duration = auraInfo.duration
				expirationTime = auraInfo.expirationTime
				name = auraInfo.name
				icon = auraInfo.icon
				return true
			end

			return false
		end,
		true
	)

	return duration, expirationTime, icon, name
end

--- @type table<string, cbObject>
local tickers = {}

--- @param guid string
--- @param spellId number
--- @return string
function aura_env.createKey(guid, spellId)
	return guid .. "||" .. spellId
end

--- @param unit string
--- @param guid string
--- @param spellId number
--- @param key string
function aura_env.enqueuePoll(unit, guid, spellId, key)
	local id = aura_env.id
	local customEventName = aura_env.customEventName

	-- refresh events shouldn't enqueue another ticker, so clear out old
	aura_env.clearTickerFor(key)

	tickers[key] = C_Timer.NewTicker(2, function()
		WeakAuras.ScanEvents(customEventName, id, unit, guid, spellId)
	end)
end

--- @param key string
function aura_env.clearTickerFor(key)
	if tickers[key] ~= nil then
		tickers[key]:Cancel()
		tickers[key] = nil
	end
end

---@type table<string, string||nil>
local guidUnitCache = {}

---@param guid string
---@return boolean
local function guidIsDps(guid)
	local unit = UnitTokenFromGUID(guid)

	guidUnitCache[guid] = unit

	if not unit or not UnitIsFriend("player", unit) then
		return false
	end

	local role = UnitGroupRolesAssigned(unit)

	return role ~= "TANK" and role ~= "HEALER"
end

--- @param spellId number
--- @param sourceGUID string
--- @param targetGUID string
--- @return string||nil, string||nil
function aura_env.getBuffedPlayerGuid(spellId, sourceGUID, targetGUID)
	if guidIsDps(sourceGUID) then
		return sourceGUID, guidUnitCache[sourceGUID]
	end

	-- show pi on target
	if spellId == 10060 and guidIsDps(targetGUID) then
		return targetGUID, guidUnitCache[targetGUID]
	end
end

aura_env.ttsVoiceId = 0

local theVoices = C_VoiceChat.GetTtsVoices()

for i = 1, #theVoices do
	local voice = theVoices[i]

	if string.find(string.lower(voice.name), "english") then
		aura_env.ttsVoiceId = voice.voiceID
		break
	end
end

---@param name string
---@param duration number
function aura_env.maybeTextToSpeech(name, duration)
	if aura_env.config.ttsActive and duration >= aura_env.config.ttsThreshold then
		C_VoiceChat.SpeakText(
			aura_env.ttsVoiceId,
			name,
			Enum.VoiceTtsDestination.LocalPlayback,
			C_TTSSettings and C_TTSSettings.GetSpeechRate() or 0,
			C_TTSSettings and C_TTSSettings.GetSpeechVolume() or 100
		)
	end
end
