local BuffData = {}

BuffData.squared = {
    timing = "postcombat",
    description = "Doubles this unit's attack every time it attacks.",
    apply = function(unit, other)
        unit.atk = unit.atk * 2
    end,
}

BuffData.shield = {
    timing = "precombat",
    description = "Grants +1 HP before combat.",
    apply = function(unit, other)
        if unit.hp > 0 then
            unit.hp = unit.hp + 1
        end
    end,
}

BuffData.regen = {
    timing = "interval",
    interval = 1.0,
    description = "Heals 1 HP after combat, up to max HP.",
    apply = function(unit, other)
        unit.hp = math.min(unit.maxhp, unit.hp + 1)
    end,
}

BuffData.lifesteal = {
    timing = "postcombat",
    description = "Heals HP after combat equal to 1/2 ATK, up to max HP.",
    apply = function(unit, other)
        unit.hp = math.min(unit.maxhp, unit.hp + unit.atk)
    end,
}

return BuffData