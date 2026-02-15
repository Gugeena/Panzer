--local player = { x = 100, y = 100, speed = 200, playerWidth = 50, playerHeight = 50 }
local decleration = "I love you"
local player = { x = 100, y = 100, speed = 200, playerWidth = 0, playerHeight = 0, limitX = 0, limitY = 0, bottomImage, topImage, angle = 0, bodyAngle = 0, TopWidth = 0, TopHeight = 0, RspawnX = 0, RspawnY = 0, topRotation = 0 } 
local spacing = 32;
local camera = require("libraries/camera")
local rocket = require("rocket")
local shot, canshoot = false, true;
local rockets = {}


function player.loadInformation()
  player.bottomImage = love.graphics.newImage("assets/TankBottom.png")
  player.topImage = love.graphics.newImage("assets/TankTop.png")
  player.playerWidth = player.bottomImage:getWidth()
  player.playerHeight = player.bottomImage:getHeight()
  player.limitX = 10000000
  player.limitY = 10000000
  player.TopWidth = player.topImage:getWidth()
  player.TopHeight = player.topImage:getHeight()
  camera = camera();
  player.RspawnX = player.x;
  player.RspawnY= player.y - 85;
  love.graphics.setLineWidth(2)
end

function player.move(dt)
  Movement(dt)
end

function Movement(dt)
  if love.keyboard.isDown("d") or love.keyboard.isDown("right")  then   
    player.angle = player.angle + 1 * dt
  end

  if love.keyboard.isDown("a") or love.keyboard.isDown("left")  then   
    player.angle = player.angle - 1 * dt
  end

  if love.keyboard.isDown("w") or love.keyboard.isDown("up")  then   
    --player.x = player.x - math.cos(player.angle + math.rad(90)) * player.speed * dt
    --player.y = player.y - math.sin(player.angle + math.rad(90)) * player.speed * dt
    local xChange = math.cos(player.angle + math.rad(90)) * player.speed * dt
    local yChange = math.sin(player.angle + math.rad(90)) * player.speed * dt
    player.x = player.x - xChange
    player.y = player.y - yChange
    player.RspawnX = player.RspawnX - xChange
    player.RspawnY = player.RspawnY - yChange
  end


  if(love.mouse.isDown(1) and canshoot) then
    local offset = 86;
    local spawnX = player.x - math.cos(player.topRotation + math.rad(90)) * offset
    local spawnY = player.y - math.sin(player.topRotation + math.rad(90)) * offset
    rocket.load(true, spawnX, spawnY , player.topRotation, player.playerWidth, player.playerHeight, 1000)
    shot = true;
    canshoot = false;
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

end

function rotateToMouse()
  local mouseX, mouseY = camera:worldCoords(love.mouse.getX(), love.mouse.getY())
  --local mouseY = camera:worldCoords(love.mouse.getY())

  --local centerX = player.x + player.playerWidth / 2
  --local centerY = player.y + player.playerHeight / 2

  local deltaX = mouseX - player.x
  local deltaY = mouseY - player.y
  --player.angle = math.atan2(deltaY, deltaX)
  player.topRotation = math.atan2(deltaY, deltaX) + math.rad(90)
end

function player.visualize()
  camera:attach()
  love.graphics.setColor(0.5, 0, 1)

  local startX = math.floor((player.x - love.graphics.getWidth() / 2) / spacing) * spacing
  local startY = math.floor((player.y - love.graphics.getHeight() / 2) / spacing) * spacing

  local endX  = (math.floor((player.x + love.graphics.getWidth() / 2) / spacing) * spacing)  + 26
  local endY  = (math.floor((player.y + love.graphics.getHeight() / 2) / spacing) * spacing)  + 26

  for x = startX, endX, spacing 
  do
    love.graphics.line(x, startY, x, endY)
  end

  for y = startY, endY, spacing
  do
    love.graphics.line(startX, y, endX, y)
  end

  love.graphics.setColor(1, 1, 1)
  --love.graphics.setColor(0, 1, 0) 
  love.graphics.draw(player.bottomImage, player.x, player.y, player.angle, 0.5, 0.5, player.playerWidth / 2, player.playerHeight / 2)
  rotateToMouse()
  love.graphics.draw(player.topImage, player.x, player.y, player.topRotation, 0.5, 0.5, player.TopWidth / 2, (player.TopHeight / 2) + 12)
  camera:lookAt(player.x, player.y)


  -- aint working

  if(shot) then
   rocket.update(love.timer.getDelta())
   rocket.visualize()
  end

  camera:detach()
end

return player