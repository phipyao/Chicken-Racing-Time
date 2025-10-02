UnitData = require("data.UnitData")
BuffData = require("data.BuffData")

Unit = {}
Unit.__index = Unit

function Unit.new(params)
	local p = params or {}
	local image = nil
	local blank = nil

	local vx, vy = randomDir()

	local instance = {
		name = p.name or 0,
		party = p.party or 0,
		maxhp = p.maxhp or 1,
		hp = p.hp or p.maxhp or 1,
		atk = p.atk or 1,

		buffs = p.buffs or {},
		buffTimers = {},

		-- counters
		randomizeBounce = true,
		bounceCount = 0,
		unitBounceCount = 0,
		wallBounceCount = 0,

		lastHit = nil,
		killCount = 0,

		-- position variables
		x = p.x or random(bg.width),
		y = p.y or random(bg.height),
		vx = p.vx or vx,
		vy = p.vy or vy,

		-- hitbox (simpler, always top-left aligned)
		hitboxW = p.hitboxW or 5,
		hitboxH = p.hitboxH or 5,

		-- sprite dimensions
		image = p.image or image,
        blank = p.blank or blank,
		ox = p.ox or 0,
		oy = p.oy or 0,

        -- for taking damage
        flashTimer = 0,
        flashDuration = 0.1,
        isDead = false,
        deathTimer = 0,
        deathDuration = 0.1,
	}
	setmetatable(instance, Unit)
	return instance
end

function Unit:addBuff(buff)
	self.buffs[buff] = true
end

function Unit:removeBuff(buff)
	self.buffs[buff] = nil
end

function Unit:combatBuffs(other, timing)
    for buff, active in pairs(self.buffs) do
        if active and BuffData[buff] and BuffData[buff].timing == timing then
            BuffData[buff].apply(self, other)
        end
    end
end

function Unit:tickBuffs(dt)
    for buff, active in pairs(self.buffs) do
        local def = BuffData[buff]
        if active and def and def.timing == "interval" then
            if not self.buffTimers[buff] then
                self.buffTimers[buff] = def.interval
            end

            self.buffTimers[buff] = self.buffTimers[buff] - dt

            if self.buffTimers[buff] <= 0 then
                def.apply(self)
                self.buffTimers[buff] = def.interval
            end
        end
    end
end

function Unit:update(dt)
	-- store previous position
	self.prevX, self.prevY = self.x, self.y

    if self.flashTimer > 0 then
        self.flashTimer = self.flashTimer - dt
    end

	self:tickBuffs(dt)
	
	-- move
	self.x = self.x + self.vx * 60 * dt
	self.y = self.y + self.vy * 60 * dt
end

function Unit:attack(other)
    if self.party ~= other.party then
        -- === Precombat Buffs ===
        self:combatBuffs(other, "precombat")
        other:combatBuffs(self, "precombat")

        -- === Damage Calculation ===
        local selfDamage = self.hp - other.atk
        local otherDamage = other.hp - self.atk

        self.hp = math.max(0, selfDamage)
        other.hp = math.max(0, otherDamage)

        self.lastHit = other
        other.lastHit = self

        -- trigger flash
        local result = false
        if other.atk > 0 then
            self.flashTimer = self.flashDuration
            result = true
        end
        if self.atk > 0 then
            other.flashTimer = other.flashDuration
            result = true
        end

        -- === Postcombat Buffs ===
       	self:combatBuffs(other, "postcombat")
        other:combatBuffs(self, "postcombat")

        return result
    end
    return false
end

-- world-space hitbox rectangle
function Unit:getHitbox()
    -- remove hitbox if unit is dead
    if self.isDead then
        return self.x, self.y, 0, 0
    end
	return self.x, self.y, self.hitboxW, self.hitboxH
end

function Unit:bounce(dx, dy, collisionType)
	if self.bounceCount % 5 == 0 then
		self.randomizeBounce = true
	end
	
    if self.randomizeBounce then
        -- random bounce
        self.vx, self.vy = randomDirHalf(dx, dy)
		self.randomizeBounce = false
    else
        -- normal bounce (flip component along the normal)
        if dx ~= 0 then self.vx = -self.vx end
        if dy ~= 0 then self.vy = -self.vy end
    end

    -- increment counters
    self.bounceCount = self.bounceCount + 1
    if collisionType == "unit" then
        self.unitBounceCount = self.unitBounceCount + 1
    elseif collisionType == "wall" then
		self.wallBounceCount = self.wallBounceCount + 1
	end

end

-- border collision test using hitbox
function Unit:collidesBorder()
	local hx, hy, hw, hh = self:getHitbox()
	-- bounce off left/right walls
	return hx < 0 or hx + hw > bg.width or hy < 0 or hy + hh > bg.height
end

function Unit:resolveCollisionBorder()
    local hx, hy, hw, hh = self:getHitbox()

    -- left/right wall
    if hx < 0 then
        self.x = 0
		self:bounce(1, 0, "wall")
    elseif hx + hw > bg.width then
        self.x = bg.width - hw
        self:bounce(-1, 0, "wall")
    end

    -- top/bottom wall
    if hy < 0 then
        self.y = 0
        self:bounce(0, 1, "wall")
    elseif hy + hh > bg.height then
        self.y = bg.height - hh
        self:bounce(0, -1, "wall")
    end
end

-- collision test using hitboxes
function Unit:collides(other)
	local ax, ay, aw, ah = self:getHitbox()
	local bx, by, bw, bh = other:getHitbox()

	return ax < bx + bw and ax + aw > bx and ay < by + bh and ay + ah > by
end

-- Resolve collision by bouncing
function Unit:resolveCollision(other)
	-- get hitboxes
	local ax, ay, aw, ah = self:getHitbox()
	local bx, by, bw, bh = other:getHitbox()

	-- centers
	local acx, acy = ax + aw / 2, ay + ah / 2
	local bcx, bcy = bx + bw / 2, by + bh / 2

	-- overlap along x and y
	local overlapX = (aw / 2 + bw / 2) - math.abs(acx - bcx)
	local overlapY = (ah / 2 + bh / 2) - math.abs(acy - bcy)

	if overlapX < overlapY then
		if acx < bcx then
			self.x = self.x - overlapX / 2
			other.x = other.x + overlapX / 2
			self:bounce(-1, 0, "unit")
			other:bounce(1, 0, "unit")
		else
			self.x = self.x + overlapX / 2
			other.x = other.x - overlapX / 2
			self:bounce(1, 0, "unit")
			other:bounce(-1, 0, "unit")
		end
	else
		if acy < bcy then
			self.y = self.y - overlapY / 2
			other.y = other.y + overlapY / 2
			self:bounce(0, -1, "unit")
			other:bounce(0, 1, "unit")
		else
			self.y = self.y + overlapY / 2
			other.y = other.y - overlapY / 2
			self:bounce(0, 1, "unit")
			other:bounce(0, -1, "unit")
		end
	end
end

function Unit:drawHitbox()
    local hx, hy, hw, hh = self:getHitbox()
    L.rectangle("line", hx, hy, hw, hh)
end

function Unit:draw()
	-- apply offset when drawing image
    local sprite = self.image
    if self.flashTimer > 0 then
        sprite = self.blank
    end

	if sprite then
        L.draw(sprite, self.x + self.ox, self.y + self.oy)
	else
		self:drawHitbox()
    end
end

return Unit
