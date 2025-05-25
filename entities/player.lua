-- match with text + icons
matchInfo = {
	textImg = makeSprite("images/matchwith.png", 1, 1),
	icons = {
		makeSprite("images/icon.png", 1, 1),
		makeSprite("images/icon.png", 1, 1)
	},
	leftColor = 1,
	rightColor = 2,
}
function matchInfo:draw()
	local cp = centerPos()
	cp.y = self.textImg.off.y
	self.textImg:draw(cp, 0)

	local leftEdge = cp.x - self.textImg.off.x

	-- draw the icons with their corresponding colors
	love.graphics.setColor(Colors[self.leftColor])
	local iconLeft = v2(leftEdge + 275, self.textImg.off.y)
	self.icons[1]:draw(iconLeft, 0)

	love.graphics.setColor(Colors[self.rightColor])
	local iconRight = v2(cp.x + self.textImg.off.x + 25, self.textImg.off.y)
	self.icons[2]:draw(iconRight, 0)

	love.graphics.setColor(1, 1, 1)
end

-- randomly picks two new colors
function matchInfo:reset()
	self.leftColor = love.math.random(1, #Colors)
	self.rightColor = love.math.random(1, #Colors)
	while self.leftColor == self.rightColor do
		self.rightColor = love.math.random(1, #Colors)
	end
end

local center = centerPos()
-- Heart chain
local heart = {
	body = makeBody(center.x, center.y, 8),
	sprite = makeSprite('images/grossheart.png', 1, 1),
	active = false,
}
local animTime = 0
local w, h = heart.sprite:getDimensions()
local diagonal = math.sqrt(w * w + h * h)
function heart:activate(vec)
	self.active = true
	self.body.pos = vec
end

function heart:deactivate(matchInfo, overlaps)
	self.active = false
	if #overlaps <= 1 then
		return
	end

	camera:zoomOut()

	local matches = {
		[matchInfo.leftColor] = {},
		[matchInfo.rightColor] = {},
	}

	for _, n in pairs(overlaps) do
		if not matches[n.clr] then
			camera:resetZoom()
			score:reset()
			matchInfo:reset()
			return
		end
		table.insert(matches[n.clr], n)
	end
	
	local matchCount = math.min(#matches[matchInfo.leftColor],
	#matches[matchInfo.rightColor])
	for i = 1, matchCount do
		local left = table.remove(matches[matchInfo.leftColor])
		local right = table.remove(matches[matchInfo.rightColor])
		left:fallInLove(right)
	end

	score:addMatches(matchCount)
	matchInfo:reset()
end

function heart:update(dt)
	if not self.active then
		return
	end
	animTime = animTime + dt

	-- map scale to the heart's radius, then add a lil wobble
	local step = animTime / 1.5
	self.sprite.scl = (v2(1, 1) * ((2.5 * self.body.rad) / diagonal)) +
		v2(wave(step, .25, 0), wave(step, .20, 0))
end

function heart:draw()
	if not self.active then
		self.body.rad = 0
		return
	end

	love.graphics.setColor(1, 1, 1, 0.55)
	self.sprite:draw(self.body.pos, 0)
	love.graphics.setColor(1, 1, 1, 1)
end

-- The actual lovebug
player = {
	sprite = makeSprite("images/player.png", 4, 1),
	body = makeBody(center.x, center.y, 10),
	angle = 0,
	heart = heart,
	matchInfo = matchInfo,
	maxRad = camera:getRealWidth() / 5,
}

function player:placeHeart()
	self.heart:activate(self.body.pos:clone())
end

local p = love.keyboard.isDown
function player:update(dt)
	-- update max radius
	self.maxRad = camera:getRealWidth() / 5
	
	-- control player animation and movement
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

	self.body.velocity:lerp(input * 270, step)
	self.body:move(dt)


	-- using the heart
	if p('space') then
		if not self.heart.active then
			self:placeHeart()
		else
			local dist = self.heart.body.pos:distanceTo(self.body.pos)
			-- self.heart.body.rad = dist
			if dist > self.maxRad then
				self.heart.body.rad = self.maxRad
				-- clamp the player to the max radius
				self.body.pos = self.heart.body.pos +
					(self.body.pos - self.heart.body.pos):normalize() * self.maxRad
			else
				self.heart.body.rad = dist
			end
		end
	elseif self.heart.active then
		-- iterate through npcs to find any overlaps
		local overlaps = npcs:findOverlaps(self.heart.body)
		self.heart:deactivate(self.matchInfo, overlaps)
	end


	local w, h = love.graphics.getDimensions()
	if self.body.pos.x < 0 then
		self.body.pos.x = 0
	elseif self.body.pos.x > w then
		self.body.pos.x = w
	end
	if self.body.pos.y < 0 then
		self.body.pos.y = 0
	elseif self.body.pos.y > h then
		self.body.pos.y = h
	end

	self.heart:update(dt)
end

function player:draw()
	self.heart:draw()
	self.sprite:draw(self.body.pos, self.angle)
end
