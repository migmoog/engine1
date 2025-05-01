local function dir(dx, dy)
    return v2(dx, dy):normalize()
end
-- Frames are mapped to how they are in the spritesheet
local directions = {
    dir(1, 1),   -- bottom right
    dir(-1, 1),  -- bottom left
    dir(-1, -1), -- top left
    dir(1, -1),  -- top right
    dir(0, -1),  -- top
    dir(0, 1),   -- bottom
    dir(-1, 0),  -- left
    dir(1, 0)    -- right
}

-- states for npcs
local states = {
    born = function(self, dt)

    end,

    alive = function(self, dt)
        self.sprite.frm = self.dir
        self.stopTimer:update(dt)
        self.moveTimer:update(dt)
        self.body:move(dt)
    end,

    leaving = function(self, dt)

    end,

    gotMatch = function(self, dt)

    end,

    metMatch = function(self, dt)

    end,
}

local function makeNpc(x, y)
    local anim_counter = 0
    local s = makeSprite('images/man.png', 8, .38)
    -- fix the offset
    s.off.y = s.off.y * 2
    local npc = {}
    npc.body = makeBody(x, y, 30)
    npc.sprite = s
    npc.speed = love.math.random(85, 175)
    npc.moveTimer = makeTimer(1, function(ctx)
        ctx.body.velocity = directions[ctx.dir]:clone():mul(ctx.speed)
        npc.stopTimer:start()
    end, npc)
    npc.dir = love.math.random(1, 8)
    npc.moveTimer:start()
    npc.update = states.alive

    npc.stopTimer = makeTimer(randfRange(.8, 3), function(ctx)
        ctx.body.velocity = v2(0, 0)

        ctx.dir = love.math.random(1, 8)
        ctx.moveTimer:start()
    end, npc)

    npc.draw = function(self)
        anim_counter = anim_counter + love.timer.getDelta()
        self.sprite.scl.y = wave(anim_counter / 1.5, .07, .38)
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
