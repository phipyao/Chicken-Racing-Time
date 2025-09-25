Class = {}
Class.__index = Class

function Class.new(params)
    local p = params or {}

    local instance = {
        -- declare local variables here:
        -- x = params.x or 0
    }

    setmetatable(instance, Class)
    return instance
end

function Class:update(dt)

end

function Class:draw()

end

return Class
