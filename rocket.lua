local rocket = {image, x, y, speed, angle, playerWidth, playerHeight, range, spriteSheet, grid, animations, particleEnd, pSystem, doneFor, rocketWidth, rocketHeight}
local anim8 = require("libraries/anim8")
local timer = require("timer")


function rocket.load(bool, x, y, angle, playerWidth, playerHeight, range)
  if(bool) 
  then 
    rocket.image = love.graphics.newImage("assets/rocketPlayer.png") 
    rocket.spriteSheet = love.graphics.newImage("assets/rocketFrames-Sheet.png")
    rocket.particleEnd = love.graphics.newImage("assets/RocketEndParticle.png")
    rocket.pSystem = love.graphics.newParticleSystem(rocket.particleEnd, 100)
  end
  rocket.x = x
  rocket.y = y
  rocket.angle = angle
  rocket.playerWidth = playerWidth
  rocket.playerHeight = playerHeight
  rocket.range = range
  rocket.speed = 350
  rocket.width = rocket.spriteSheet:getWidth() / 2
  rocket.height = rocket.spriteSheet:getHeight()
  rocket.grid = anim8.newGrid(78, 192, rocket.spriteSheet:getWidth(), rocket.spriteSheet:getHeight())
  rocket.animations = {}
  rocket.animations.idle = anim8.newAnimation(rocket.grid('1-2', 1), 0.1)
  rocket.pSystem:setParticleLifetime(0.5, 0.7)
  rocket.pSystem:setEmissionRate(0)
  rocket.pSystem:setSpeed(50, 100)
  rocket.pSystem:setDirection(0)
  rocket.pSystem:setSpread(math.pi * 2)
  rocket.pSystem:setLinearAcceleration(0, 0, 0, 0)
  rocket.pSystem:setColors(1,1,1,1,
                    1,1,1,0)
  rocket.pSystem:setPosition(rocket.x, rocket.y)
  rocket.pSystem:setSizes(0.5, 0.4, 0)
  rocket.doneFor = false
  timer.crt(0.9, function() 

    rocket.doneFor = true 
    rocket.pSystem:setPosition(rocket.x, rocket.y)
    rocket.pSystem:emit(50)

    end)
  --table.insert(0, rocket)
end

function rocket.update(dt)
  if(rocket.doneFor == false) then 
  rocket.x = rocket.x - math.cos(rocket.angle + math.rad(90)) * rocket.speed * dt
  rocket.y = rocket.y - math.sin(rocket.angle + math.rad(90)) * rocket.speed * dt
  rocket.animations.idle:update(dt)
  else 
    rocket.pSystem:update(dt)
  end
  --timer.update(dt)
end

function rocket.visualize()
   --love.graphics.circle("fill", rocket.x, rocket.y, 10)
  if(rocket.doneFor == false) then rocket.animations.idle:draw(rocket.spriteSheet, rocket.x, rocket.y, rocket.angle, 0.4, 0.4, rocket.width / 2, rocket.height / 2)
  else  love.graphics.draw(rocket.pSystem) 
  end
  --love.graphics.draw(rocket.spriteSheet, rocket.x, rocket.y, rocket.angle, 1, 1, rocket.image:getWidth() / 2, rocket.image:getHeight() / 2)
end

return rocket