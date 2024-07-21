function f(self, unitId, unitFrame, envTable, modTable)
	function Plater.UpdateLifePercentText(healthBar, unitId, showHealthAmount, showPercentAmount, showDecimals) -- ~health
		--get the cached health amount for performance
		local currentHealth, maxHealth = healthBar.CurrentHealth, healthBar.CurrentHealthMax

		if showHealthAmount and showPercentAmount then
			local percent = maxHealth == 0 and 100 or (currentHealth / maxHealth * 100)

			if showDecimals then
				if percent < 10 then
					healthBar.lifePercent:SetText(Plater.FormatNumber(currentHealth) .. format(" %.2f%%", percent))
				elseif percent < 99.9 then
					healthBar.lifePercent:SetText(Plater.FormatNumber(currentHealth) .. format(" %.1f%%", percent))
				else
					healthBar.lifePercent:SetText(Plater.FormatNumber(currentHealth) .. " 100%")
				end
			else
				healthBar.lifePercent:SetText(Plater.FormatNumber(currentHealth) .. format(" %d%%", percent))
			end
		elseif showHealthAmount then
			healthBar.lifePercent:SetText(Plater.FormatNumber(currentHealth))
		elseif showPercentAmount then
			local percent = maxHealth == 0 and 100 or (currentHealth / maxHealth * 100)

			if showDecimals then
				if percent < 10 then
					healthBar.lifePercent:SetText(format("%.2f%%", percent))
				elseif percent < 99.9 then
					healthBar.lifePercent:SetText(format("%.1f%%", percent))
				else
					healthBar.lifePercent:SetText("100%")
				end
			else
				healthBar.lifePercent:SetText(format("%d%%", percent))
			end
		else
			healthBar.lifePercent:SetText("")
		end
	end
end
