aura_env.customEventName = "XEPHUI_BREATH_OF_EONS_ANNOUNCER"
aura_env.timer = nil

---@type table<string, number>
aura_env.bySource = {}

function aura_env.enqueue()
	if aura_env.timer then
		if not aura_env.timer:IsCancelled() then
			aura_env.timer:Cancel()
		end

		aura_env.timer = nil
	end

	aura_env.timer = C_Timer.NewTimer(3, function()
		WeakAuras.ScanEvents(aura_env.customEventName, aura_env.id)
	end)
end

local baseBlueprint = C_Spell.GetSpellName(403631) .. " hit for %s!"
local maxContributorBlueprint = "Highest contributor: %s with %s (%s%%)"

---@param number number
---@return string|number
local function formatNumber(number)
	if number > 1000000 then
		return string.format("%1.fM", number / 1000000)
	end

	if number > 1000 then
		return string.format("%1.fK", number / 1000)
	end

	return number
end

---@return string
function aura_env.getMessage()
	local total = 0
	local individualMax = 0
	local maxSource = nil

	for sourceGUID, amount in pairs(aura_env.bySource) do
		total = total + amount

		if amount > individualMax then
			individualMax = amount
			maxSource = sourceGUID
		end
	end

	table.wipe(aura_env.bySource)

	local base = string.format(baseBlueprint, formatNumber(total))

	if aura_env.config.includeContributor and individualMax > 0 and maxSource ~= nil then
		local token = UnitTokenFromGUID(maxSource)
		local name = token and UnitName(token) or nil

		if name then
			return string.format(
				base .. " " .. maxContributorBlueprint,
				name,
				formatNumber(individualMax),
				string.format("%.1f", individualMax / total * 100)
			)
		end
	end

	return base
end
