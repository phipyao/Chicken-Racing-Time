-- main.lua
require("helpers")

local Unit = require("classes.Unit")
local units = {}

function love.load()
    loadBG()
    table.insert(units, Unit.new(UnitData.chicken))
    table.insert(units, Unit.new(UnitData.monkey))
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
                a:attack(b)
            end
        end
    end

    -- remove dead units
    for i = #units, 1, -1 do
    if units[i].hp <= 0 then
        table.remove(units, i)
    end
end

end

function love.draw()
    camera(function()
        for _, u in ipairs(units) do
            u:draw()
        end
    end)
end

function love.mousepressed(x, y, button)
    x, y = screenToWorld(x, y)
end

function love.mousemoved(x, y)
    x, y = screenToWorld(x, y)
end

function love.keypressed(key)
    if key == "r" then
        units = {}
    end
    table.insert(units, Unit.new(UnitData.chicken))
    table.insert(units, Unit.new(UnitData.monkey))
end

function love.resize(w, h)
    cameraResize(w, h)
end
