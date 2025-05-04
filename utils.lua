-- vector2 object. You will never go without these in a 2D game
function v2(x, y)
    return {
        x = x,
        y = y,
        -- add a v2 to another v2
        add = function(self, other)
            self.x = self.x + other.x
            self.y = self.y + other.y
            return self
        end,

        -- subtract a v2 from another v2
        sub = function(self, other)
            self.x = self.x - other.x
            self.y = self.y - other.y
            return self
        end,

        -- scale a v2 by another v2
        mul = function(self, scale)
            self.x = self.x * scale
            self.y = self.y * scale
            return self
        end,

        -- divide a v2
        div = function(self, denom)
            self.x = self.x / denom
            self.y = self.y / denom
            return self
        end,

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
            return other:clone():sub(self):len()
        end,
        -- normalize this vector
        normalize = function(self)
            local len = self:len()
            return self:div(len)
        end,

        -- get signs
        signs = function(self)
            return v2(sign(self.x), sign(self.y))
        end,

        -- compare
        eq = function(self, other)
            return self.x == other.x and self.y == other.y
        end,
    }
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

function randfRange(min, max)
    return min + math.random() * (max - min)
end

function sign(n)
    return n < 0 and -1 or n > 0 and 1 or 0
end
