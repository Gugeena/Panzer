local collisions = {};
local AudioManager = require("AudioManager");

function collisions.collisions(rockets, player, dt, scale, enemies)
    for i = #rockets, 1, -1 do
    rockets[i]:update(dt);
    --if (rockets[i].exploding == true and rockets[i].doneFor == false) then Particles[i]:update(rockets[i], rockets[i].x, rockets[i].y);
    if (rockets[i].doneFor == true) then
      rockets[i].exploded = true;
      table.remove(rockets, i); --table.remove(Particles, i);
    else
    local localX, localY = findLocalPositionsTyvnaTvinisSirobaaMagari(player.angle, rockets[i].x, rockets[i].y, player.x, player.y);
    local scaleFactor = 0.5 * scale;
    local width,height = (player.playerWidth / 2) * scaleFactor, (player.playerHeight / 2) * scaleFactor;
    if localX >= -width and localX <= width and localY >= -height and localY <= height and not player.dead then
      rockets[i].exploded = true;
      table.remove(rockets, i); 
      player:death();
      return;
    end
   
    for j = #enemies, 1, -1 do
      local enemy = enemies[j];
      local eX, eY = findLocalPositionsTyvnaTvinisSirobaaMagari(enemy.angle, rockets[i].x, rockets[i].y, enemy.x, enemy.y);
      local ewidth,eheight = (enemy.enemyWidth / 2) * scaleFactor, (enemy.enemyHeight / 2) * scaleFactor;
      if eX >= -width and eX <= width and eY >= -height and eY <= height then
      rockets[i].exploded = true;
      table.remove(rockets, i); 
      enemy:death();
      player:incriment();
      break;
    end
  end
  end
end
end


function findLocalPositionsTyvnaTvinisSirobaaMagari(angle, x, y, px, py)
  local dx = x - px;
  local dy = y - py;

  local rad = math.rad(angle);
  local cos = math.cos(rad);
  local sin = math.sin(rad);

  local localX = dx * cos + dy * sin;
  local localY = dy * cos - dx * sin;

  return localX, localY;
end


return collisions;