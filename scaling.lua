local scaling = {}
local virtualWidth = 800
local virtualHeight = 600
local windowHeight, windowWidth
local scale;

function scaling.scale()
  windowWidth, windowHeight = love.graphics.getDimensions()
  scale = avg(windowWidth / virtualWidth, windowHeight / virtualHeight)
  return scale
end

function avg(a,b)
  return (a + b) / 2
end
return scaling