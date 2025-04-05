aura_env.customEventName = "XEPHUI_ShieldUpdate"
aura_env.timer = nil

function aura_env.queue()
	if aura_env.timer then
		return
	end

	local customEventName, id = aura_env.customEventName, aura_env.id

	aura_env.nextFrame = C_Timer.NewTimer(0.1, function()
		WeakAuras.ScanEvents(customEventName, id)
	end)
end
