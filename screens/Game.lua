local Game = {}

local Unit = require("classes.Unit")
local units = {}
local textTimers = {}
local gameTimer = 0
local gameSpeed = 1

local shake = require("classes.ScreenShake").new()

local gamemode = "CTF"
local ctfFlag = nil

function Game:load()
    units = {}
    textTimers = {}
    gameTimer = 0
    gameSpeed = 1
    if gamemode == "CTF" then
        ctfFlag = Unit.new(UnitData.ctfFlag)
        table.insert(units, ctfFlag)
    end
    table.insert(units, Unit.new(UnitData.monkey))
    table.insert(units, Unit.new(UnitData.chicken))
end

function Game:checkWinconditions()
    local winnerParty = nil
    local gameOver = false

    -- CTF win
    if gamemode == "CTF" then
        local found = false
        for _, u in ipairs(units) do
            if u.name == "Flag" then
                found = true
                break
            end
        end

        if not found then
            winnerParty = ctfFlag.lastHit and ctfFlag.lastHit.party or nil
            gameOver = true
        end
    end

    -- Elimination win
    if not gameOver then
        local aliveParties = {}
        for _, u in ipairs(units) do
            if u.party ~= 0 then
                aliveParties[u.party] = true
            end
        end

        local count = 0
        for party, _ in pairs(aliveParties) do
            count = count + 1
            winnerParty = party
        end

        if count == 0 then
            print("Draw!")
            gameSpeed = 0
            return
        elseif count == 1 then
            gameOver = true
        end
    end

    -- Finalize game over
    if gameOver then
        if winnerParty then
            print("Party " .. tostring(winnerParty) .. " wins!")
        else
            print("Draw!")
        end
        gameSpeed = 0
    end
end

function Game:update(dt)
    for i = 1, gameSpeed do
        gameTimer = gameTimer + dt
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
                for j = i + 1, #units do
                    local b = units[j]
                    if a:collides(b) then
                        a:resolveCollision(b)
                        if a:attack(b) and not b.static then
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

        self:checkWinconditions()
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
        L.print("Time: " .. string.format("%.2f", gameTimer), 5, 5)
        L.print("Game Speed: " .. gameSpeed, 5, 21)
        -- display unit stats
        for _, u in ipairs(units) do
            if u.name ~= "Wall" then
                L.print(u.hp, (u.x + u.hitboxW / 2) * bg.zoom - 4, (u.y - 9) * bg.zoom)
                -- L.print(u.hp .. " " ..  u.wallBounceCount .. " " .. u.unitBounceCount, (u.x + 5) * bg.zoom, (u.y - 9) * bg.zoom)
            end

            -- debug: print buffs
            -- local buffText = ""
            -- for buff, active in pairs(u.buffs) do
            --     if active then
            --         buffText = buffText .. buff .. " "
            --     end
            -- end
            -- L.print(u.hp .. " " .. u.atk .. " [ " .. buffText .. "]", u.x * bg.zoom, (u.y - 9) * bg.zoom)
        end
    end)
end

local blocks = {
    { name = 'O', pieces = 4, xOffsets = { 0, 10, 0, 10 },  yOffsets = { 0, 0, 10, 10 } },
    { name = 'I', pieces = 4, xOffsets = { 0, 0, 0, 0 },    yOffsets = { 0, 10, 20, 30 } },
    { name = "L", pieces = 4, xOffsets = { 0, 0, 0, 10 },   yOffsets = { 0, 10, 20, 20 } },
    { name = "J", pieces = 4, xOffsets = { 0, 0, 0, -10 },  yOffsets = { 0, 10, 20, 20 } },
    { name = "S", pieces = 4, xOffsets = { 0, 10, 10, 20 }, yOffsets = { 0, 0, -10, -10 } },
    { name = "Z", pieces = 4, xOffsets = { 0, 0, 0, -10 },  yOffsets = { 0, 10, 20, 20 } },
    { name = "T", pieces = 4, xOffsets = { 0, 10, 20, 10 }, yOffsets = { 0, 0, 0, 10 } }
}

function Game:mousepressed(x, y, button)
    if button == 1 then
        local block = random(#blocks)
        for i = 1, blocks[block].pieces do
            table.insert(units,
                Unit.new(setmetatable({ x = x + blocks[block].xOffsets[i], y = y + blocks[block].yOffsets[i] },
                    { __index = UnitData.wall })))
        end
    end
end

function Game:keypressed(key)
    if key == "r" then
        units = {}
        gamemode = "CTF"
        ctfFlag = Unit.new(UnitData.ctfFlag)
        table.insert(units, ctfFlag)
        table.insert(units, Unit.new(UnitData.monkey))
        table.insert(units, Unit.new(UnitData.chicken))
        gameTimer = 0
        gameSpeed = 1
    elseif key == "t" then
        units = {}
        gamemode = ""
        table.insert(units, Unit.new(UnitData.monkey))
        table.insert(units, Unit.new(UnitData.chicken))
        gameTimer = 0
        gameSpeed = 1
    elseif key:match("%d") then
        gameSpeed = tonumber(key)
    else
        table.insert(units, Unit.new(UnitData.chicken))
    end
end

return Game
