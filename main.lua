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

function love.update(dt)
    player:update(dt)
    npcs:update(dt)
end

function love.draw()
    npcs:draw()
    player:draw()

    if inDebug and drawBodies then
        for _, b in pairs(allBodies) do
            b:draw()
        end
    end
end
