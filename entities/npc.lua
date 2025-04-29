local function dir(dx, dy)
    return v2(dx, dy):normalize()
end
-- Frames are mapped to how they are in the spritesheet
local Directions = {
    BOTTOM_RIGHT = dir(1, 1),
    BOTTOM_LEFT = dir(-1, 1),
    TOP_LEFT = dir(-1, -1),
    TOP_RIGHT = dir(1, -1),
    TOP = dir(0, -1),
    BOTTOM = dir(0, 1),
    LEFT = dir(-1, 0),
    RIGHT = dir(1, 0)
}

local function makeNpc(x, y)
    local npc = {
        body = makeBody(x, y, 30),
        sprite = makeSprite('images/man.png', 8, 0.38),
        dir = love.math.random(1, 8),
        update = function(self, dt)
            self.sprite.frm = self.dir
        end,
        draw = function(self)
            self.sprite:draw(self.body.pos, 0)
        end
    }

    return npc
end

npcs = {
    pool = {}
}

function npcs:make(x, y)
    if not x or not y then
        local p = randomScreenPos()
        x, y = p.x, p.y
    end
    table.insert(self.pool, makeNpc(x, y))
end

function npcs:update(dt)
    for _, n in pairs(self.pool) do
        n:update(dt)
    end
end

function npcs:draw()
    for _, n in pairs(self.pool) do
        n:draw()
    end
end
