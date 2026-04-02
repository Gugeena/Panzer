local rocket = {image, x, y, speed, angle, playerWidth, playerHeight, range, spriteSheet, grid, animations, particleEnd, pSystem, doneFor, rocketWidth, rocketHeight, exploding}
local anim8 = require("libraries/anim8")
local timer = require("timer")
local scale = require("scaling")
rocket.__index = rocket;
--local screen = require("screenTesting")

function rocket.newRocket(x, y, angle)
  local newRocket = setmetatable({}, rocket)
  newRocket.x = x;
  newRocket.y = y;
  newRocket.angle = angle;
  newRocket.spriteSheet = rocket.spriteSheet;
  newRocket.doneFor = false;
  newRocket.exploding = false;
  newRocket.pSystem = love.graphics.newParticleSystem(rocket.particleEnd, 100)
  newRocket.pSystem:setParticleLifetime(0.5, 0.7)
  newRocket.pSystem:setEmissionRate(0)
  newRocket.pSystem:setSpeed(100 * scale.scale(), 150 * scale.scale())
  newRocket.pSystem:setDirection(0)
  newRocket.pSystem:setSpread(math.pi * 2)
  newRocket.pSystem:setLinearAcceleration(0, 0, 0, 0)
  newRocket.pSystem:setColors(1,1,1,1,
                    1,1,1,0)
  newRocket.pSystem:setPosition(x, y)
  newRocket.pSystem:setSizes(0.5 * scale.scale(), 0.4 * scale.scale(), 0)

  timer.crt(0.9, function() 
    newRocket.exploding = true 
    newRocket.pSystem:setPosition(newRocket.x, newRocket.y)
    newRocket.pSystem:emit(50)
     timer.crt(0.8, function() 
     newRocket.doneFor = true 
    end)
    end)
  return newRocket;
end
  
function rocket.load(playerWidth, playerHeight, range, speed)
  rocket.image = love.graphics.newImage("assets/rocketPlayer.png") 
  rocket.particleEnd = love.graphics.newImage("assets/RocketEndParticle.png")
  rocket.playerWidth = playerWidth
  rocket.playerHeight = playerHeight
  rocket.range = range
  rocket.speed = speed
  rocket.spriteSheet = love.graphics.newImage("assets/rocketFrames-Sheet.png")
  rocket.width = rocket.spriteSheet:getWidth() / 2 
  rocket.height = rocket.spriteSheet:getHeight()
  rocket.grid = anim8.newGrid(78, 192, rocket.spriteSheet:getWidth(), rocket.spriteSheet:getHeight())
  rocket.animations = {}
  rocket.animations.idle = anim8.newAnimation(rocket.grid('1-2', 1), 0.1)
end

function rocket:update(dt)
  if(self.exploding == false) then 
  self.x = self.x - math.cos(self.angle + math.rad(90)) * self.speed * dt
  self.y = self.y - math.sin(self.angle + math.rad(90)) * self.speed * dt
  self.animations.idle:update(dt)
  else 
    self.pSystem:update(dt) 
  end
  --timer.update(dt)
end

function rocket:visualize()
   --love.graphics.circle("fill", rocket.x, rocket.y, 10)
  if(self.exploding == false) then self.animations.idle:draw(rocket.spriteSheet, self.x, self.y, self.angle, 0.4 * scale.scale(), 0.4 * scale.scale(), rocket.width / 2, rocket.height / 2)
  else  love.graphics.draw(self.pSystem) 
  end
  --love.graphics.draw(rocket.spriteSheet, rocket.x, rocket.y, rocket.angle, 1, 1, rocket.image:getWidth() / 2, rocket.image:getHeight() / 2)
end

return rocket