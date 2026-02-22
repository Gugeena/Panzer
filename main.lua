local player = require("player")
local timer = require("timer")
local camera = require("libraries/camera")
local push = require("libraries/push")

local virtualWidth = 800
local virtualHeight = 600

local windowWidth, windowHeight = love.graphics.getDimensions()

function love.load()  
  love.graphics.setDefaultFilter("nearest", "nearest")
  push:setupScreen(virtualWidth, virtualHeight, windowWidth, windowHeight, {
    fullscreen = false,
    vsync = true,
    resizable = false,
    pixelperfect = true,
    --highdpi = true,
    --canvas = true
  })
  player.loadInformation()
  camera = camera()
end

function love.update(dt)
  --camera:zoom(conf.scale)
  player.move(dt)
  timer.update(dt)
end

function love.draw()
  push:setBorderColor(1,1,1)
  --push:start()
  --camera:attach()
  --camera:lookAt(player.x, player.y)
  player.visualize()
  --camera:detach()
  --push:finish()
end

function love.resize(w, h)
  push:resize(w, h)
end
