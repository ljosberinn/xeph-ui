function f(self, unitId, unitFrame, envTable)
	--settings:
	envTable.ShowMaxHealth = false
	envTable.ShowPercent = true
	envTable.Separator = " "

	--privite:
	function envTable.UpdateHealth(unitFrame)
		--get the health and health max current values
		local currentHealth = unitFrame.healthBar.CurrentHealth or 0
		local currentHealthMax = unitFrame.healthBar.CurrentHealthMax or 0

		--build the string text with current health
		local healthString = Plater.FormatNumber(currentHealth) .. ""

		--if is showing max health, add it in the health string text
		if envTable.ShowMaxHealth then
			healthString = healthString .. envTable.Separator .. Plater.FormatNumber(currentHealthMax)
		end

		--if is showing the percent text, add it into the string text
		if envTable.ShowPercent then
			local percent = currentHealth / currentHealthMax * 100
			local fraction = "%.1f"

			if percent == 100 then
				fraction = "%.0f"
			elseif percent < 10 then
				fraction = "%.2f"
			end

			if envTable.ShowMaxHealth then
				healthString = healthString .. " (" .. format(fraction, percent) .. "%)"
			else
				healthString = healthString .. envTable.Separator .. format(fraction, percent) .. "%"
			end
		end

		--set the string text
		unitFrame.healthBar.lifePercent:SetText(healthString)
	end
end
