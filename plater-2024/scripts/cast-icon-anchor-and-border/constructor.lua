function f(self, unitId, unitFrame, envTable)
	--settings:
	--show cast icon
	envTable.ShowIcon = Plater.db.profile.castbar_icon_show --true
	--anchor icon on what side
	envTable.IconAnchor = "left" --accep 'left' 'right'
	--fine tune the size of the icon
	envTable.IconSizeOffset = 0
	envTable.moveCastIcon = not Plater.db.profile.castbar_icon_customization_enabled --false

	--shield for non interruptible casts
	envTable.ShowShield = false
	envTable.ShieldTexture = [[Interface\GROUPFRAME\UI-GROUP-MAINTANKICON]]
	envTable.ShieldDesaturated = true
	envTable.ShieldColor = { 1, 1, 1, 1 }
	envTable.ShieldSize = { 10, 12 }

	--private:
	function envTable.UpdateIconPosition(unitFrame)
		if not envTable.moveCastIcon then
			return
		end
		local castBar = unitFrame.castBar
		local icon = castBar.Icon
		local shield = castBar.BorderShield

		if envTable.ShowIcon then
			icon:ClearAllPoints()

			if envTable.IconAnchor == "left" then
				icon:ClearAllPoints()
				icon:SetPoint("topright", unitFrame.healthBar, "topleft", 0, envTable.IconSizeOffset)
				icon:SetPoint("bottomright", unitFrame.castBar, "bottomleft", 0, 0)
			elseif envTable.IconAnchor == "right" then
				icon:ClearAllPoints()
				icon:SetPoint("topleft", unitFrame.healthBar, "topright", 0, envTable.IconSizeOffset)
				icon:SetPoint("bottomleft", unitFrame.castBar, "bottomright", 0, 0)
			end

			icon:SetWidth(icon:GetHeight())
			icon:Show()
		else
			icon:Hide()
		end

		if envTable.ShowShield and not castBar.canInterrupt then
			shield:Show()
			shield:SetAlpha(1)
			shield:SetTexCoord(0, 1, 0, 1)
			shield:SetVertexColor(1, 1, 1, 1)

			shield:SetTexture(envTable.ShieldTexture)
			shield:SetDesaturated(envTable.ShieldDesaturated)

			if not envTable.ShieldDesaturated then
				shield:SetVertexColor(DetailsFramework:ParseColors(envTable.ShieldColor))
			end

			shield:SetSize(unpack(envTable.ShieldSize))

			shield:ClearAllPoints()
			shield:SetPoint("center", castBar, "left", 0, 0)
		else
			shield:Hide()
		end
	end

	function envTable.UpdateBorder(unitFrame, casting)
		local healthBar = unitFrame.healthBar
		local castBar = unitFrame.castBar
		--casting = not casting == false or  ((castBar.casting or castBar.channeling) and not (castBar.interrupted or castBar.failed))

		if casting then
			if envTable.ShowIcon and castBar.Icon:IsShown() then
				if envTable.IconAnchor == "left" then
					healthBar.border:ClearAllPoints()
					PixelUtil.SetPoint(healthBar.border, "TOPLEFT", castBar.Icon, "TOPLEFT", 0, 0)
					PixelUtil.SetPoint(healthBar.border, "BOTTOMRIGHT", castBar, "BOTTOMRIGHT", 0, 0)
				elseif envTable.IconAnchor == "right" then
					healthBar.border:ClearAllPoints()
					PixelUtil.SetPoint(healthBar.border, "TOPRIGHT", castBar.Icon, "TOPRIGHT", 0, 0)
					PixelUtil.SetPoint(healthBar.border, "BOTTOMLEFT", castBar, "BOTTOMLEFT", 0, 0)
				end
			else
				if envTable.IconAnchor == "left" then
					healthBar.border:ClearAllPoints()
					PixelUtil.SetPoint(healthBar.border, "TOPLEFT", healthBar, "TOPLEFT", 0, 0)
					PixelUtil.SetPoint(healthBar.border, "BOTTOMRIGHT", castBar, "BOTTOMRIGHT", 0, 0)
				elseif envTable.IconAnchor == "right" then
					healthBar.border:ClearAllPoints()
					PixelUtil.SetPoint(healthBar.border, "TOPRIGHT", healthBar, "TOPRIGHT", 0, 0)
					PixelUtil.SetPoint(healthBar.border, "BOTTOMLEFT", castBar, "BOTTOMLEFT", 0, 0)
				end
			end
		else
			if envTable.IconAnchor == "left" then
				healthBar.border:ClearAllPoints()
				PixelUtil.SetPoint(healthBar.border, "TOPLEFT", healthBar, "TOPLEFT", 0, 0)
				PixelUtil.SetPoint(healthBar.border, "BOTTOMRIGHT", healthBar, "BOTTOMRIGHT", 0, 0)
			elseif envTable.IconAnchor == "right" then
				healthBar.border:ClearAllPoints()
				PixelUtil.SetPoint(healthBar.border, "TOPRIGHT", healthBar, "TOPRIGHT", 0, 0)
				PixelUtil.SetPoint(healthBar.border, "BOTTOMLEFT", healthBar, "BOTTOMLEFT", 0, 0)
			end
		end
	end

	if not unitFrame.castBar.borderChangeHooked then
		hooksecurefunc(unitFrame.castBar, "Hide", function()
			envTable.UpdateBorder(unitFrame, false)
		end)
		unitFrame.castBar.borderChangeHooked = true
	end
end
