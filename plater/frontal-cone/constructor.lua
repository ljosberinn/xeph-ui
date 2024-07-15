function f(self, unitId, unitFrame, envTable, scriptTable)
	--get the reference of the arrow texture
	local movingArrowTexture = unitFrame._movingArrowTexture

	--if it doesn't exists yet, create now
	if not movingArrowTexture then
		movingArrowTexture = self:CreateTexture(nil, "artwork", nil, 6)
		unitFrame._movingArrowTexture = movingArrowTexture
	end

	local mAT = movingArrowTexture

	if not mAT.movingAnimation then
		local onPlay = function()
			mAT:Show()
		end

		local onStop = function()
			mAT:Hide()
		end

		mAT.movingAnimation = Plater:CreateAnimationHub(mAT, onPlay, onStop)
		mAT.movingAnimation:SetLooping("REPEAT")
	end

	if not mAT.arrowAnimation then
		local arrowAnimation =
			Plater:CreateAnimation(mAT.movingAnimation, "translation", 1, 0.20, self:GetWidth() - 16, 0)
		mAT.arrowAnimation = arrowAnimation
	end
end
