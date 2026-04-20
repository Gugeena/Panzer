local enemyGenerator = {}
local timer = require("timer");
local bounds = require("bounds");
local wait = 2;
local time = 0;

function enemyGenerator.generate(enemy, enemies, dt, player, boundsX, boundsY, spacing)
    time = time + dt;

    if(time >= wait) then
        local startX, endX, startY, endY = bounds.bounds(player, boundsX, boundsY, spacing);
        local side = math.random(0,1)
        local x;
        local y;
        if(side == 0) then
            local isNegative = math.random(0,1)
            local offSet = math.random(50,100)
            if(isNegative == 0) then
                x = startX - offSet;
            else
                x = endX + offSet;
            end
            y = math.random(startY, endY)
        else
            local isNegative = math.random(0,1)
            local offSet = math.random(50,100)
            if(isNegative == 0) then
                y = startY - offSet;
            else
                y = endY + offSet;
            end
            x = math.random(startX, endX)
        end
        local enemy = enemy.createNewTank(x,y)
        table.insert(enemies, enemy);

        time = 0;
    end
end

return enemyGenerator;