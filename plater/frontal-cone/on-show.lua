function f(self, unitId, unitFrame, envTable, scriptTable)
	local mAT = unitFrame._movingArrowTexture

	mAT:SetTexture([[Interface\PETBATTLES\PetBattle-StatIcons]])
	mAT:SetSize(16, self:GetHeight())
	mAT:SetTexCoord(unpack({ 0, 15 / 32, 18 / 32, 30 / 32 }))
	mAT:SetParent(self.FrameOverlay)
	mAT:SetDrawLayer("overlay", 7)
	mAT:SetAlpha(scriptTable.config.arrowAlpha)
	mAT:SetDesaturated(scriptTable.config.desaturateArrow)

	mAT:ClearAllPoints()
	mAT:SetPoint("left", self, "left", -16, 0)

	local arrowAnimation = mAT.arrowAnimation
	arrowAnimation:SetDuration(scriptTable.config.animSpeed)
	arrowAnimation:SetOffset(self:GetWidth(), 0)

	mAT.movingAnimation:Play()

	if scriptTable.config.bChangeSpellName then
		self.Text:SetText(scriptTable.config.spellNameText)
	end

	--DetailsFramework:DebugVisibility(mAT)
end
