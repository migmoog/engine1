math.randomseed(love.timer.getDelta())

function love.load()
    -- lua modules are lowkey fucked
    require 'components.body'
    require 'components.sprite'
    require 'components.timer'

    require 'entities.player'
    require 'entities.npc'

    npcs.spawnTimer:start()
end

function love.keypressed(key, _scancode, _isrepeat)
    if not player.heart.active and key == 'space' then
        player:placeHeart()
    end
end

function love.update(dt)
    player:update(dt)
    npcs:update(dt)
end

function love.draw()
    npcs:draw()
    player:draw()
end
