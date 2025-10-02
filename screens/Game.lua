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
    -- table.insert(units, Unit.new(UnitData.monkey))
    u1 = Unit.new(UnitData.chicken)
    u2 = Unit.new(UnitData.chicken)
    u3 = Unit.new(UnitData.monkey)
    u4 = Unit.new(UnitData.monkey)
    table.insert(units, u1)
    table.insert(units, u2)
    table.insert(units, u3)
    table.insert(units, u4)
end


function Game:update(dt)
    for i = 1, gameSpeed do
        -- check for hitstun effect
        if not shake:update(dt) then
            -- collisions
            for i = 1, #units do
                -- border collision
                local a = units[i]
                if a:collidesBorder() then
                    a:resolveCollisionBorder()
                end
                -- unit collision
                for j = i+1, #units do
                    local b = units[j]
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

            -- update units
            for _, u in ipairs(units) do
                u:update(dt)
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
            L.print(u.hp, (u.x + 5) * bg.zoom, (u.y - 9) * bg.zoom)
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