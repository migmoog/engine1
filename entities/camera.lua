camera = {
    canv = love.graphics.newCanvas(),
    zoom = 1,
    desiredZoom = nil,
    entities = {},
}

function camera:addEntity(entity)
    assert(entity.draw, "Entity must have a draw method")
    table.insert(self.entities, entity)
end

function camera:zoomOut()
    self.desiredZoom = self.zoom - .08
end

function camera:resetZoom()
    self.desiredZoom = 1
end

function camera:getRealWidth()
    return love.graphics.getWidth() / self.zoom
end

function camera:getRealHeight()
    return love.graphics.getHeight() / self.zoom
end

function camera:getRealSize()
    return self:getRealWidth(), self:getRealHeight()
end

function camera:resizeCanvas()
    local w, h = self:getRealSize()
    self.canv = love.graphics.newCanvas(w, h)
end

function camera:update(dt)
    if self.desiredZoom then
        self.zoom = lerp(self.zoom, self.desiredZoom, .07)
        if math.abs(self.desiredZoom - self.zoom) < 0.01 then
            self.desiredZoom = nil
        end

        self:resizeCanvas()
    end
end

function camera:draw()
    -- Draw entities to the canvas at normal scale
    love.graphics.setCanvas(self.canv)
    love.graphics.clear(0, 0, 0, 0)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.push()
    -- No scaling or translation here
    for _, entity in ipairs(self.entities) do
        entity:draw()
    end
    love.graphics.pop()

    love.graphics.setCanvas()

    -- Draw the canvas to the screen, scaling about the center
    local sw, sh = love.graphics.getWidth(), love.graphics.getHeight()
    local cw, ch = self.canv:getWidth(), self.canv:getHeight()
    local scale = self.zoom
    local ox = (sw - cw * scale) / 2
    local oy = (sh - ch * scale) / 2
    love.graphics.draw(self.canv, ox, oy, 0, scale, scale)
end
