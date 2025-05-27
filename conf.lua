-- so you don't have to import the damn thing everywhere
require 'utils'

-- for development purposes, may not need this in the actual workshop
-- IDEA: Maybe hide in other file? (You can do that in lua)
if arg[2] == "debug" then
    require('lldebugger').start()
    inDebug = true
end

for i=1, #arg do
    if arg[i] == "drawBodies" then
        drawBodies = true
    elseif arg[i] == 'gif' then 
        waitForRecord = true
    end
end

local eh = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return eh(msg)
    end
end

function love.conf(t)
    t.window.width = 720
    t.window.height = 720
    t.window.title = "Flight Of The Lovebug♥"
end
