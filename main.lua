function love.load()
    require 'entities.player'
    require 'entities.npc'

    npcs:make(720 / 4, 500)
end

function love.update(dt)
    player:update(dt)
    npcs:update(dt)
end

function love.draw()
    player:draw()
    npcs:draw()
end
