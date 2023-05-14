function (self, unitId, unitFrame, envTable, scriptTable)
    if (unitFrame.healthMarker) then
        unitFrame.healthMarker:Hide()
        unitFrame.healthOverlay:Hide()
    end
end