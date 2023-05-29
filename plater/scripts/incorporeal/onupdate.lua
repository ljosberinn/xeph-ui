function (_, unitId, unitFrame, _, scriptTable)
    local isDebuffed = scriptTable.isDebuffed(unitId)

    if isDebuffed then
        Plater.SetNameplateScale(unitFrame, scriptTable.config.debuffedScale)
        -- instantly ccd enemies (e.g. freeze trap) never had the animation start
        if unitFrame.healthBar.HealthFlashFrame then
            unitFrame.healthBar.HealthFlashFrame:StopAnimating()
        end
    else
        Plater.SetNameplateScale(unitFrame, scriptTable.config.activeScale)
        Plater.FlashNameplateBorder(unitFrame)
    end
end