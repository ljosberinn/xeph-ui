function (_, unitId, unitFrame, _, scriptTable)
    local isDebuffed = scriptTable.isDebuffed(unitId)

    if isDebuffed then
        Plater.SetNameplateScale(unitFrame, scriptTable.config.debuffedScale)
        unitFrame.healthBar.HealthFlashFrame:StopAnimating()
    else
        Plater.SetNameplateScale(unitFrame, scriptTable.config.activeScale)
        Plater.FlashNameplateBorder(unitFrame)
    end
end