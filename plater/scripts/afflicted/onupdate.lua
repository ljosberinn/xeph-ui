function (_, unitId, unitFrame, _, scriptTable)
    local color = scriptTable.determineDebuffColor(unitId)

    if color then
        Plater.SetNameplateScale(unitFrame, scriptTable.config.activeScale)
        Plater.FlashNameplateBorder(unitFrame)
        Plater.SetNameplateColor(unitFrame, color)
    end
end