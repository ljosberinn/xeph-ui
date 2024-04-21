aura_env.customEventName = "XEPHUI_EMERALD_TRANCE"
aura_env.emeraldTranceBuffId = 424402
aura_env.timer = nil
aura_env.active = false

do
	local equipped = 0

	local items = {
		207225, -- shoulder
		207226, -- legs
		207227, -- head
		207228, -- gloves
		207230, -- chest
	}

	for _, id in pairs(items) do
		if C_Item.IsEquippedItem(id) then
			equipped = equipped + 1
		end
	end

	aura_env.active = equipped >= 4
end

function aura_env.queue()
	if aura_env.timer and not aura_env.timer:IsCancelled() then
		aura_env.timer:Cancel()
	end

	local customEventName = aura_env.customEventName
	local id = aura_env.id

	aura_env.timer = C_Timer.NewTimer(5, function()
		WeakAuras.ScanEvents(customEventName, id)
	end)
end
