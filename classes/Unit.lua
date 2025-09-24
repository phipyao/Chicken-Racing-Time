require("helpers")
UnitData = require("data.UnitData")

Unit = {}
Unit.__index = Unit

function Unit.new(params)
    local p = params or {}
    local image = loadImage("assets/chicken/chicken.png")
    local instance = {

        name = p.name or 0,
        hostile = p.hostile or false,
        maxhp = p.maxhp or 1,
        hp = p.maxhp or 1,
        atk = p.atk or 1,
        
        -- position variables
        x = p.x or random(bg.width),  
        y = p.y or random(bg.height),  
        vx = p.vx or random(0, 1) * 2 - 1, 
        vy = p.vy or random(0, 1) * 2 - 1,

         -- hitbox (simpler, always top-left aligned)
        hitboxW = p.hitboxW or 13,
        hitboxH = p.hitboxH or 15,

        -- sprite dimensions
        image = p.image or image,
        ox = p.ox or -44,
        oy = p.oy or -41,
    }
    setmetatable(instance, Unit)
    return instance
end

function Unit:update(dt)
    -- store previous position
    self.prevX, self.prevY = self.x, self.y

    -- move
    self.x = self.x + self.vx * 60 * dt
    self.y = self.y + self.vy * 60 * dt

    -- get hitbox in world space
    local hx, hy, hw, hh = self:getHitbox()

    -- bounce off left/right walls
    if hx < 0 then
        self.x = 0
        self.vx = -self.vx
    elseif hx + hw > bg.width then
        self.x = bg.width - hw
        self.vx = -self.vx
    end

    -- bounce off top/bottom walls
    if hy < 0 then
        self.y = 0
        self.vy = -self.vy
    elseif hy + hh > bg.height then
        self.y = bg.height - hh
        self.vy = -self.vy
    end
end


-- world-space hitbox rectangle
function Unit:getHitbox()
    return self.x, self.y, self.hitboxW, self.hitboxH
end

function Unit:attack(other)
    if self.hostile ~= other.hostile then
        self.hp = self.hp - other.atk
        other.hp = other.hp - self.atk
    end
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


-- Resolve collision by bouncing
function Unit:resolveCollision(other)
    if not self:collides(other) then return end

    -- get hitboxes
    local ax, ay, aw, ah = self:getHitbox()
    local bx, by, bw, bh = other:getHitbox()

    -- centers
    local acx, acy = ax + aw/2, ay + ah/2
    local bcx, bcy = bx + bw/2, by + bh/2

    -- overlap along x and y
    local overlapX = (aw/2 + bw/2) - math.abs(acx - bcx)
    local overlapY = (ah/2 + bh/2) - math.abs(acy - bcy)

    if overlapX < overlapY then
        -- push along X
        if acx < bcx then
            self.x = self.x - overlapX/2
            other.x = other.x + overlapX/2
        else
            self.x = self.x + overlapX/2
            other.x = other.x - overlapX/2
        end
        self.vx, other.vx = -self.vx, -other.vx
    else
        -- push along Y
        if acy < bcy then
            self.y = self.y - overlapY/2
            other.y = other.y + overlapY/2
        else
            self.y = self.y + overlapY/2
            other.y = other.y - overlapY/2
        end
        self.vy, other.vy = -self.vy, -other.vy
    end
end


function Unit:draw()
    -- apply offset when drawing image
    L.draw(self.image, self.x + self.ox, self.y + self.oy)

    -- debug: draw hitbox
    -- local hx, hy, hw, hh = self:getHitbox()
    -- L.rectangle("line", hx, hy, hw, hh)
end

return Unit
