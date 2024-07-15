function f(self, unitId, unitFrame, envTable)
	local textColor = "orange"
	local textSize = 12

	-- positioning
	local anchor = {
		side = 2, --1 = topleft 2 = left 3 = bottomleft 4 = bottom 5 = bottom right 6 = right 7 = topright 8 = top
		x = -15, --x offset
		y = 0, --y offset
	}

	function envTable.updateText(unitFrame)
		if not unitFrame or not unitFrame.namePlateIsQuestObjective or not unitFrame.QuestAmountCurrent then
			return
		end

		local text = unitFrame.QuestAmountTotal and unitFrame.QuestAmountTotal - unitFrame.QuestAmountCurrent
			or unitFrame.QuestAmountCurrent .. "%"

		local currentText = unitFrame.healthBar.questProgressTextFrame
				and unitFrame.healthBar.questProgressTextFrame:GetText()
			or nil

		if currentText == text then
			return
		end

		--create the text frame that will show the quest progress
		if not unitFrame.healthBar.questProgressTextFrame then
			envTable.questProgressTextFrame = Plater:CreateLabel(unitFrame.healthBar, "", textSize, textColor)
			Plater.SetAnchor(envTable.questProgressTextFrame, anchor)
			unitFrame.healthBar.questProgressTextFrame = envTable.questProgressTextFrame
		end

		unitFrame.healthBar.questProgressTextFrame:SetText(text)
	end
end
