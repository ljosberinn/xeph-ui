function (_, _, unitFrame, _, scriptTable)
    local isDebuffed = scriptTable.isDebuffed(unitFrame)

    if isDebuffed then
        Plater.SetNameplateScale(unitFrame, scriptTable.config.debuffed)
        -- instantly ccd enemies (e.g. freeze trap) never had the animation start
        if unitFrame.healthBar.HealthFlashFrame then
            unitFrame.healthBar.HealthFlashFrame:StopAnimating()
        end
    else
        Plater.SetNameplateScale(unitFrame, scriptTable.config.casting)
        Plater.FlashNameplateBorder(unitFrame)
    end
end
