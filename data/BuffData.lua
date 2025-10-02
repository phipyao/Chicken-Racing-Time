local BuffData = {}

-- === Precombat Buffs ===
BuffData.shield = {
    timing = "precombat",
    description = "Grants +1 HP before combat.",
    apply = function(unit, other)
        if other.atk > 0 then
            unit.hp = unit.hp + 1
        end
    end,
}

-- === Postcombat Buffs ===
BuffData.lifesteal = {
    timing = "postcombat",
    description = "Heals HP after combat equal to 1/2 ATK.",
    apply = function(unit, other)
        unit.hp = math.min(unit.maxhp, unit.hp + ceil(unit.atk/2))
    end,
}

BuffData.squared = {
    timing = "postcombat",
    description = "Continuously doubles this unit's attack.",
    apply = function(unit, other)
        unit.atk = unit.atk * 2
    end,
}

-- === Interval Timing Buffs ===
BuffData.regen = {
    timing = "interval",
    interval = 1.0,
    description = "Heals 1 HP after combat.",
    apply = function(unit, other)
        unit.hp = math.min(unit.maxhp, unit.hp + 1)
    end,
}

return BuffData