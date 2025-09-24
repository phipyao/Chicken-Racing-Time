local UnitData = {}

UnitData.chicken = {
    name = "Chicken",
    maxhp = 4,
    atk = 2,
    hostile = false,
    image = loadImage("assets/chicken/chicken.png"),
}

UnitData.monkey = {
    name = "Monkey",
    maxhp = 4,
    atk = 2,
    hostile = true,
    image = loadImage("assets/monkey/monkey.png"),
}

return UnitData