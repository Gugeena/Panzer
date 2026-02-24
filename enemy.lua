local Enemy = {}

function Enemy.new(hp, x, y, angle, speed, width, height)
  local newEnemy = setmetatable({}, {__index = Enemy})
  newEnemy.hp = hp
  newEnemy.x = x
  newEnemy.y = y
  newEnemy.angle = angle
  newEnemy.speed = speed
  newEnemy.width = width
  newEnemy.height = height
  newEnemy.canShoot = true
  newEnemy.SRange = 200
  newEnemy.distance = 0
  return newEnemy
end

return Enemy