function (_, _, unitFrame, envTable, scriptTable)
    envTable.FixateTarget = Plater:CreateLabel(unitFrame)
    envTable.FixateTarget:SetPoint("bottom", unitFrame.BuffFrame, "top", -100, -16)
    envTable.FixateTarget.outline = scriptTable.config.outline
    envTable.FixateTarget:Hide()
end
