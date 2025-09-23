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

local Unit = require("classes.Unit")
local units = {}

function love.load()
    bg.centerX = bg.width / 2
    bg.centerY = bg.height / 2
    bg.screenWidth = bg.width * bg.zoom
    bg.screenHeight = bg.height * bg.zoom

    love.window.setTitle("CRT")
    love.window.setMode(bg.screenWidth, bg.screenHeight, { resizable = true })
    bg.image = loadImage("/assets/background.png")

    for i = 1, 1 do
        table.insert(
            units, 
            Unit.new({ 
                x = random(bg.width),  
                y = random(bg.height),  
                vx = random(0, 1) * 2 - 1, 
                vy = random(0, 1) * 2 - 1 
            })
        )
    end

end

function love.update(dt)
    -- update movement with background bounds
    for _, u in ipairs(units) do
        u:update(dt)
    end

    -- check collisions between all pairs
    for i = 1, #units do
        for j = i+1, #units do
            local a, b = units[i], units[j]
            if a:collides(b) then
                a:resolveCollision(b)
            end
        end
    end

end

function love.draw()
    -- L.setBackgroundColor(192 / 255, 148 / 255, 115 / 255)
    L.push()
    L.scale(bg.zoom, bg.zoom)
    L.translate(bg.centerX - bg.width / 2, bg.centerY - bg.height / 2)

    -- Game Window:
    do
        L.draw(bg.image)
        for _, u in ipairs(units) do
            u:draw()
        end
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
