local Game = {}

local Unit = require("classes.Unit")
local units = {}
local textTimers = {}
local gameSpeed = 1

local hitStunTimer = 0
local hitStunDelay = 0.1

local shakeMagnitude = 4
local shakeX, shakeY = 0, 0 

function Game:load()
    units = {}
    textTimers = {}
    gameSpeed = 1
    table.insert(units, Unit.new(UnitData.monkey))
    table.insert(units, Unit.new(UnitData.chicken))
end


function Game:update(dt)
    -- update movement with background bounds
    for i = 1, gameSpeed do
        -- check for hitstun effect
        if hitStunTimer > 0 then
            hitStunTimer = hitStunTimer - dt

            shakeX = random(-shakeMagnitude, shakeMagnitude)
            shakeY = random(-shakeMagnitude, shakeMagnitude)
        else

            shakeX, shakeY = 0, 0

            for _, u in ipairs(units) do
                u:update(dt)
            end

            -- check collisions between all pairs
            for i = 1, #units do
                for j = i+1, #units do
                    local a, b = units[i], units[j]
                    if a:collides(b) then
                        a:resolveCollision(b)
                        if a:attack(b) then
                            hitStunTimer = hitStunDelay
                        end
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
    end
end

function Game:draw()
    L.translate(shakeX, shakeY)
    camera(function()
        for _, u in ipairs(units) do
            u:draw()
        end
    end)
    cameraText(function()
        L.print("Game Speed: " .. gameSpeed, 5, 5)
        -- display unit hp values
        for _, u in ipairs(units) do
            if u.name == "Chicken" then
                L.print(u.hp, (u.x + 5) * bg.zoom, (u.y - 9) * bg.zoom)
            else
                L.print("Monkey", (u.x) * bg.zoom, (u.y - 9) * bg.zoom)
            end
        end
    end)
end

function Game:keypressed(key)
    if key == "r" then
        units = {}
        table.insert(units, Unit.new(UnitData.monkey))
        table.insert(units, Unit.new(UnitData.chicken))
    elseif key:match("%d") then
        gameSpeed = tonumber(key)
    else 
        table.insert(units, Unit.new(UnitData.chicken))
    end
end

return Game