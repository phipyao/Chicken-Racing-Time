local Game = {}

local Unit = require("classes.Unit")
local units = {}
local textTimers = {}
local gameSpeed = 1

local shake = require("classes.ScreenShake").new()
local hitSound = require("classes.SFX").new({path = "assets/sounds/clack.wav"})

function Game:load()
    units = {}
    textTimers = {}
    gameSpeed = 1
    table.insert(units, Unit.new(UnitData.monkey))
    table.insert(units, Unit.new(UnitData.chicken))
end


function Game:update(dt)
    for i = 1, gameSpeed do
        -- check for hitstun effect
        if not shake:update(dt) then
            -- update units
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
                            -- activate effects
                            shake:trigger()
                            hitSound:trigger()
                        end
                    end
                end
            end
            
            -- mark and remove dead units
            for i = 1, #units do
                local u = units[i]
                if u.hp <= 0 and not u.isDead then
                    u.isDead = true
                    u.deathTimer = u.deathDuration
                    u.flashTimer = u.flashDuration
                end
            end
            for i = #units, 1, -1 do
                local u = units[i]
                if u.isDead then
                    u.deathTimer = u.deathTimer - dt
                    if u.deathTimer <= 0 then
                        table.remove(units, i)
                    end
                end
            end
        end
        
    end
end

function Game:draw()
    shake:draw()
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
            elseif u.name == "Monkey" then
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