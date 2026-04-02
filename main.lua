local player = require("player")
local timer = require("timer")
local camera = require("libraries/camera")
local scaling = require("scaling")
local push = require("libraries/push")
local enemy = require("Tankenemy");
local rocket = require("rocket");
local scale = require("scaling")
local rockets = {};
--local screen = require("screenTesting")

--local virtualWidth = 800
--local virtualHeight = 600

function love.load() 
  push:setupScreen(800, 600, love.graphics.getWidth(), love.graphics.getHeight(), {
  --resizable = true,
    --highdpi = true,
    --canvas = true
  })
  --[[
  love.graphics.setDefaultFilter("nearest", "nearest")

  local windowWidth, windowHeight = love.graphics.getDimensions()

  push:setupScreen(virtualWidth, virtualHeight, windowWidth, windowHeight, {
    vsync = true,
    resizable = true,
    pixelperfect = true
    --highdpi = true,
    --canvas = true
  })
  ]]
  
  player.loadInformation(rockets)
  rocket.load(player.playerWidth, player.playerHeight, 1000, 350 * scale.scale())
  camera = camera()
  enemy.load(rockets);
  enemy.createNewTank(100, 100);
end

function love.update(dt)
  player.move(dt, camera)
  timer.update(dt)
  enemy:update(player.x, player.y, dt);

  for i = #rockets, 1, -1 do
    rockets[i]:update(dt);
    if rockets[i].doneFor then table.remove(rockets, i); end
  end
end

function love.draw()
  --push:start()
  camera:attach()
  camera:lookAt(player.x, player.y)
  --love.graphics.scale(virtualWidth / windowWidth, virtualHeight / windowHeight)
  player.visualize()
  enemy:visualize();
  for _, r in ipairs(rockets) do r:visualize(); end
  camera:detach()
  --push:finish()
end

function love.resize(w, h)
  --push:resize(w, h)
  --windowWidth, windowHeight = love.graphics.getDimensions()
  print("sheni dedamovtyan")
  player.changeWidth(scaling.scale())
  --screen.resize(w, h)
end
