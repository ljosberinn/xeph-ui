function (_, unitId, unitFrame, envTable, scriptTable)
    --check if can change the nameplate color
    local targetName = UnitName(unitId .. "target")

    if not targetName then
        return
    end

    local role = UnitGroupRolesAssigned(unitId .. "target")

    -- ignore temporary fixates if the unit is targeting the tank (again)
    if role == "TANK" then
        Plater.StopDotAnimation(unitFrame.healthBar, unitFrame.healthBar.MainTargetDotAnimation)
        envTable.FixateTarget:Hide()

        return
    end

    if UnitIsUnit(targetName, "player") then
        Plater.SetNameplateColor(unitFrame, scriptTable.config.nameplateColor)

        if not envTable.colorchanged then
            Plater.StopDotAnimation(unitFrame.healthBar, unitFrame.healthBar.MainTargetDotAnimation)
            unitFrame.healthBar.MainTargetDotAnimation =
                Plater.PlayDotAnimation(unitFrame.healthBar, 2, scriptTable.config.dotsColor, 3, 4)

            envTable.colorchanged = true
        end
    end

    targetName = Plater.SetTextColorByClass(unitId .. "target", targetName)
    envTable.FixateTarget.text = targetName
    envTable.FixateTarget:Show()
end
