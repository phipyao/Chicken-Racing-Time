local ScreenShake = {}
ScreenShake.__index = ScreenShake

function ScreenShake.new(magnitude, duration)
    local self = setmetatable({}, ScreenShake)
    self.magnitude = magnitude or 4      -- max pixel offset
    self.duration = duration or 0.15     -- default shake time
    self.timer = 0                       -- countdown
    self.x, self.y = 0, 0                -- current offsets
    return self
end

-- trigger a shake (optionally override duration/magnitude)
function ScreenShake:trigger(duration, magnitude)
    self.timer = duration or self.duration
    if magnitude then self.magnitude = magnitude end
end

function ScreenShake:update(dt)
    if self.timer > 0 then
        self.timer = self.timer - dt
        self.x = love.math.random(-self.magnitude, self.magnitude)
        self.y = love.math.random(-self.magnitude, self.magnitude)
        return true
    end
    self.x, self.y = 0, 0
    return false
end

function ScreenShake:draw()
    L.translate(self.x, self.y)
end

return ScreenShake
