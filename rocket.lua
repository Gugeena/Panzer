local rocket = {image, x, y, speed, angle, playerWidth, playerHeight, range, spriteSheet, grid, animations}
local anim8 = require("libraries/anim8")
local timer = require("timer")

function rocket.load(bool, x, y, angle, playerWidth, playerHeight, range)
  if(bool) 
  then 
    rocket.image = love.graphics.newImage("assets/rocketPlayer.png") 
    rocket.spriteSheet = love.graphics.newImage("assets/rocketFrames-Sheet.png")
  end
  rocket.x = x
  rocket.y = y
  rocket.angle = angle
  rocket.playerWidth = playerWidth
  rocket.playerHeight = playerHeight
  rocket.range = range
  rocket.speed = 350
  rocket.grid = anim8.newGrid(78, 192, rocket.spriteSheet:getWidth(), rocket.spriteSheet:getHeight())
  rocket.animations = {}
  rocket.animations.idle = anim8.newAnimation(rocket.grid('1-2', 1), 0.1)
  timer.crt(2, function() print("Rocket timer fired!") end)
  --table.insert(0, rocket)
end

function rocket.update(dt)
  rocket.x = rocket.x - math.cos(rocket.angle + math.rad(90)) * rocket.speed * dt
  rocket.y = rocket.y - math.sin(rocket.angle + math.rad(90)) * rocket.speed * dt
  rocket.animations.idle:update(dt)
  timer.update(dt)
end

function rocket.visualize()
   --love.graphics.circle("fill", rocket.x, rocket.y, 10)
  rocket.animations.idle:draw(rocket.spriteSheet, rocket.x, rocket.y, rocket.angle, 0.4, 0.4, 78 / 2, 192 / 2)
  --love.graphics.draw(rocket.spriteSheet, rocket.x, rocket.y, rocket.angle, 1, 1, rocket.image:getWidth() / 2, rocket.image:getHeight() / 2)
end

return rocket