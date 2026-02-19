local player = require("player")
local timer = require("timer")

function love.load()
  player.loadInformation()
end

function love.update(dt)
  player.move(dt)
  timer.update(dt)
end

function love.draw()
  player.visualize();
end
