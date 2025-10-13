local SFX = {}
SFX.__index = SFX

function SFX.new(params)
    local p = params or {}

    local instance = {
        source     = love.audio.newSource(p.path, "static"),
        volume     = p.volume or 0.8,
        basePitch  = p.pitch or 1.0,
        randPitch  = p.randPitch or 0.2,
    }

    setmetatable(instance, SFX)
    return instance
end

function SFX:trigger()
    local pitch = self.basePitch + (random() * 2 - 1) * self.randPitch
    self.source:setPitch(pitch)
    self.source:setVolume(self.volume)
    self.source:stop()
    self.source:play()
end

return SFX