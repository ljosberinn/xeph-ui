function (_, _, unitFrame, envTable)
    Plater.StopDotAnimation(unitFrame.healthBar, unitFrame.healthBar.MainTargetDotAnimation)
    envTable.FixateTarget:Hide()
end
