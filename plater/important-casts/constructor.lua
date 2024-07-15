function f(self, unitId, unitFrame, envTable, scriptTable)
	--create a texture to use for a flash behind the cast bar
	local backGroundFlashTexture = Plater:CreateImage(
		self,
		[[Interface\ACHIEVEMENTFRAME\UI-Achievement-Alert-Glow]],
		self:GetWidth() + 40,
		self:GetHeight() + 20,
		"background",
		{ 0, 400 / 512, 0, 170 / 256 }
	)
	backGroundFlashTexture:SetBlendMode("ADD")
	backGroundFlashTexture:SetDrawLayer("OVERLAY", 7)
	backGroundFlashTexture:SetPoint("center", self, "center")
	backGroundFlashTexture:SetVertexColor(Plater:ParseColors(scriptTable.config.flashColor))
	backGroundFlashTexture:Hide()

	--create the animation hub to hold the flash animation sequence
	envTable.BackgroundFlash = envTable.BackgroundFlash
		or Plater:CreateAnimationHub(backGroundFlashTexture, function()
			backGroundFlashTexture:Show()
		end, function()
			backGroundFlashTexture:Hide()
		end)

	--create the flash animation sequence
	local fadeIn =
		Plater:CreateAnimation(envTable.BackgroundFlash, "ALPHA", 1, scriptTable.config.flashDuration / 2, 0, 1)
	local fadeOut =
		Plater:CreateAnimation(envTable.BackgroundFlash, "ALPHA", 2, scriptTable.config.flashDuration / 2, 1, 0)

	--create a camera shake for the nameplate
	envTable.FrameShake = Plater:CreateFrameShake(
		unitFrame,
		scriptTable.config.shakeDuration,
		scriptTable.config.shakeAmplitude,
		scriptTable.config.shakeFrequency,
		false,
		false,
		0,
		1,
		0.05,
		0.1,
		Plater.GetPoints(unitFrame)
	)

	--update the config for the flash here so it wont need a /reload
	fadeIn:SetDuration(scriptTable.config.flashDuration / 2)
	fadeOut:SetDuration(scriptTable.config.flashDuration / 2)

	--update the config for the skake here so it wont need a /reload
	envTable.FrameShake.OriginalAmplitude = scriptTable.config.shakeAmplitude
	envTable.FrameShake.OriginalDuration = scriptTable.config.shakeDuration
	envTable.FrameShake.OriginalFrequency = scriptTable.config.shakeFrequency
end
