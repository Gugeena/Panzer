-- TODO: FIX TS

local enemyGenerator = {}
local timer = require("timer");
local main = require("main");

function enemyGenerator.generate(enemy, time, enemies)
    while(true) do
    timer.crt(time, function ()
        local startX, endX, startY, endY = main.bounds();
        local num = math.random(0, 1);
        local x;
        local y;
        x = num > 0 and endX + math.random(10, 15) or startX - math.random(10, 15);
        num = math.random(0, 1);
        y = num > 0 and endY + math.random(10, 15) or startY - math.random(10, 15);
        local enemy = enemy.createNewTank(x,y)
        table.insert(enemies, enemy);
    end)
end
end

return enemyGenerator;