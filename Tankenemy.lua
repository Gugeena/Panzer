    local tankEnemy = {x = 0, y = 0, speed = 160, enemyWidth = 0, enemyHeight = 0, limitX = 0, limitY = 0, bottomImage, topImage, angle = 0, bodyAngle = 0, TopWidth = 0, TopHeight = 0, topRotation = 0, topImageFALSE, canMove = false, canAttack = true, infunction = false,
    dead = false};
    tankEnemy.__index = tankEnemy;
    local scale = require("scaling");
    local timer = require("timer");
    local rocket = require("rocket");
    local rockets = {};
    local ParticleGenerator = require("ParticleGenerator");
    local player = require("player");

    function tankEnemy.load(r)
        tankEnemy.bottomImage = love.graphics.newImage("assets/ENEMYTankBottom.png")
        tankEnemy.topImage = love.graphics.newImage("assets/ENEMYTankTop.png")
        tankEnemy.topImageFALSE  = love.graphics.newImage("assets/ENEMYTankTopCS.png")

        tankEnemy.enemyWidth = tankEnemy.bottomImage:getWidth()
        tankEnemy.enemyHeight = tankEnemy.bottomImage:getHeight()

        tankEnemy.TopWidth = tankEnemy.topImage:getWidth()
        tankEnemy.TopHeight = tankEnemy.topImage:getHeight()
        rockets = r;
    end
        
    function tankEnemy.createNewTank(x,y)
        local newEnemy = setmetatable({}, tankEnemy);
        newEnemy.hp = 100;
        newEnemy.x = x;
        newEnemy.y = y;
        newEnemy.angle = 0;
        newEnemy.bodyAngle = 0;
        newEnemy.canMove = false;
        newEnemy.canAttack = true
        newEnemy.dead = false
        newEnemy.deathParticles = ParticleGenerator.newParticle(x, y, 400, scale.scale())
        timer.crt(0.9, function() 

                newEnemy.canMove = true;

        end)
        return newEnemy;
    end

    function tankEnemy:lookAtPlayer(x, y)
        local deltaX, deltaY = self:ToPlayer(x, y);

        self.topRotation = math.atan2(deltaY, deltaX) + math.rad(90);
    end

    function tankEnemy:lookAtPlayerBody(x, y, dt)
        if(self.canMove == true) then
        local distanceX, distanceY, distance = self:calculateDistance(x, y);
        if(distance > 300) then
        local deltaX, deltaY = self:ToPlayer(x, y);
        local targetAngle = math.atan2(deltaY,deltaX) + math.rad(90);
        local diff = math.atan2(math.sin(targetAngle - self.angle), math.cos(targetAngle - self.angle))

        if(diff > 0) then self.angle = self.angle + 1 * dt 
        else if (diff < 0) then self.angle = self.angle - 1 * dt end;
        end
    end
    end
    end 

    function tankEnemy:ToPlayer(x, y)
        return x - self.x, y - self.y;
    end

    function tankEnemy:update(playerX, playerY, dt)
        if(self.dead == false) then
            self:lookAtPlayer(playerX, playerY);
            self:lookAtPlayerBody(playerX, playerY, dt);
            self:goToPlayer(playerX, playerY, dt)
        else
            self.deathParticles:update(dt);
     end
    end

    function tankEnemy:visualize()
        if(self.dead == false) then 
        local scaleAdj = 0.5 * scale.scale();
        love.graphics.draw(tankEnemy.bottomImage, self.x, self.y, self.angle, scaleAdj, scaleAdj, tankEnemy.enemyWidth / 2, tankEnemy.enemyHeight / 2)
        local localTop = tankEnemy.topImage;
        if(self.canAttack == false or self.moving == true) then localTop = tankEnemy.topImageFALSE end
        love.graphics.draw(localTop, self.x, self.y, self.topRotation, scaleAdj, scaleAdj, tankEnemy.TopWidth / 2, tankEnemy.TopHeight / 2 + 12)
        else 
        love.graphics.draw(self.deathParticles);
        end
    end

    function tankEnemy:goToPlayer(x, y, dt)
        self.moving = true;
        local distanceX, distanceY, distance = self:calculateDistance(x, y);
        if(distance > 300 and self.canMove == true) then
            if(self:isPointingAt(x, y)) then
            self.x = self.x + (distanceX / distance) * tankEnemy.speed * dt;
            self.y = self.y + (distanceY / distance) * tankEnemy.speed * dt;
            end
        else if (distance <= 300 and self.canAttack) then
            self.canMove = false;
            self.moving = false;
            self:attack();
    end
    end
    end

    function tankEnemy:attack()
        if(self.infunction == true) then return end;
        self.infunction = true;
        timer.crt(0.2, function ()
            if(player.dead == true or self.dead == true) then return end;
            self.canAttack = false;
        local offset = 86 * scale.scale();
        local spawnX = self.x - math.cos(self.topRotation + math.rad(90)) * offset
        local spawnY = self.y - math.sin(self.topRotation + math.rad(90)) * offset
        local r = rocket.newRocket(spawnX, spawnY, self.topRotation, true);
        table.insert(rockets, r);
        timer.crt(1.5, function () 
            self.canMove = true;
            self.canAttack = true;    
            self.infunction = false;
        end)
        end)
    end

    function tankEnemy:isPointingAt(x, y)
        local toPlayerX = x - self.x;
        local toPlayerY = y - self.y;

        local directionX, directionY = normalize(toPlayerX, toPlayerY, 0);

        local bodyDirectionX = math.cos(self.angle - math.rad(90));
        local bodyDirectionY = math.sin(self.angle - math.rad(90));

        local dot = directionX * bodyDirectionX + directionY * bodyDirectionY;

        return dot > 0.8;
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

    function tankEnemy:death()
        if(self.dead == true) then return; end
        self.dead = true;
        self.deathParticles:setPosition(self.x, self.y);
        self.deathParticles:emit(100);
    end

    return tankEnemy;