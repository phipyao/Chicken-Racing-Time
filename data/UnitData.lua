local UnitData = {}

UnitData.chicken = {
    name = "Chicken",
    maxhp = 2,
    atk = 1,
    party = 0,
    image = loadImage("assets/chicken/chicken.png"),
    blank = loadImage("assets/chicken/outline.png"),
}

UnitData.monkey = {
    name = "Monkey",
    maxhp = 5,
    atk = 1,
    party = 1,
    image = loadImage("assets/monkey/monkey.png"),
    blank = loadImage("assets/monkey/outline.png"),
}

return UnitData