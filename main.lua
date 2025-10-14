-- main.lua
require("helpers")

Home = require("screens.Home")
Game = require("screens.Game")
Shop = require("screens.Shop")

screens = {
    Home,
    Game,
    Shop,
}

screen = Shop

function love.load()
    loadBG()
    -- preload all screens
    for _, s in ipairs(screens) do
        switch(s):load()
    end
end

function love.update(dt)
    cameraResize(L.getDimensions())
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

function love.mousereleased(x, y, button)
    x, y = screenToWorld(x, y)
    switch(screen):mousereleased(x, y, button)
end

function love.mousemoved(x, y)
    x, y = screenToWorld(x, y)
    switch(screen):mousemoved(x, y)
end

function love.keypressed(key)
    switch(screen):keypressed(key)

    -- screen switcher
    -- if key == "g" then
    --     screen = Game
    --     switch(screen):load()
    -- elseif key == "c" then
    --     screen = Chicks
    --     switch(screen):load()
    -- end
end

function love.resize(w, h)
    cameraResize(w, h)
end
