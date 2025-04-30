function makeSprite(path, framec, scale)
	local img = love.graphics.newImage(path)
	local iw, ih = img:getDimensions()
	local qw = iw / framec

	local frames = {}
	for i = 0, framec - 1 do
		local f = love.graphics.newQuad(i * qw, 0, qw, ih, img)
		table.insert(frames, f)
	end

	return {
		scl = v2(scale),
		off = v2(qw / 2, ih / 2),
		frames = frames,
		frm = 1,
		draw = function(self, pos, angle)
			love.graphics.draw(img, self.frames[self.frm],
				pos.x, pos.y,
				angle,
				self.scl.x, self.scl.y,
				self.off.x, self.off.y)
		end,
	}
end
