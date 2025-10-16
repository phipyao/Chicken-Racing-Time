Button = require("classes.Button")

local Home = {}

local btn = {
}

function Home:load()
    table.insert(btn, Button.new({
        text = "play",
        x = bg.width/2 - 30,
        y = 140,
        w = 60,
        h = 20,
        oy = -3,
        onClick = function()
            setScreen(Game)
        end
    }))
end

function Home:update(dt)
    for i, b in ipairs(btn) do
        b:update(dt)
    end
end

function Home:draw()
    camera(function()
        for i, b in ipairs(btn) do
            b:draw()
        end
    end)
end

function Home:mousepressed(x, y, button)
    for i, b in ipairs(btn) do
        b:mousepressed(x, y, button)
    end
end

function Home:mousereleased(x, y, button)
    for i, b in ipairs(btn) do
        b:mousereleased(x, y, button)
    end
end

function Home:keypressed(key)

end

return Home