function f(self, unitId, unitFrame, envTable, scriptTable)
	local mAT = unitFrame._movingArrowTexture
	local maxAlpha = scriptTable.config.arrowAlpha

	mAT:SetAlpha(scriptTable.config.arrowAlpha)

	local percent = mAT.movingAnimation:GetProgress()

	if percent < 0.20 then
		local value = DetailsFramework.Math.MapRangeClamped(0, 0.20, 0, maxAlpha, percent)
		mAT:SetAlpha(value)
	elseif percent > 0.8 then
		local value = DetailsFramework.Math.MapRangeClamped(0.8, 1, maxAlpha, 0, percent)
		mAT:SetAlpha(value)
	end

	self.ThrottleUpdate = 0

	--mAT:SetAlpha(1)
end
