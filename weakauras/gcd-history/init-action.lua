aura_env.ignorelist = {
    [75] = true, --Auto Shot
    [5374] = true, -- Mutilate
    [7268] = true, -- Arcane Missiles
    [27576] = true, -- Mutilate
    [32175] = true, -- Stormstrike
    [32176] = true, -- Stormstrike (Off-Hand)
    [50622] = true, -- Bladestorm
    [52174] = true, -- Heroic Leap
    [57794] = true, -- Heroic Leap
    [61391] = true, -- Typhoon
    [84721] = true, -- Frozen Orb
    [85384] = true, -- Raging Blow
    [88263] = true, -- Hammer of the Righteous
    [96103] = true, -- Raging Blow
    [102794] = true, -- Ursol's Vortex
    [107270] = true, -- Spinning Crane Kick
    [110745] = true, -- Divine Star
    [114089] = true, -- Windlash
    [114093] = true, -- Windlash Off-Hand
    [115357] = true, -- Windstrike
    [115360] = true, -- Windstrike Off-Hand
    [115464] = true, -- Healing Sphere
    [120692] = true, -- Halo
    [120696] = true, -- Halo
    [121473] = true, -- Shadow Blade
    [121474] = true, -- Shadow Blade Off-hand
    [122128] = true, -- Divine Star
    [127797] = true, -- Ursol's Vortex
    [132951] = true, -- Flare
    [135299] = true, -- Tar Trap
    [198928] = true, -- Cinderstorm
    [199672] = true, -- Rupture
    [204255] = true, -- Soul Fragments
    [213241] = true, -- Felblade
    [213243] = true, -- Felblade
    [225919] = true, -- Fracture
    [225921] = true, -- Fracture
    [228354] = true, -- Flurry
    [228597] = true, -- Frostbolt
    [217200] = true, -- Frenzy; BM hunter buff
    [276245] = true, -- Env; envenom buff
    [361195] = true, -- Verdant Embrace friendly heal
    [361509] = true, -- Living Flame friendly heal
    [370966] = true, -- The Hunt Impact (DH Class Tree Talent)
    [383313] = true, -- Abomination Limb periodical
    [385954] = true -- Shield Charge
}

for _, spell in pairs(aura_env.config.ignorelist) do
    aura_env.ignorelist[spell.id] = true
end

aura_env.logHistory = {}

aura_env.spellcasts = 0

aura_env.isRogue = false
aura_env.isEvoker = false

aura_env.lastComboPoints = 0
aura_env.currentComboPoints = 0
aura_env.attachComboPointsToNext = false

aura_env.getComboPoints = function()
    return UnitPower("player", Enum.PowerType.ComboPoints)
end

do
    local id = select(3, C_PlayerInfo.GetClass({unit = "player"}))

    aura_env.isEvoker = id == 13

    if id == 4 then
        aura_env.isRogue = true
        aura_env.currentComboPoints = aura_env.getComboPoints()
        aura_env.lastComboPoints = aura_env.currentComboPoints
    end
end

--- @type table<string, boolean>
local unknownGuidIsMyPet = {}

--- @param guid string
--- @return boolean
local function isMyPet(guid)
    if unknownGuidIsMyPet[guid] ~= nil then
        return unknownGuidIsMyPet[guid]
    end

    local tooltipData = C_TooltipInfo.GetHyperlink("unit:" .. guid)

    if not tooltipData then
        unknownGuidIsMyPet[guid] = false
        return false
    end

    for _, line in ipairs(tooltipData.lines) do
        TooltipUtil.SurfaceArgs(line)

        -- special case for Sub Rogue Secret Technique. These units are not pets,
        -- have no _formal_ tooltip but can still be queried
        if line.type == Enum.TooltipDataLineType.UnitName and line.unitToken == "player" then
            unknownGuidIsMyPet[guid] = true

            return true
        end

        if line.type == Enum.TooltipDataLineType.UnitOwner then
            local result = line.guid == WeakAuras.myGUID
            unknownGuidIsMyPet[guid] = result

            return result
        end
    end

    unknownGuidIsMyPet[guid] = false

    return false
end

--- @param guid string
--- @return boolean
aura_env.isBasicallyMe = function(guid)
    if guid == WeakAuras.myGUID then
        return true
    end

    if aura_env.config.petActions then
        return isMyPet(guid)
    end

    return false
end

--- @param guid string
--- @return boolean
aura_env.isPet = function(guid)
    return aura_env.config.petActions and unknownGuidIsMyPet[guid] == true or false
end
