local w, h = love.graphics.getDimensions()
player = {
	sprite = makeSprite("images/player.png", 4, 0.38),
	body = makeBody(w / 2, h / 2, 10),
	angle = 0,
}

local p = love.keyboard.isDown
function player:update(dt)
	local input = v2(btoi(p("d", "right")) - btoi(p("a", "left")), btoi(p("s", "down")) - btoi(p("w", "up")))
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
	if input.x ~= 0 then
		self.angle = lerp(self.angle, math.pi / 8.5 * input.x, 0.08)
	else
		self.angle = lerp(self.angle, 0, 0.025)
	end

	local step
	if input.x == 0 and input.y == 0 then
		step = 0.025
	else
		step = 0.08
	end

	self.body.velocity:lerp(input:mul(270), step)
	self.body:move(dt)
end

function player:draw()
	self.sprite:draw(self.body.pos, self.angle)
end
