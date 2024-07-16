function f(modTable)
	if modTable.target.id then
		EventRegistry:UnregisterFrameEventAndCallback("PLAYER_TARGET_CHANGED", modTable.target.id)
	end

	if modTable.focus.id then
		EventRegistry:UnregisterFrameEventAndCallback("PLAYER_FOCUS_CHANGED", modTable.focus.id)
	end
end
