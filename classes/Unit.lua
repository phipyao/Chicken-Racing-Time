require("helpers")

Unit = {}
Unit.__index = Unit

function Unit.new(params)
    local p = params or {}
    local image = loadImage("assets/chicken/chicken.png")
    local instance = {
        image = image,
        ox = 44,
        oy = 41,
        x = p.x or 0,
        y = p.y or 0,
        vx = p.vx or 0,
        vy = p.vy or 0,

        -- sprite dimensions
        w = image:getWidth(),
        h = image:getHeight(),

        -- custom hitbox (relative to sprite)
        hitboxX = p.hitboxX or 44,
        hitboxY = p.hitboxY or 41,
        hitboxW = p.hitboxW or 13,
        hitboxH = p.hitboxH or 15,
    }
    setmetatable(instance, Unit)
    return instance
end

function Unit:update(dt, boundsW, boundsH)
    -- move
    self.x = self.x + self.vx * 60 * dt
    self.y = self.y + self.vy * 60 * dt

    -- get hitbox in world space
    local hx, hy, hw, hh = self:getHitbox()

    -- bounce off left/right walls
    if hx < 0 then
        self.x = -self.hitboxX -- snap so hitbox sits at edge
        self.vx = -self.vx
    elseif hx + hw > boundsW then
        self.x = boundsW - hw - self.hitboxX
        self.vx = -self.vx
    end

    -- bounce off top/bottom walls
    if hy < 0 then
        self.y = -self.hitboxY
        self.vy = -self.vy
    elseif hy + hh > boundsH then
        self.y = boundsH - hh - self.hitboxY
        self.vy = -self.vy
    end

end

-- world-space hitbox rectangle
function Unit:getHitbox()
    return self.x + self.hitboxX,
           self.y + self.hitboxY,
           self.hitboxW,
           self.hitboxH
end

-- collision test using hitboxes
function Unit:collides(other)
    local ax, ay, aw, ah = self:getHitbox()
    local bx, by, bw, bh = other:getHitbox()

    return ax < bx + bw and
           ax + aw > bx and
           ay < by + bh and
           ay + ah > by
end

-- Simple bounce response (swap velocities)
function Unit:bounce(other)
    -- reverse horizontal if overlap is more horizontal
    local dx = (self.x + self.w/2) - (other.x + other.w/2)
    local dy = (self.y + self.h/2) - (other.y + other.h/2)

    if math.abs(dx) > math.abs(dy) then
        self.vx = -self.vx
        other.vx = -other.vx
    else
        self.vy = -self.vy
        other.vy = -other.vy
    end
end

-- Resolve collision by bouncing
function Unit:resolveCollision(other)
    if not self:collides(other) then return end

    -- centers of hitboxes
    local ax, ay, aw, ah = self:getHitbox()
    local bx, by, bw, bh = other:getHitbox()
    local acx, acy = ax + aw/2, ay + ah/2
    local bcx, bcy = bx + bw/2, by + bh/2

    local dx = acx - bcx
    local dy = acy - bcy

    if math.abs(dx) > math.abs(dy) then
        self.vx, other.vx = -self.vx, -other.vx
        if dx > 0 then
            self.x = self.x + 1
            other.x = other.x - 1
        else
            self.x = self.x - 1
            other.x = other.x + 1
        end
    else
        self.vy, other.vy = -self.vy, -other.vy
        if dy > 0 then
            self.y = self.y + 1
            other.y = other.y - 1
        else
            self.y = self.y - 1
            other.y = other.y + 1
        end
    end
end

function Unit:draw()
    love.graphics.draw(self.image, self.x, self.y)

    -- debug: draw hitbox
    -- local hx, hy, hw, hh = self:getHitbox()
    -- love.graphics.rectangle("line", hx, hy, hw, hh)
end

return Unit