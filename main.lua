local player = require("player")
local timer = require("timer")

function love.load()
  player.loadInformation()
end

function love.update(dt)
  player.move(dt)
end

function love.draw()
  player.visualize();
end
