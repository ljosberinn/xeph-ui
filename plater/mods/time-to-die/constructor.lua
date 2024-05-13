function (self, unitId, unitFrame, envTable)
    -- Credit to Aethys for the algorithm: https://github.com/herotc/hero-lib

    --general settings:
    envTable.onlyShowOnBoss = false
    envTable.includeShields = true

    --custom health% for specific units:
    envTable.customPercent = {
        ----- Shadowlands
        -- Sanguine Depths
        [162099] = 50, -- General Kaal
        --- De Other Side
        [166608] = 10, --Mueh'Zala
        --- Mists of Tirna Scithe
        [164929] = 20, -- Tirnenn Villager
        [164804] = 20, -- Droman Oulfarran
        ----- Draenor
        --- Shadowmoon Burial Ground
        [76057] = 20.5, -- Carrion Worm
        ----- Legion
        -- Halls of Valor
        [95674] = 60.5, -- Fenryr P1
        [95676] = 80.5, -- Odyn
        [94960] = 10.5, -- Hymdall
        -- Court of Stars
        [104215] = 20.5, -- Patrol Captain Gerdo
        ----- Mists of Pandaria
        -- Temple of the Jade Serpent
        [56732] = 29.5, -- Liu Flameheart,
        ----- Dragonflight
        -- Brackenhide Hollow
        [186121] = 4, -- Decatriarch Wratheye
        -- Uldaman
        [184580] = 10, -- Olaf
        [184581] = 10, -- Baelog
        [184582] = 10, -- Eric "The Swift"
        [184125] = 1, -- Chrono-Lord Deios,
        -- Doti lower
        [198933] = 90, -- Iridikron, technically 85 but you care only until 90
        [198997] = 80, -- Blight of Galakrond
        [201792] = 50, -- Ahnzon
    }

    -- text settings:
    local textColor = "white"
    local textSize = 12
    local textFont = "2002"
    local textOutline = "NONE" --"OUTLINE"
    --local textShadowColor = "green"

    -- positioning
    local anchor = {
        side = 3, --1 = topleft 2 = left 3 = bottomleft 4 = bottom 5 = bottom right 6 = right 7 = topright 8 = top
        x = 2, --x offset
        y = -3 --y offset
    }

    -- TTD calculation config
    envTable.config = {
        historyCount = 100,
        historyTime = 10,
        duration = 600,
        pctHP = 0
    }

    ---------------------------------------------------------------------------------------------------------------------------------------------

    --frames:

    --create the text frame that will show the TTD
    if (not unitFrame.healthBar.ttdTextFrame) then
        envTable.ttdTextFrame = Plater:CreateLabel(unitFrame.healthBar, "", textSize, textColor)
        unitFrame.healthBar.ttdTextFrame = envTable.ttdTextFrame
        envTable.ttdTextFrame:SetText("")
    end

    Plater.SetAnchor(unitFrame.healthBar.ttdTextFrame, anchor)

    if textFont then
        DetailsFramework:SetFontFace(unitFrame.healthBar.ttdTextFrame, textFont)
    end
    if textSize then
        DetailsFramework:SetFontSize(unitFrame.healthBar.ttdTextFrame, textSize)
    end
    if textOutline then
        DetailsFramework:SetFontOutline(unitFrame.healthBar.ttdTextFrame, textOutline)
    end
    if textColor then
        local r, g, b, a = DetailsFramework:ParseColors(textColor)
        unitFrame.healthBar.ttdTextFrame:SetTextColor(r, g, b, a)
    end
    if textShadowColor then
        local r, g, b, a = DetailsFramework:ParseColors(textShadowColor)
        DetailsFramework:SetFontShadow(unitFrame.healthBar.ttdTextFrame, r, g, b, a, 1, -1)
    end

    ---------------------------------------------------------------------------------------------------------------------------------------------
    --functions

    envTable.cache = {}
    envTable.units = {}

    function envTable.TTDRefresh(unit)
        local currentTime = GetTime()
        local historyCount = envTable.config.historyCount
        local historyTime = envTable.config.historyTime

        if UnitExists(unit) then
            local GUID = UnitGUID(unit)
            if not GUID then
                return
            end

            local health = UnitHealth(unit)
            local maxHealth = UnitHealthMax(unit)
            local absorbsPercent = 0

            if UnitGetTotalAbsorbs and envTable.includeShields then
                local absorbs = UnitGetTotalAbsorbs(unit)
                health = health + absorbs
                absorbsPercent = absorbs ~= -1 and maxHealth ~= -1 and absorbs / maxHealth * 100 or 0
            end

            local healthPercentage = health ~= -1 and maxHealth ~= -1 and health / maxHealth * 100
            -- Check if it's a valid unit
            if UnitCanAttack("player", unit) and healthPercentage < (100 + absorbsPercent) then
                local unitTable = envTable.units[GUID]
                -- Check if we have seen one time this unit, if we don't then initialize it.
                if not unitTable or healthPercentage > unitTable[1][1][2] then
                    unitTable = {{}, currentTime}
                    envTable.units[GUID] = unitTable
                end

                local values = unitTable[1]
                local time = currentTime - unitTable[2]
                -- Check if the % HP changed since the last check (or if there were none)
                if #values == 0 or healthPercentage ~= values[1][2] then
                    local value
                    local lastIndex = #envTable.cache
                    -- Check if we can re-use a table from the cache -- Buds: i have doubt on the value of reusing table, with the high cost of tinsert on 1st index
                    if lastIndex == 0 then
                        value = {time, healthPercentage}
                    else
                        value = envTable.cache[lastIndex]
                        envTable.cache[lastIndex] = nil
                        value[1] = time
                        value[2] = healthPercentage
                    end
                    table.insert(values, 1, value)
                    local n = #values
                    -- Delete values that are no longer valid
                    while (n > historyCount) or (time - values[n][1] > historyTime) do
                        envTable.cache[#envTable.cache + 1] = values[n]
                        values[n] = nil
                        n = n - 1
                    end
                end
            end
        end
    end

    function envTable.TimeToX(guid, percentage, minSamples)
        local seconds = 8888
        local unitTable = envTable.units[guid]
        -- Simple linear regression
        -- ( E(x^2)  E(x) )  ( a )  ( E(xy) )
        -- ( E(x)     n  )  ( b ) = ( E(y)  )
        -- Format of the above: ( 2x2 Matrix ) * ( 2x1 Vector ) = ( 2x1 Vector )
        -- Solve to find a and b, satisfying y = a + bx
        -- Matrix arithmetic has been expanded and solved to make the following operation as fast as possible
        if unitTable then
            local values = unitTable[1]
            local n = #values
            if n > minSamples then
                local a, b = 0, 0
                local Ex2, Ex, Exy, Ey = 0, 0, 0, 0

                local value, x, y
                for i = 1, n do
                    value = values[i]
                    x, y = value[1], value[2]

                    Ex2 = Ex2 + x * x
                    Ex = Ex + x
                    Exy = Exy + x * y
                    Ey = Ey + y
                end
                -- invariant to find matrix inverse
                local invariant = 1 / (Ex2 * n - Ex * Ex)
                -- Solve for a and b
                a = (-Ex * Exy * invariant) + (Ex2 * Ey * invariant)
                b = (n * Exy * invariant) - (Ex * Ey * invariant)
                if b ~= 0 then
                    -- Use best fit line to calculate estimated time to reach target health
                    seconds = (percentage - a) / b
                    -- Subtract current time to obtain "time remaining"
                    seconds = math.min(7777, seconds - (GetTime() - unitTable[2]))
                    if seconds < 0 then
                        seconds = 9999
                    end
                end
            end
        end
        return seconds
    end

    function envTable.updateUnit(unitId, npcId)
        if UnitExists(unitId) and (not envTable.onlyShowOnBoss or UnitLevel(unitId) == -1) then
            envTable.TTDRefresh(unitId)
            local GUID = UnitGUID(unitId)
            local customPercent = envTable.customPercent[npcId] or nil
            envTable.TTD = envTable.TimeToX(GUID, customPercent or envTable.config.pctHP, 3)
            if envTable.TTD < 7777 and envTable.TTD < envTable.config.duration then
                envTable.show = true
                envTable.updateText()
            end
        end
    end

    function envTable.updateText()
        local ret = ""

        local number = envTable.TTD

        if not number or number == 0 or not envTable.show then
            unitFrame.healthBar.ttdTextFrame:SetText("")
            return
        end

        local H = floor(number / 3600)
        local M = floor((number - (floor(number / 3600) * 3600)) / 60)
        local S = number - math.floor(number / 60) * 60
        if H > 0 then
            ret = ("%02d:%02d:%02d"):format(H, M, S)
        elseif M > 0 then
            ret = ("%02d:%02d"):format(M, S)
        else
            ret = floor(S)
        end

        unitFrame.healthBar.ttdTextFrame:SetText(ret)
    end
end
