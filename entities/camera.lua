camera = {
    canv = love.graphics.newCanvas(),
    zoom = 1,
    entities = {},
}

function camera:draw()
    love.graphics.setCanvas(self.canv)
    love.graphics.clear(0, 0, 0, 0)
    love.graphics.setColor(1, 1, 1, 1)

    for _, entity in ipairs(self.entities) do
        entity:draw()
    end

    -- draw the canvas to the screen
    love.graphics.setCanvas()
    love.graphics.draw(self.canv, 0, 0)
end
