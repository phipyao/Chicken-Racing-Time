-- Global Functions:

L = love.graphics

floor = math.floor
ceil = math.ceil
max = math.max
min = math.min
random = math.random

Font = L.newFont("assets/m6x11.ttf", 16)
Font:setFilter("nearest", "nearest")
L.setFont(Font)

bg = {
    image = nil,
    width = 320,
    height = 180,
    zoom = 3,
}

function loadImage(path)
    local img = L.newImage(path)
    img:setFilter("nearest", "nearest")
    return img
end

-- background and window loader
function loadBG()
    bg.centerX = bg.width / 2
    bg.centerY = bg.height / 2
    bg.screenWidth = bg.width * bg.zoom
    bg.screenHeight = bg.height * bg.zoom
    love.window.setTitle("CRT")
    love.window.setMode(bg.screenWidth, bg.screenHeight, { resizable = true })
    bg.image = loadImage("/assets/background.png")
end

-- wrapper
function camera(drawFn)
    -- L.setBackgroundColor(192 / 255, 148 / 255, 115 / 255)
    L.push()
    L.scale(bg.zoom, bg.zoom)
    L.translate(bg.centerX - bg.width / 2, bg.centerY - bg.height / 2)
    L.draw(bg.image)
    drawFn()
    L.pop()
end

function cameraResize(w, h)
    bg.zoom = max(floor(min(w / bg.width, h / bg.height)), 1)
    bg.centerX = floor((w / 2) / bg.zoom)
    bg.centerY = floor((h / 2) / bg.zoom)
end

-- convert screen coords to world coords
function screenToWorld(x, y)
    local wx = (x / bg.zoom) - (bg.centerX - bg.width / 2)
    local wy = (y / bg.zoom) - (bg.centerY - bg.height / 2)
    return wx, wy
end