local Screen = {}

function Screen:load()

end

function Screen:update(dt)

end

function Screen:draw()
    camera(function()
        -- add main scene here
    end)
    cameraText(function()
        -- add text here
    end)
end

function Screen:mousepressed(x, y, button)

end

function Screen:mousemoved(x, y)

end

function Screen:keypressed(key)

end

return Screen