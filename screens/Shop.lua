Button = require("classes.Button")

local Screen = {}

local shop1 = loadImage("assets/shop.png")
local shop2 = loadImage("assets/shop2.png")
local btn
local count = 0

function Screen:load()
    btn = Button.new({
        x = bg.width/2 - 30,
        y = 10,
        w = 60,
        h = 20,
        oy = -1,
        onClick = function()
            count = count + 1
            print("button clicked " .. count .. " times")
        end
    })
end

function Screen:update(dt)
    btn:update(dt)
end

function Screen:draw()
    camera(function()
        L.draw(shop2, 0, -2*bg.height)
        L.draw(shop2, 0, -bg.height)
        L.draw(shop1)
        btn:draw()
    end)
end

function Screen:mousepressed(x, y, button)
    btn:mousepressed(x, y, button)
end

function Screen:mousereleased(x, y, button)
    btn:mousereleased(x, y, button)
end


function Screen:mousemoved(x, y)
    btn:mousemoved(x, y)
end

function Screen:keypressed(key)

end

return Screen