local class = select(2, UnitClass("player"))

local specs = {
    DEATHKNIGHT = {
        250, -- Blood
        251, -- Frost
        252, -- Unholy
    },

    DRUID = {
        102, -- Balance
        103, -- Feral
        104, -- Guardian
        105, -- Restoration
    },

    HUNTER = {
        253, -- Beast Mastery
        254, -- Marksmanship
        255, -- Survival
    },

    MAGE = {
        62, -- Arcane
        63, -- Fire
        64, -- Frost
    },

    PALADIN = {
        65, -- Holy
        66, -- Protection
        70, -- Retribution
    },

    PRIEST = {
        256, -- Discipline
        257, -- Holy
        258, -- Shadow
    },

    ROGUE = {
        259, -- Assassination
        260, -- Outlaw (Combat в WotLK)
        261, -- Subtlety
    },

    SHAMAN = {
        262, -- Elemental
        263, -- Enhancement
        264, -- Restoration
    },

    WARLOCK = {
        265, -- Affliction
        266, -- Demonology
        267, -- Destruction
    },

    WARRIOR = {
        71, -- Arms
        72, -- Fury
        73, -- Protection
    },
}

Merfin.GetPlayerSpecs = function()
    local activeGroup = GetActiveTalentGroup()
    local activeSpec, inactiveSpec

    for group = 1, 2 do
        local maxPoints = -1
        local maxIndex
        local maxSpecID

        for tab = 1, 3 do
            local specID = specs[class][tab]
            local _, _, pointsSpent = GetTalentTabInfo(tab, false, false, group)
            if pointsSpent and pointsSpent > maxPoints then
                maxPoints = pointsSpent
                maxIndex = tab
                maxSpecID = specID
            end
        end

        if group == activeGroup then
            activeSpec = maxSpecID
        else
            inactiveSpec = maxSpecID
        end
    end

    return activeSpec, inactiveSpec
end