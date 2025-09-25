-- main.lua
require("helpers")

Game = require("screens.Game")

screens = {
    Game
}

screen = Game

function love.load()
    loadBG()
    -- preload all screens
    for _, s in ipairs(screens) do
        switch(s):load()
    end
end

function love.update(dt)
    switch(screen):update(dt)
end

function love.draw()
    drawBG()
    switch(screen):draw()
end

function love.mousepressed(x, y, button)
    x, y = screenToWorld(x, y)
    switch(screen):mousepressed(x, y, button)
end

function love.mousemoved(x, y)
    x, y = screenToWorld(x, y)
    switch(screen):mousemoved(x, y)
end

function love.keypressed(key)
    switch(screen):keypressed(key)
end

function love.resize(w, h)
    cameraResize(w, h)
end
