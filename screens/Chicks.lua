local Chicks = {}

local Unit = require("classes.Unit")
local units = {}
local textTimers = {}
local gameSpeed = 1

local hitSound = require("classes.SFX").new({path = "assets/sounds/clack.wav"})

function Chicks:load()
    units = {}
    textTimers = {}
    gameSpeed = 1
    table.insert(units, Unit.new(UnitData.chicken))
end


function Chicks:update(dt)
    -- update movement with background bounds
    for i = 1, gameSpeed do
        for _, u in ipairs(units) do
            u:update(dt)
        end

        -- check collisions between all pairs
        for i = 1, #units do
            for j = i+1, #units do
                local a, b = units[i], units[j]
                if a:collides(b) then
                    a:resolveCollision(b)
                    hitSound:trigger()
                end
            end
        end
    end
end

function Chicks:draw()
    camera(function()
        for _, u in ipairs(units) do
            u:draw()
        end
    end)
    cameraText(function()
    end)
end

function Chicks:keypressed(key)
    if key == "r" then
        units = {}
        table.insert(units, Unit.new(UnitData.chicken))
    elseif key:match("%d") then
        gameSpeed = tonumber(key)
    else 
        table.insert(units, Unit.new(UnitData.chicken))
    end
end

return Chicks