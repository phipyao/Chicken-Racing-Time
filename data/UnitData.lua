local UnitData = {}

UnitData.ctfFlag = {
    name = "Flag",
    maxhp = 5,
    atk = 0,
    party = 0,
}

UnitData.wall = {
    name = "Wall",
    maxhp = math.huge,
    immovable = true,
    hitboxW = 10,
    hitboxH = 10,
    atk = 0,
    party = 0,
    vx = 0,
    vy = 0,
}

UnitData.chicken = {
    name = "Chicken",
    maxhp = 5,
    atk = 1,
    party = 1,
    hitboxW = 13,
    hitboxH = 15,
    ox = -44,
    oy = -41,
    image = loadImage("assets/chicken/chicken.png"),
    blank = loadImage("assets/chicken/outline.png"),

}

UnitData.monkey = {
    name = "Monkey",
    maxhp = 5,
    atk = 1,
    party = 2,
    hitboxW = 13,
    hitboxH = 13,
    ox = -44,
    oy = -44,
    image = loadImage("assets/monkey/monkey.png"),
    blank = loadImage("assets/monkey/outline.png"),

}

return UnitData

