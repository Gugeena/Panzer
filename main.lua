local player = require("player")
local timer = require("timer")
local camera = require("libraries/camera")
local scaling = require("scaling")
local push = require("libraries/push")
local enemy = require("Tankenemy");
local rocket = require("rocket");
local scale = require("scaling");
local collisions = require("collisions");
local ParticleGenerator = require("ParticleGenerator");
local rockets = {};
local currentScale = 0;
local x = 0;
local boundsX, boundsY;
local spacing;
local enemyGen = require("enemyGenerator");
local enemies = {};
--local screen = require("screenTesting")

--local virtualWidth = 800
--local virtualHeight = 600

function love.load() 
  local virtualWidth = 1280;
  local virtualHeight = 800;
  local windowWidth, windowHeight = love.graphics.getDimensions();

  push:setupScreen(virtualWidth, virtualHeight, windowWidth, windowHeight, 
  {
    vsync = true;
    resizable = false;
    pixelperfect = true;
  })

  currentScale = scale.scale();
  spacing = 32 * currentScale;
  boundsX, boundsY = windowWidth / 2, windowHeight / 2;

  player.loadInformation(rockets)
  rocket.load(player.playerWidth, player.playerHeight, 1000, 350 * currentScale)
  camera = camera()
  --enemy.load(rockets);
  --enemy.createNewTank(100, 100);
end

function love.update(dt)
  player:update(dt, camera)
  timer.update(dt)
  --enemy:update(player.x, player.y, dt);
  collisions.collisions(rockets, player, dt, currentScale, ParticleGenerator.Particles, enemies);
end

--[]
--function calculatePoints()
 -- local playerFurthestX = player.x + (player.playerWidth / 2);
 -- local playerClosestX = player.x - (player.playerWidth / 2);
 -- local playerFurthestY = player.y + (player.playerHeight / 2);
 -- local playerClosestY = player.y - (player.playerHeight / 2);
 -- return playerFurthestX, playerClosestX, playerFurthestY, playerClosestY;
--end
--]

function love.draw()
  --push:start()
  camera:attach()
  camera:lookAt(player.x, player.y)
  enemyGen.generate(enemy, 1, enemies)
  ----scale(virtualWidth / windowWidth, virtualHeight / windowHeight)
  backGroundVisualise();
  player:visualize();
  --enemy:visualize();
  --[
  --love.graphics.push();
  --translate(player.x, player.y);
  --rotate(player.angle);
  --setColor(1,0,0);
  --local s = 0.5 * scale.scale();
  --local w = player.playerWidth * s;
  --local h = player.playerHeight * s;
  --rectangle("line", -w/2,  -h/2, w, h)
  --pop();
  --]
  for _, r in ipairs(rockets) do r:visualize(); end
  camera:detach()
  --push:finish()
end

function love.resize(w, h)
  --push:resize(w, h)
  --windowWidth, windowHeight = --getDimensions()
  print("sheni dedamovtyan")
  player.changeWidth(scaling.scale())
  --screen.resize(w, h)
end

function bounds()
  local endOffset = 26;

  local startX = math.floor((player.x - boundsX) / spacing) * spacing
  local startY = math.floor((player.y - boundsY) / spacing) * spacing

  local endX  = (math.floor((player.x + boundsX) / spacing) * spacing)  + endOffset
  local endY  = (math.floor((player.y + boundsY) / spacing) * spacing)  + endOffset

  return startX, endX, startY, endY;
end

function backGroundVisualise()
  local startX, endX, startY, endY = bounds();

  love.graphics.setColor(0.5, 0, 1)

  for x = startX, endX, spacing 
  do
    love.graphics.line(x, startY, x, endY)
  end

  for y = startY, endY, spacing
  do
    love.graphics.line(startX, y, endX, y)
  end
end
