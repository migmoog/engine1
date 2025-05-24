-- Frames are mapped to how they are in the spritesheet
local directions = {
    v2(1, 1),   -- bottom right
    v2(-1, 1),  -- bottom left
    v2(-1, -1), -- top left
    v2(1, -1),  -- top right
    v2(0, -1),  -- top
    v2(0, 1),   -- bottom
    v2(-1, 0),  -- left
    v2(1, 0)    -- right
}
function directions:get(d)
    return self[d]:normalize()
end

function directions:indexOf(vec)
    for i, v in ipairs(self) do
        if v == vec then
            return i
        end
    end

    return -1
end

-- states for npcs
local center = centerPos()
local function makeNpc(x, y)
    local anim_counter = 0
    -- fix the offset
    local npc = {
        body = makeBody(x, y, 30),
        sprite = makeSprite('images/man.png', 8, 1),
        speed = love.math.random(85, 175),
        matched = false,
        clr = love.math.random(1, 3)
    }
    npc.sprite.off.y = npc.sprite.off.y * 2

    -- sets the var and maps a corresponding velocity
    function npc:setDir(d)
        self.dir = d
        self.body.velocity = directions:get(self.dir) * self.speed
    end

    npc:setDir(love.math.random(1, 8))

    function npc:fallInLove(other)
        self.matched, other.matched = true, true

        local midPoint = (self.body.pos + other.body.pos) / 2
        self.body.pos, other.body.pos = midPoint, midPoint

        local function flyAway(self, dt)
            -- fly away to the top of the screen
            self.body.velocity = v2(0, -500)
            self.body:move(dt)
        end
        self.update = flyAway
        other.update = flyAway
    end

    -- walks onto the screen until it goes to dawdle mode
    function npc:born(dt)
        self.body:move(dt)

        if self.body.pos:distanceTo(center) < 280 then
            self.body.velocity = v2(0, 0)
            self.moveTimer:start()
            self.leaveTimer:start()
            self.update = self.alive
        end
    end

    -- dawdling state
    function npc:alive(dt)
        if self.leaveTimer:update(dt) then
            self.stopTimer:update(dt)
            self.moveTimer:update(dt)
        end

        for _, axis in ipairs({ "x", "y" }) do
            if self.body.pos[axis] > 720 or self.body.pos[axis] < 0 then
                self.body.velocity[axis] = -self.body.velocity[axis]
                self.dir = directions:indexOf(self.body.velocity:signs())
                self.body.pos = self.body.pos + directions:get(self.dir)
                assert(self.dir ~= -1, "Invalid direction")
            end
        end

        self.body:move(dt)
    end

    -- time is up and leaving the screen
    function npc:leave(dt)
        if self.body.pos:isOnScreen() then
            self.body:move(dt)
        else
            self.matched = true
        end
    end

    -- waits to begin movement for the npc
    npc.moveTimer = makeTimer(1, function(ctx)
        ctx:setDir(ctx.dir)
        npc.stopTimer:start()
    end, npc)

    if not v2(x, y):isOnScreen() then
        npc.update = npc.born
    else
        npc.update = npc.alive
    end

    -- stops the guy as it moves
    npc.stopTimer = makeTimer(randfRange(.8, 3), function(ctx)
        ctx.body.velocity = v2(0, 0)

        ctx.dir = love.math.random(1, 8)
        ctx.moveTimer:start()
    end, npc)

    -- makes the damn thing leave
    npc.leaveTimer = makeTimer(randfRange(5, 10), function(ctx)
        if not ctx.matched then
            local perps = { 5, 6, 7, 8 }
            local d = perps[love.math.random(1, 4)]
            ctx:setDir(d)
            ctx.update = ctx.leave
        end
    end, npc)

    local _, h = npc.sprite:getDimensions()
    local drawOffset = v2(0, h * .45)
    npc.draw = function(self)
        self.sprite.frm = self.dir
        love.graphics.setColor(Colors[self.clr])

        anim_counter = anim_counter + love.timer.getDelta()
        self.sprite.scl.y = wave(anim_counter / 1.5, .1, 0.85)
        self.sprite:draw(self.body.pos + drawOffset, 0)

        love.graphics.setColor({ 1, 1, 1, 1 })
    end

    return npc
end

npcs = {
    pool = {}
}
npcs.spawnTimer = makeTimer(3, function(ctx)
    local w, h = love.graphics.getDimensions()
    local pos = centerPos()

    -- Direction and position presets for each side
    local sides = {
        { axis = "y", value = -50,    dir = 6, offsetAxis = "x", spread = (w / 2) * 0.75 }, -- top
        { axis = "x", value = w + 50, dir = 7, offsetAxis = "y", spread = (h / 2) * 0.75 }, -- right
        { axis = "y", value = h + 50, dir = 5, offsetAxis = "x", spread = (w / 2) * 0.75 }, -- bottom
        { axis = "x", value = -50,    dir = 8, offsetAxis = "y", spread = (h / 2) * 0.75 }, -- left
    }

    local side = love.math.random(1, 4)
    local s = sides[side]

    pos[s.axis] = s.value
    pos[s.offsetAxis] = pos[s.offsetAxis] + randfRange(-s.spread, s.spread)

    local n = ctx:make(pos.x, pos.y)
    n:setDir(s.dir)
    ctx.spawnTimer:start(randfRange(3, 4.5))
end, npcs)

function npcs:make(x, y)
    if not x or not y then
        local p = randomScreenPos()
        x, y = p.x, p.y
    end
    local n = makeNpc(x, y)
    table.insert(self.pool, n)
    return n
end

function npcs:setup()
    -- set up an inital pool of npcs at random positions within the bounds
    for i = 1, 10 do
        local p = randomScreenPos()
        self:make(p.x, p.y)
    end
end

function npcs:update(dt)
    self.spawnTimer:update(dt)
    -- search for matched npcs and remove them from the pool
    for i = #self.pool, 1, -1 do
        local n = self.pool[i]
        if n.matched and not n.body.pos:isOnScreen() then
            table.remove(self.pool, i)
        end
    end

    for _, n in pairs(self.pool) do
        n:update(dt)
    end
end

function npcs:findOverlaps(body)
    local overlaps = {}
    for _, n in pairs(self.pool) do
        if n.body:overlaps(body) then
            table.insert(overlaps, n)
        end
    end
    return overlaps
end

function npcs:draw()
    for _, n in pairs(self.pool) do
        n:draw()
    end
end
