local center = centerPos()
-- Heart chain
local heart = {
	body = makeBody(center.x, center.y, 8),
	sprite = makeSprite('images/grossheart.png', 1, 1),
	active = false,
}
local anim_counter = 0
function heart:activate(vec)
	self.active = true
	self.body.pos = vec
end

function heart:update(dt)
	if not self.active then
		return
	end
	anim_counter = anim_counter + dt
	self.sprite.scl.x = wave(anim_counter / 1.5, .1, 0.82)
	self.sprite.scl.y = wave(anim_counter / .75, .2, 0.7)
end

function heart:draw()
	if not self.active then
		return
	end
	self.sprite:draw(self.body.pos, 0)
end

-- The actual lovebug
player = {
	sprite = makeSprite("images/player.png", 4, 1),
	body = makeBody(center.x, center.y, 10),
	angle = 0,
	heart = heart
}

function player:placeHeart()
	self.heart:activate(self.body.pos:clone())
end

local p = love.keyboard.isDown
function player:update(dt)
	local input = v2(btoi(p("d", "right")) - btoi(p("a", "left")),
		btoi(p("s", "down")) - btoi(p("w", "up")))
	if input.x < 0 then
		self.sprite.frm = 4
	elseif input.x > 0 then
		self.sprite.frm = 1
	elseif input.y < 0 then
		self.sprite.frm = 2
	elseif input.y > 0 then
		self.sprite.frm = 3
	end

	-- gives life to the lovebug
	self.angle = input.x ~= 0 and
		lerp(self.angle, math.pi / 8.5 * input.x, 0.08)
		or
		lerp(self.angle, 0, 0.025)

	local step = (input.x == 0 and input.y == 0) and
		0.025
		or
		0.08

	self.body.velocity:lerp(input:clone():mul(270), step)
	self.body:move(dt)

	self.heart:update(dt)
end

function player:draw()
	self.heart:draw()
	self.sprite:draw(self.body.pos, self.angle)
end
