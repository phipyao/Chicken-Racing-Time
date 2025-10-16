Button = require("classes.Button")

local Shop = {}

local shop1 = loadImage("assets/shop.png")
local shop2 = loadImage("assets/shop2.png")
local btn
local count = 0

function Shop:load()
    btn = Button.new({
        x = bg.width/2 - 30,
        y = 10,
        w = 60,
        h = 20,
        oy = -1,
        onClick = function()
            count = count + 1
            print("Shop button clicked " .. count .. " times")
            setScreen(Game)
        end
    })
end

function Shop:update(dt)
    btn:update(dt)
end

function Shop:draw()
    camera(function()
        L.draw(shop2, 0, -2*bg.height)
        L.draw(shop2, 0, -bg.height)
        L.draw(shop1)
        btn:draw()
    end)
end

function Shop:mousepressed(x, y, button)
    btn:mousepressed(x, y, button)
end

function Shop:mousereleased(x, y, button)
    btn:mousereleased(x, y, button)
end

function Shop:keypressed(key)

end

return Shop