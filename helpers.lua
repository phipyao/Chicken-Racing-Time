-- Global Functions:

L = love.graphics
P = love.physics
floor = math.floor
ceil = math.ceil
max = math.max
min = math.min
random = math.random

function loadImage(path)
    local img = love.graphics.newImage(path)
    img:setFilter("nearest", "nearest")
    return img
end
