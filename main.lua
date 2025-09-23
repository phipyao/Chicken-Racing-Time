-- main.lua
-- Fonts and window setup

require("helpers")

Font = L.newFont("assets/m6x11.ttf", 16)
Font:setFilter("nearest", "nearest")
L.setFont(Font)

bg = {
    image = nil,
    width = 320,
    height = 180,
    zoom = 3,
}

-- local Unit = require("classes.Unit")
local world
local chickens = {}

function love.load()
    bg.centerX = bg.width / 2
    bg.centerY = bg.height / 2
    bg.screenWidth = bg.width * bg.zoom
    bg.screenHeight = bg.height * bg.zoom

    love.window.setTitle("CRT")
    love.window.setMode(bg.screenWidth, bg.screenHeight, { resizable = true })
    bg.image = loadImage("/assets/background.png")
    
    world = P.newWorld(0, 0, true)

    local w, h = bg.width, bg.height

    -- top wall
    do
        local body = P.newBody(world, 0, 0, "static")
        local shape = P.newEdgeShape(0, 0, w, 1)
        local fixture = P.newFixture(body, shape)
        fixture:setRestitution(1)
    end
    -- bottom wall
    do
        local body = P.newBody(world, 0, h, "static")
        local shape = P.newEdgeShape(0, 0, w, 1)
        local fixture = P.newFixture(body, shape)
        fixture:setRestitution(1)
    end
    -- left wall
    do
        local body = P.newBody(world, 0, 0, "static")
        local shape = P.newEdgeShape(0, 0, 1, h)
        local fixture = P.newFixture(body, shape)
        fixture:setRestitution(1)
    end
    -- right wall
    do
        local body = P.newBody(world, w, 0, "static")
        local shape = P.newEdgeShape(0, 0, 1, h)
        local fixture = P.newFixture(body, shape)
        fixture:setRestitution(1)
    end

    addChicken(100, 100, 60, 30)
    addChicken(200, 150, -50, -40)
end

function addChicken(x, y, vx, vy)
    local image = loadImage("assets/chicken/chicken.png")

    local w, h = 13, 15   -- hitbox size

    local body = P.newBody(world, x, y, "dynamic")
    local shape = P.newRectangleShape(w, h) -- offset + size
    local fixture = P.newFixture(body, shape, 1)

    fixture:setRestitution(1)
    fixture:setFriction(0)
    body:setBullet(true)
    body:setLinearVelocity(vx, vy)
    body:setFixedRotation(true)

    table.insert(chickens, { image = image, body = body, shape = shape })
end

function love.update(dt)
    world:update(dt)
end

function love.draw()
    -- L.setBackgroundColor(192 / 255, 148 / 255, 115 / 255)
    L.push()
    L.scale(bg.zoom, bg.zoom)
    L.translate(bg.centerX - bg.width / 2, bg.centerY - bg.height / 2)

    -- L.printf("chicken", 0, 0, bg.width, "center")

    L.draw(bg.image)

    for _, c in ipairs(chickens) do
        local x, y = c.body:getPosition()
        L.draw(c.image, x, y, 0, 1, 1, c.image:getWidth()/2, c.image:getHeight()/2)
        L.polygon("line", c.body:getWorldPoints(c.shape:getPoints()))
    end


    L.pop()
end

function love.mousepressed(x, y, button)
end

function love.mousemoved(x, y)
end

function love.keypressed(key)
    if key == "r" then
        units = {}
    end
    love.load()
end

function love.resize(w, h)
    bg.zoom = max(floor(min(w / bg.width, h / bg.height)), 1)
    bg.centerX = floor((w / 2) / bg.zoom)
    bg.centerY = floor((h / 2) / bg.zoom)
end
