local rocket = {image, x, y, speed, angle, playerWidth, playerHeight, range, spriteSheet, grid, animations, particleEnd, pSystem, doneFor, rocketWidth, rocketHeight, exploding, isRocket}
local anim8 = require("libraries/anim8")
local timer = require("timer")
local scale = require("scaling")
local ParticleGenerator = require("ParticleGenerator");
local rocketCount = -1;
rocket.__index = rocket;

function rocket.newRocket(x, y, angle)
  local newRocket = setmetatable({}, rocket)
  newRocket.x = x;
  newRocket.y = y;
  newRocket.angle = angle;
  newRocket.spriteSheet = rocket.spriteSheet;
  newRocket.doneFor = false;
  newRocket.exploding = false;
  --newRocket.id = rocketCount+1;
  newRocket.pSystem = ParticleGenerator.newParticle(x, y, 100, scale.scale())
  --table.insert(ParticleGenerator.Particles, newRocket.pSystem);
  timer.crt(1.5, function() 
    newRocket.exploding = true 
    newRocket.pSystem:setPosition(newRocket.x, newRocket.y);
    newRocket.pSystem:emit(50)
     timer.crt(1.2, function() 
     newRocket.doneFor = true 
    end)
    end)
  return newRocket;
end
  
function rocket.load(playerWidth, playerHeight, range, speed)
  rocket.image = love.graphics.newImage("assets/rocketPlayer.png") 
  rocket.playerWidth = playerWidth
  rocket.playerHeight = playerHeight
  rocket.range = range
  rocket.speed = speed;
  rocket.spriteSheet = love.graphics.newImage("assets/rocketFrames-Sheet.png")
  rocket.width = rocket.spriteSheet:getWidth() / 4
  rocket.height = rocket.spriteSheet:getHeight() / 2
  rocket.grid = anim8.newGrid(78, 192, rocket.spriteSheet:getWidth(), rocket.spriteSheet:getHeight())
  rocket.animations = {}
  rocket.animations.idle = anim8.newAnimation(rocket.grid('1-2', 1), 0.1)
  rocket.isRocket = true;
end

function rocket:update(dt)
  if(self.exploding == false) then 
  self.x = self.x - math.cos(self.angle + math.rad(90)) * self.speed * dt
  self.y = self.y - math.sin(self.angle + math.rad(90)) * self.speed * dt
  self.animations.idle:update(dt)
  else 
    self.pSystem:update(dt) 
  end
end

function rocket:visualize()
   --love.graphics.circle("fill", rocket.x, rocket.y, 10)
  if(self.exploding == false) then self.animations.idle:draw(rocket.spriteSheet, self.x, self.y, self.angle, 0.4 * scale.scale(), 0.4 * scale.scale(), rocket.width, rocket.height)
  else  love.graphics.draw(self.pSystem) 
  end
  --love.graphics.draw(rocket.spriteSheet, rocket.x, rocket.y, rocket.angle, 1, 1, rocket.image:getWidth() / 2, rocket.image:getHeight() / 2)
end

return rocket