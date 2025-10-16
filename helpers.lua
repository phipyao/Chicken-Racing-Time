-- Global Functions:
L = love.graphics

floor = math.floor
ceil = math.ceil
max = math.max
min = math.min
abs = math.abs
sin = math.sin
cos = math.cos
atan2 = math.atan2
pi = math.pi
random = math.random

screen = nil
debug = false

Font = L.newFont("assets/m6x11.ttf", 16)
Font:setFilter("nearest", "nearest")
L.setFont(Font)

hitSound = require("classes.SFX").new({path = "assets/sounds/bonk.mp3"})

-- safe screen switcher
function switch(s)
	return setmetatable({}, {
		__index = function(_, key)
			return function(_, ...)
				if s and s[key] then
					return s[key](s, ...)
				end
			end
		end,
	})
end

function setScreen(s)
	screen = s
	s:load()
end

bg = {
	image = nil,
	width = 320,
	height = 180,
	centerX = 160,
	centerY = 90,
	zoom = 3,
}

function loadImage(path)
	local img = L.newImage(path)
	img:setFilter("nearest", "nearest")
	return img
end

function loadWindow()
	love.window.setTitle("CRT")
	love.window.setMode(
		bg.width * bg.zoom, 
		bg.height * bg.zoom, { 
			resizable = true, 
			-- display = 2, 
			-- fullscreen = true
		})
	bg.image = loadImage("/assets/background.png")
end

-- rotates rectangle from origin
function L.rotatedRectangle(mode, x, y, width, height, angle)
	love.graphics.push()
	love.graphics.translate(x + width/2, y + height/2)
	love.graphics.rotate(angle)
	love.graphics.rectangle(mode, -width/2, -height/2, width, height)
	love.graphics.pop()
end

function randomDir()
	local theta = random() * 2 * pi
	local x, y = cos(theta), sin(theta)
	return x, y
end

function randomDirHalf(normalX, normalY)
    -- random angle in [-90°, +90°] relative to the inward normal
    local theta = (random() - 0.5) * math.pi
    local baseAngle = atan2(normalY, normalX)
    local finalAngle = baseAngle + theta
    return cos(finalAngle), sin(finalAngle)
end

-- Camera Centering
function camera(drawFn)
	L.setBackgroundColor(192 / 255, 148 / 255, 115 / 255)
	L.push()
	L.scale(bg.zoom, bg.zoom)
	L.translate(bg.centerX - bg.width / 2, bg.centerY - bg.height / 2)
	drawFn()
	L.pop()
end

function cameraResize(w, h)
	bg.zoom = max((min(w / bg.width, h / bg.height)), 1)
	bg.centerX = floor((w / 2) / bg.zoom)
	bg.centerY = floor((h / 2) / bg.zoom)
end

function screenToWorld(x, y)
	local wx = (x / bg.zoom) - (bg.centerX - bg.width / 2)
	local wy = (y / bg.zoom) - (bg.centerY - bg.height / 2)
	return wx, wy
end

-- color function wrapper
function color(r, g, b, a)
	r = (r or 0) / 255
	g = (g or 0) / 255
	b = (b or 0) / 255
	a = a or 1

	return setmetatable({}, {
		__index = function(_, key)
			return function(_, ...)
				L.setColor(r, g, b, a)
				L[key](...)
				L.setColor(1, 1, 1, 1)
			end
		end,
	})
end

function drawBG()
	camera(function()
		L.draw(bg.image)
		-- bg.color = color(192, 148, 115)
		-- bg.color:rectangle("fill", 0, 0, bg.width, bg.height)
	end)
end

