Button = require("classes.Button")

local Screen = {}

local btn

function Screen:load()
    btn = Button.new({
        x = bg.width/2 - 50,
        y = bg.height/2 - 50,
        w = 100,
        h = 100,

        onClick = function()
            print("button clicked")
        end
    })
end

function Screen:update(dt)
    btn:update(dt)
end

function Screen:draw()
    camera(function()
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