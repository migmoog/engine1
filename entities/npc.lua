local function dir(dx, dy)
    return v2(dx, dy):normalize()
end
-- Frames are mapped to how they are in the spritesheet
local Directions = {
    dir(1, 1),
    dir(-1, 1),
    dir(-1, -1),
    dir(1, -1),
    dir(0, -1),
    dir(0, 1),
    dir(-1, 0),
    dir(1, 0)
}

local function makeNpc(x, y)
    local anim_counter = 0
    local s = makeSprite('images/man.png', 8, .38)
    -- fix the offset
    s.off.y = s.off.y * 2
    local npc = {}
    npc.body = makeBody(x, y, 30)
    npc.sprite = s
    npc.timer = makeTimer(1, function(ctx)
        ctx.body.velocity = Directions[ctx.dir]:clone():mul(50)
    end, npc)
    npc.dir = love.math.random(1, 8)
    npc.update = function(self, dt)
        self.sprite.frm = self.dir
        self.timer:update(dt)
        self.body:move(dt)
    end
    npc.draw = function(self)
        anim_counter = anim_counter + love.timer.getDelta()
        self.sprite.scl.y = wave(anim_counter / 1.5, .1, .38)
        self.sprite:draw(self.body.pos, 0)
    end

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
