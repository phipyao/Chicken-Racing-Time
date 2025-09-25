local UnitData = {}

UnitData.chicken = {
    name = "Chicken",
    maxhp = 2,
    atk = 0,
    hostile = false,
    image = loadImage("assets/chicken/chicken.png"),
}

UnitData.monkey = {
    name = "Monkey",
    maxhp = 1.80e308,
    atk = 1,
    hostile = true,
    image = loadImage("assets/monkey/monkey.png"),
}

return UnitData