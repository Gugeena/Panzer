local ParticleGenerator = {};
ParticleGenerator.__index = ParticleGenerator;
local timer = require("timer");

function ParticleGenerator.newParticle(x, y, volume, scale)
    local newParticle = {};
    newParticle.Visual = love.graphics.newImage("assets/RocketEndParticle.png");
    newParticle.doneFor = false;
    newParticle.exploding = false;
    local currentscale = scale;
    newParticle.x = x;
    newParticle.y = y;
    newParticle.pSystem = love.graphics.newParticleSystem(newParticle.Visual, volume);
    newParticle.pSystem:setParticleLifetime(0.5, 0.7);
    newParticle.pSystem:setEmissionRate(0);
    newParticle.pSystem:setSpeed(100 * currentscale, 150 * currentscale);
    newParticle.pSystem:setDirection(0);
    newParticle.pSystem:setSpread(math.pi * 2);
    newParticle.pSystem:setLinearAcceleration(0, 0, 0, 0);
    newParticle.pSystem:setColors(1,1,1,1,
                        1,1,1,0);
    newParticle.pSystem:setPosition(x, y);
    newParticle.pSystem:setSizes(0.5 * currentscale, 0.4 * currentscale, 0);
    --timer.crt(0.9, function() 
    --    newParticle.exploding = true 
    --    newParticle.pSystem:setPosition(newParticle.x, newParticle.y)
    --    newParticle.pSystem:emit(50)
    --    timer.crt(0.8, function() 
    --    newParticle.doneFor = true 
    --    end);
    --   end);

    --table.insert(ParticleGenerator.Particles, newParticle.pSystem);
    return newParticle.pSystem;
end

function ParticleGenerator:update(rocket, x, y)
    --self.pSystem:update(dt) x
    --self.pSystem:setPosition(x, y);
    --love.graphics.draw(self.pSystem); 
    --self.pSystem:emit(50)
    --if (rocket.exploding == true) then love.graphics.draw(self.pSystem); self.pSystem:setPosition(x, y);  self.pSystem:emit(50) end
end

return ParticleGenerator;
