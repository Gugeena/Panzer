local player = require("player")
local timer = require("timer")
local Camera = require("libraries/camera")
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
local boundsC = require("bounds");
local alpha = 0;
local fadeOutSpeed = 1;
local showGameOverText = false;
local cam;
local mybutton = 
{
  x = 288;
  y = 275;
  width = 200,
  height = 50,
  --text = "Do Better",
  text = "Do Worse",
  --fn = function() love.load()
  fn = function() love.event.quit();
  end
}
--local screen = require("screenTesting")

--local virtualWidth = 800
--local virtualHeight = 600

function love.load() 
  rockets = {};
  enemies = {};
  alpha = 0;
  showGameOverText = false;
  player.gameOver = false;
  player.dead = false;
  timer.load();
  love.mouse.setVisible(true)

  math.randomseed(os.time());
  love.graphics.setFont(love.graphics.newFont("/assets/fonts/cruellete.otf", 26));
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

  enemy.load(rockets);
  player.loadInformation(rockets)
  rocket.load(player.playerWidth, player.playerHeight, 1000, 350 * currentScale)
  cam = Camera(); 
  --enemy.load(rockets);
  --enemy.createNewTank(100, 100);
end

function love.update(dt)
  player:update(dt, cam)
  timer.update(dt)
  --enemy:update(player.x, player.y, dt);
  enemyGen.generate(enemy, enemies, dt, player, boundsX, boundsY, spacing);
  collisions.collisions(rockets, player, dt, currentScale, enemies);
  for i = #enemies, 1, -1 do
    enemies[i]:update(player.x, player.y, dt);
  end

  if(player.gameOver and alpha < 1) then
    alpha = alpha + (fadeOutSpeed * dt);
  end
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
  cam:attach()
  cam:lookAt(player.x, player.y)
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
  for _, e in ipairs(enemies) do e:visualize(); end
  cam:detach()

  love.graphics.origin();

  love.graphics.setColor(0.5, 0, 1);
  love.graphics.print("PANZER", 10,10);
  love.graphics.setColor(1, 0, 0.5);
  love.graphics.print("ONE HIT SYSTEM", 10,50);
  love.graphics.setColor(0, 0.5, 1);
  love.graphics.print("BlastOMeter " .. player.score, 10,30);

  if(player.gameOver) then
    love.graphics.setColor(0,0,0, alpha);
    love.graphics.rectangle("fill", 0, 0, 1000, 1000);
    timer.crt(0.8, function ()
      showGameOverText = true;
    end)
  end

  if(showGameOverText) then 
    love.graphics.setColor(1, 0, 0.5, 1);
    love.graphics.print("SYSTEM DOWN", 311,200);
    love.graphics.setColor(0.5, 0, 1);
    love.graphics.rectangle("line", mybutton.x, mybutton.y + 15, mybutton.width, mybutton.height);
    love.graphics.setColor(0, 0.5, 1);
    love.graphics.print(mybutton.text, mybutton.x + 45, mybutton.y + 18);
  end
  --push:finish()
end

function love.resize(w, h)
  --push:resize(w, h)
  --windowWidth, windowHeight = --getDimensions()
  player.changeWidth(scaling.scale())
  --screen.resize(w, h)
end

function backGroundVisualise()
  local startX, endX, startY, endY = boundsC.bounds(player, boundsX, boundsY, spacing);

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

function love.mousepressed(x, y, button, istouch, presses)
  if button == 1 then
    hasPressed(x, y, mybutton.x, mybutton.y, mybutton.width, mybutton.height, mybutton.fn)
  end
end

function hasPressed(x, y, bx, by, width, height, func)
  if x >= bx and x <= (mybutton.x + width) and
    y >= by and y <= (mybutton.y + height) then
      func();
    end
end
