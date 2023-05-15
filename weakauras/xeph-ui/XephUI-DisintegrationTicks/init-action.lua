local bar = aura_env.region.relativeTo

local ticks = {}
for i = 1, 3 do
    local tickMark = aura_env.region:CreateTexture()
    tickMark:SetDrawLayer("OVERLAY", 7)
    tickMark:SetColorTexture(1, 1, 1, 1)
    tickMark:SetSize(2, bar:GetHeight() * 0.9)
    tickMark:SetPoint("CENTER", bar, "LEFT", 0, 0)
    tickMark:Hide()

    ticks[i] = tickMark
end

aura_env.disintegrate = 356995

--- @return number
local function GetBaseDuration()
    local base = IsPlayerSpell(369913) and 2.4 or 3
    local haste = 1 + UnitSpellHaste("player") / 100

    return base / haste
end

--- @return number
local function GetTotalDuration()
    local _, _, _, startTime, endTime = UnitChannelInfo("player")

    return (endTime - startTime) / 1000
end

local function UpdateTickMarks()
    local relativeBaseDuration = (GetBaseDuration() / GetTotalDuration())

    for i, tickMark in ipairs(ticks) do
        tickMark:Show()
        tickMark:SetPoint("CENTER", bar, "LEFT", (i / 3) * relativeBaseDuration * bar:GetWidth(), 0)
    end

    if relativeBaseDuration > 0.99 then
        ticks[3]:Hide()
    end
end

local function HideTickMarks()
    for _, tickMark in ipairs(ticks) do
        tickMark:Hide()
    end
end

aura_env.trigger = UpdateTickMarks
aura_env.untrigger = HideTickMarks
