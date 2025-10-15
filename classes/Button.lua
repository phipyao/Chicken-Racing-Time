Button = {}
Button.__index = Button

function Button.new(params)
    local p = params or {}

    local instance = {
        text = p.text or "",
        x = p.x or 0,
        y = p.y or 0,
        w = p.w or 100,
        h = p.h or 40,
        oy = p.oy or -3,
        time = random(0, pi),
        angle = 0,
        scalar = 200,

        isPressed = false,
        isHovered = false,
        offsetY = 0,

        onClick = p.onClick or function() end,
    }

    setmetatable(instance, Button)
    return instance
end

function Button:update(dt)
    local targetOffset = 0

    if self.isPressed then
        targetOffset = 0
        self.angle = 0
    elseif self.isHovered then
        targetOffset = self.oy
        self.time = self.time + dt
        self.angle = sin(self.time) / self.scalar
    end

    -- smooth lerp
    local speed = 30 * dt
    self.offsetY = self.offsetY + (targetOffset - self.offsetY) * speed

   
end

function Button:draw()
    C.shadow:rectangle("fill", self.x, self.y+1, self.w, self.h)
    C.brown2:rotatedRectangle("fill", self.x, self.y + self.offsetY, self.w, self.h, self.angle)
    L.setLineWidth(2)
    C.brown3:rotatedRectangle("line", self.x, self.y + self.offsetY, self.w, self.h, self.angle)
    L.setLineWidth(1)

end

function Button:mousemoved(x, y)
    self.isHovered = x >= self.x and x <= self.x + self.w and
                     y >= self.y and y <= self.y + self.h
end

function Button:mousepressed(x, y, button)
    if button == 1 and self.isHovered then
        self.isPressed = true
    end
end

function Button:mousereleased(x, y, button)
    if button == 1 and self.isPressed then
        self.isPressed = false
        if self.isHovered then
            self.onClick()
        end
    end
end

return Button
