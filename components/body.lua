-- Bodies with velocities and positions
function makeBody(x, y, radius)
    return {
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
    }
end
