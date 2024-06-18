-- CLEU:SPELL_MISSED:SPELL_PERIODIC_MISSED:SPELL_AURA_REMOVED:SPELL_AURA_APPLIED:SPELL_DAMAGE:SPELL_HEAL:SPELL_PERIODIC_DAMAGE:SPELL_PERIODIC_HEAL:SPELL_AURA_APPLIED_DOSE:SPELL_AURA_REMOVED_DOSE:SPELL_SUMMON, UNIT_SPELLCAST_SUCCEEDED:player, XEPHUI_Highlighter, PLAYER_REGEN_ENABLED

--- @class HighlighterState
--- @field show boolean
--- @field changed boolean
--- @field stacks number
--- @field duration number
--- @field expirationTime number
--- @field autoHide true
--- @field progressType "timed"
--- @field icon number

--- @param states table<number, HighlighterState>
--- @param event "COMBAT_LOG_EVENT_UNFILTERED" | "STATUS" | "OPTIONS" | "UNIT_SPELLCAST_SUCCEEDED" | "XEPHUI_Highlighter" | "PLAYER_REGEN_ENABLED"
--- @return boolean
function f(states, event, ...)
	if WeakAuras.IsOptionsOpen() then
		states["a"] = {
			show = true,
			changed = true,
			stacks = math.random(25000, 2500000),
			icon = 5199630,
			duration = 5,
			expirationTime = GetTime() + 5,
			progressType = "timed",
			autoHide = true,
		}

		states["b"] = {
			show = true,
			changed = true,
			stacks = math.random(25000, 2500000),
			icon = 4622458,
			duration = 5,
			expirationTime = GetTime() + 5,
			progressType = "timed",
			autoHide = true,
		}

		return true
	end

	if not aura_env.active then
		return false
	end

	if event == "PLAYER_REGEN_ENABLED" then
		return aura_env.onPlayerRegenEnabled()
	end

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local subEvent = select(2, ...)
		local handler = aura_env.cleuMap[subEvent]

		if handler == nil then
			return false
		end

		local hasChanges = handler(...)

		if hasChanges then
			aura_env.queue()
		end

		return false
	end

	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		local spellId = select(3, ...)
		local hasChanges = aura_env.onSpellCastSuccess(spellId)

		if hasChanges then
			aura_env.queue()
		end

		return false
	end

	if event == aura_env.customEventName then
		local id = ...

		if id ~= aura_env.id then
			return false
		end

		aura_env.nextFrame = nil

		local hasChanges = false
		local now = GetTime()

		for index in pairs(aura_env.dirtyIndices) do
			local total, icon = aura_env.getDisplayDataForIndex(index)

			if states[index] then
				if not aura_env.isExpired(now, index) and states[index].stacks ~= total then
					hasChanges = true

					states[index].changed = true
					states[index].stacks = total

					-- on successful spellcast, this may be empty, so expire instantly in order to hide the icon while no value is shown anyways
					if total == 0 then
						states[index].show = false
						states[index].expirationTime = now
					else
						states[index].expirationTime = now + aura_env.config.duration
					end
				end
			elseif total > 0 then
				hasChanges = true

				states[index] = {
					show = true,
					changed = true,
					stacks = total,
					duration = aura_env.config.duration,
					expirationTime = now + aura_env.config.duration,
					autoHide = true,
					progressType = "timed",
					icon = icon,
				}
			end
		end

		return hasChanges
	end

	return false
end
