local tankEnemy = {x = 0, y = 0, speed = 200, enemyWidth = 0, enemyHeight = 0, limitX = 0, limitY = 0, bottomImage, topImage, angle = 0, bodyAngle = 0, TopWidth = 0, TopHeight = 0, topRotation = 0, topImageFALSE};

tankEnemy.__index = tankEnemy;

local scale = require("scaling");

function tankEnemy.load()
    tankEnemy.bottomImage = love.graphics.newImage("assets/ENEMYTankBottom.png")
    tankEnemy.topImage = love.graphics.newImage("assets/ENEMYTankTop.png")

    tankEnemy.enemyWidth = tankEnemy.bottomImage:getWidth()
    tankEnemy.enemyHeight = tankEnemy.bottomImage:getHeight()

    tankEnemy.TopWidth = tankEnemy.topImage:getWidth()
    tankEnemy.TopHeight = tankEnemy.topImage:getHeight()
end
    
function tankEnemy.createNewTank(x,y)
    local newEnemy = setmetatable({}, tankEnemy);
    newEnemy.hp = 100;
    newEnemy.x = x;
    newEnemy.y = y;
    newEnemy.angle = 0;
    newEnemy.bodyAngle = 0;
    return newEnemy;
end

function tankEnemy:lookAtPlayer(x, y)
    local deltaX, deltaY = self:ToPlayer(x, y);

    self.topRotation = math.atan2(deltaY, deltaX) + math.rad(90);
end

function tankEnemy:lookAtPlayerBody(x, y, dt)
    local distanceX, distanceY, distance = tankEnemy:calculateDistance(x, y);
    if(distance > 300) then
    local deltaX, deltaY = self:ToPlayer(x, y);
    local targetAngle = math.atan2(deltaY,deltaX) + math.rad(90);
    local diff = math.atan2(math.sin(targetAngle - self.angle), math.cos(targetAngle - self.angle))

    if(diff > 0) then self.angle = self.angle + 1 * dt 
    else if (diff < 0) then self.angle = self.angle - 1 * dt end;
    end
end
end

function tankEnemy:ToPlayer(x, y)
    return x - self.x, y - self.y;
end

function tankEnemy:update(playerX, playerY, dt)
    self:lookAtPlayer(playerX, playerY);
    self:visualize();
    self:lookAtPlayerBody(playerX, playerY, dt);
    self:goToPlayer(playerX, playerY, dt)
end

function tankEnemy:visualize()
    local scaleAdj = 0.5 * scale.scale();
    love.graphics.draw(tankEnemy.bottomImage, self.x, self.y, self.angle, scaleAdj, scaleAdj, tankEnemy.enemyWidth / 2, tankEnemy.enemyHeight / 2)
    local localTop = tankEnemy.topImage;
    love.graphics.draw(localTop, self.x, self.y, self.topRotation, scaleAdj, scaleAdj, tankEnemy.TopWidth / 2, tankEnemy.TopHeight / 2 + 12)
end

function tankEnemy:goToPlayer(x, y, dt)
    if(self:isPointingAt(x, y)) then
        
    local distanceX, distanceY, distance = tankEnemy:calculateDistance(x, y);

    if(distance > 300) then
        self.x = self.x + (distanceX / distance) * tankEnemy.speed * dt;
        self.y = self.y + (distanceY / distance) * tankEnemy.speed * dt;
    end
    end
end

function tankEnemy:isPointingAt(x, y)
    local toPlayerX = x - self.x;
    local toPlayerY = y - self.y;

    local directionX, directionY = normalize(toPlayerX, toPlayerY, 0);

    local bodyDirectionX = math.cos(self.angle - math.rad(90));
    local bodyDirectionY = math.sin(self.angle - math.rad(90));

    local dot = directionX * bodyDirectionX + directionY * bodyDirectionY;

    return dot > 0.95;
end

function tankEnemy:calculateDistance(x, y)
    local distanceX = x - self.x;
    local distanceY = y - self.y;
    local distance = math.sqrt(distanceX * distanceX + distanceY * distanceY)
    return distanceX, distanceY, distance;
end

function normalize(x, y)
    local length = math.sqrt(x*x + y*y);
    if(length == 0) then return 0, 0 end;
    return x/length, y/length;
end

return tankEnemy;