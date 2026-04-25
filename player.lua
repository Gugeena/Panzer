--local player = { x = 100, y = 100, speed = 200, playerWidth = 50, playerHeight = 50 }
local decleration = "I love you"
local player = {x = 0, y = 0, speed = 200, playerWidth = 0, playerHeight = 0, limitX = 0, limitY = 0, bottomImage, topImage, angle = 0, bodyAngle = 0, TopWidth = 0, TopHeight = 0, topRotation = 0, topImageFALSE, deathParticles, dead = false, deatehParticlesVisual, canShoot = true, score = 0, gameOver = false, wasJustDead = false, maxScore = 0} 
local spacing = 32;
local rocket = require("rocket")
local moving = false
local timer = require("timer")
local scale = require("scaling")
local ParticleGenerator = require("ParticleGenerator");
local endOffSet = 26;
local AudioManager = require("AudioManager");
local rockets = {};

function player.loadInformation(r)
  player.bottomImage = love.graphics.newImage("assets/TankBottom.png")
  player.topImage = love.graphics.newImage("assets/TankTop.png")
  player.playerWidth = player.bottomImage:getWidth()
  player.topImageFALSE  = love.graphics.newImage("assets/TankTopCANT.png")
  player.playerHeight = player.bottomImage:getHeight()
  player.dead = false;
  player.topRotation = 0;
  player.bodyAngle = 0;
  player.gameOver = false;
  if not love.filesystem.getInfo("score.txt") then 
    love.filesystem.write("score.txt", 0)
  else 
    local content = love.filesystem.read("score.txt") or 0;
    player.maxScore = tonumber(content) or 0;
  end
  --player.limitX = 10000000
  --player.limitY = 10000000
  player.TopWidth = player.topImage:getWidth()
  player.TopHeight = player.topImage:getHeight()
  love.graphics.setLineWidth(2)
  spacing = spacing * scale.scale();
  rockets = r;
  player.dead = false;
  player.deathParticles = ParticleGenerator.newParticle(player.x, player.y, 400, scale.scale())
end

function player:update(dt, cam)
  if(self.dead == false) then
    player:Movement(dt)
    rotateToMouse(cam)
  else
    self.deathParticles:update(dt);
  end
end

function player:Movement(dt)
  if (self.dead == false) then
  if love.keyboard.isDown("d") or love.keyboard.isDown("right")  then   
    self.angle = self.angle + 1 * dt
  end

  if love.keyboard.isDown("a") or love.keyboard.isDown("left")  then   
    self.angle = self.angle - 1 * dt
  end

  if love.keyboard.isDown("w") or love.keyboard.isDown("up")  then   
    --player.x = player.x - math.cos(player.angle + math.rad(90)) * player.speed * dt
    --player.y = player.y - math.sin(player.angle + math.rad(90)) * player.speed * dt
    local xChange = math.cos(player.angle + math.rad(90)) * self.speed * dt
    local yChange = math.sin(player.angle + math.rad(90)) * self.speed * dt
    self.x = self.x - xChange
    self.y = self.y - yChange
    moving = true;
  end


  if(love.mouse.isDown(1) and player.canShoot and moving == false) then
    player.canShoot = false;
    local offset = 86 * scale.scale();
    local spawnX = player.x - math.cos(player.topRotation + math.rad(90)) * offset
    local spawnY = player.y - math.sin(player.topRotation + math.rad(90)) * offset
    local r = rocket.newRocket(spawnX, spawnY, player.topRotation, false);
    table.insert(rockets, r);
    if(player.canShoot == false) then 

    timer.crt(1.5,
    function ()

    player.canShoot = true;

    end)
    end
  end
  end
  --   if player.x < player.limitX then
  --   if love.keyboard.isDown("d") or love.keyboard.isDown("right")  then   
  --   --player.x = player.x + player.speed * dt 
  --   --player.transform:Translate(transform.right * player.speed * dt)
  --   end
  -- end

  -- if player.x > 0 then
  --   if love.keyboard.isDown("a") or love.keyboard.isDown("left")  then   
  --   player.x = player.x - player.speed * dt
  --   end 
  -- end

  -- if player.y > 0 then
  --   if love.keyboard.isDown("w") or love.keyboard.isDown("up")  then   
  --   player.y = player.y - player.speed * dt
  --   end 
  -- end

  -- if player.y < player.limitY then
  --   if love.keyboard.isDown("s") or love.keyboard.isDown("down") then   
  --   player.y = player.y + player.speed * dt
  --   end 
  -- end
  -- --]
  moving = false
end

function rotateToMouse(cam)
  local mouseX, mouseY = cam:worldCoords(love.mouse.getX(), love.mouse.getY())

  --local centerX = player.x + player.playerWidth / 2
  --local centerY = player.y + player.playerHeight / 2

  local deltaX = mouseX - player.x
  local deltaY = mouseY - player.y
  --player.angle = math.atan2(deltaY, deltaX)
  player.topRotation = math.atan2(deltaY, deltaX) + math.rad(90)
end

function player:visualize()
  love.graphics.setColor(1, 1, 1)
  --love.graphics.setColor(0, 1, 0) 
  if (self.dead == false) then
  love.graphics.draw(self.bottomImage, self.x, self.y, self.angle, 0.5 * scale.scale(), 0.5 * scale.scale(), self.playerWidth / 2, self.playerHeight / 2)
  local localTop = self.topImage
  if (self.canShoot == false or love.keyboard.isDown("w") or love.keyboard.isDown("up")) then
    localTop = self.topImageFALSE
  end
  love.graphics.draw(localTop, self.x, self.y, self.topRotation, 0.5 * scale.scale(), 0.5 * scale.scale(), self.TopWidth / 2, (self.TopHeight / 2) + 12)
else 
  --self.deathParticles:draw()
  love.graphics.draw(self.deathParticles);
end

  --love.graphics.draw(player.topImage, player.x, player.y, player.topRotation, 0.5, 0.5, player.TopWidth / 2, (player.TopHeight / 2) + 12)

  -- aint working

  --if(shot) then
   --rocket.update(love.timer.getDelta())
   --rocket:visualize()
  --end
end

function player.changeWidth(size)
  love.graphics.setLineWidth(2 * size) 
  spacing = 32 * size;  
  endOffSet = 26 * size;
  player.speed = 200 * size;
end

function player:death()
  if(self.dead == true) then return; end
  self.dead = true;
  self.deathParticles:setPosition(self.x, self.y);
  self.deathParticles:emit(100);
  AudioManager:Texplosion();
  self.wasJustDead = true;
  if(self.maxScore < self.score) then 
    love.filesystem.write("score.txt", tostring(self.score)); 
    self.maxScore = self.score;
  end
  timer.crt(0.8, function ()
    self.gameOver = true;
    print(self.score);
    print(self.maxScore);
  end)
end

function player:incriment()
  self.score = self.score + 50;
end

return player
