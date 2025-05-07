-- metatable magic :-D
local vector2MT = {
    __eq = function(a, b)
        return a.x == b.x and a.y == b.y
    end,
    -- add a v2 to another v2
    __add = function(a, b)
        return v2(a.x + b.x, a.y + b.y)
    end,
    __sub = function(a, b)
        return v2(a.x - b.x, a.y - b.y)
    end,
    __mul = function(a, b)
        return v2(a.x * b, a.y * b)
    end,
    __div = function(a, b)
        return v2(a.x / b, a.y / b)
    end,
}

-- vector2 object. You will never go without these in a 2D game
function v2(x, y)
    local out = {
        x = x,
        y = y,
        -- lerp to a v2
        lerp = function(self, other, step)
            self.x = lerp(self.x, other.x, step)
            self.y = lerp(self.y, other.y, step)
            return self
        end,

        -- clone a v2
        clone = function(self)
            return v2(self.x, self.y)
        end,

        -- length of a v2
        len = function(self)
            return math.sqrt(self.x * self.x + self.y * self.y)
        end,

        -- gets the distance from one point/v2 to another
        distanceTo = function(self, other)
            return math.sqrt((self.x - other.x) ^ 2 + (self.y - other.y) ^ 2)
        end,

        -- get the angle between two v2s
        angleTo = function(self, other)
            return math.atan2(other.y - self.y, other.x - self.x)
        end,

        -- normalize this vector
        normalize = function(self)
            local len = self:len()
            return self / len
        end,

        -- get signs
        signs = function(self)
            return v2(sign(self.x), sign(self.y))
        end,
    }

    setmetatable(out, vector2MT)
    return out
end

-- random vector2 generation
function randomScreenPos()
    local w, h = love.graphics.getDimensions()
    return v2(love.math.random(0, w), love.math.random(0, h))
end

-- get center coordinates of the world
function centerPos()
    local w, h = love.graphics.getDimensions()
    return v2(w / 2, h / 2)
end

-- booleans to integers
function btoi(b)
    return b and 1 or 0
end

-- linear interpolation
function lerp(a, b, step)
    return a + ((b - a) * step)
end

-- waves a number around an offset
function wave(x, a, c)
    return a * math.sin(x * math.pi * 2) + c
end

-- gets a float within a range, make sure you seed it though.
function randfRange(min, max)
    return min + math.random() * (max - min)
end

-- gets the sign of the provided number
function sign(n)
    return n == 0 and 0 or n / math.abs(n)
end
