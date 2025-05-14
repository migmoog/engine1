math.randomseed(love.timer.getDelta())

function love.load()
    -- lua modules are lowkey fucked
    require 'components.body'
    require 'components.sprite'
    require 'components.timer'

    require 'entities.player'
    require 'entities.npc'
    require 'entities.camera'

    npcs:setup()
    npcs.spawnTimer:start()

    table.insert(camera.entities, player)
    table.insert(camera.entities, npcs)
end

function love.update(dt)
    player:update(dt)
    npcs:update(dt)
end

function love.draw()
    camera:draw()
    if inDebug and drawBodies then
        for _, b in pairs(allBodies) do
            b:draw()
        end
    end

    matchInfo:draw()
end
