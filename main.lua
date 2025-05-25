math.randomseed(love.timer.getDelta())

function love.load()
    -- lua modules are lowkey fucked
    require 'components.body'
    require 'components.sprite'
    require 'components.timer'

    require 'entities.score'
    require 'entities.camera'
    require 'entities.player'
    require 'entities.npc'

    npcs:setup(player.matchInfo)
    npcs.spawnTimer:start()

    camera:addEntity(player)
    camera:addEntity(npcs)
end

function love.update(dt)
    player:update(dt)
    npcs:update(dt)
    camera:update(dt)
end

function love.draw()
    camera:draw()

    -- might be unnecessary for workshop
    if inDebug and drawBodies then
        for _, b in pairs(allBodies) do
            b:draw()
        end
    end

    matchInfo:draw()
    score:draw()
end
