function (_, _, unitFrame, _, _)
    if unitFrame.healthBar.HealthFlashFrame then
        unitFrame.healthBar.HealthFlashFrame:StopAnimating()
    end
end