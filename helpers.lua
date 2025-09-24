-- Global Functions:

L = love.graphics
floor = math.floor
ceil = math.ceil
max = math.max
min = math.min
random = math.random

function loadImage(path)
    local img = L.newImage(path)
    img:setFilter("nearest", "nearest")
    return img
end
