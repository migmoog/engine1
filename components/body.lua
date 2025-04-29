-- Bodies with velocities and positions
function makeBody(x, y, radius)
    return {
        pos = v2(x, y),
        rad = radius,
        velocity = v2(0, 0),
        move = function(self, dt)
            self.pos:add(self.velocity:clone():mul(dt))
        end,
    }
end
