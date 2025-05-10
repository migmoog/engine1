if inDebug then
    allBodies = {}
end


-- Bodies with velocities and positions
function makeBody(x, y, radius)
    local out = {
        pos = v2(x, y),
        rad = radius,
        velocity = v2(0, 0),
        move = function(self, dt)
            self.pos = self.pos + self.velocity * dt
        end,
        -- checks if a body overlaps with another
        overlaps = function(self, other)
            return self.pos:distanceTo(other.pos) < self.rad
        end,

        -- draws the body as a circle
        draw = function(self)
            love.graphics.setColor(1, 1, 1, 0.5)
            love.graphics.circle("fill", self.pos.x, self.pos.y, self.rad)
            love.graphics.setColor(1, 1, 1, 1)
        end,
    }


    table.insert(allBodies, out)

    return out
end
