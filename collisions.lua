local collisions = {};

function collisions.collisions(rockets, player, dt, scale, Particles, enemies)
    for i = #rockets, 1, -1 do
    rockets[i]:update(dt);
    --if (rockets[i].exploding == true and rockets[i].doneFor == false) then Particles[i]:update(rockets[i], rockets[i].x, rockets[i].y);
    if (rockets[i].doneFor == true) then
        table.remove(rockets, i); --table.remove(Particles, i);
    else
    local localX, localY = findLocalPositionsTyvnaTvinisSirobaaMagari(player.angle, rockets[i].x, rockets[i].y, player.x, player.y);
    local scaleFactor = 0.5 * scale;
    local width,height = (player.playerWidth / 2) * scaleFactor, (player.playerHeight / 2) * scaleFactor;
    if localX >= -width and localX <= width and localY >= -height and localY <= height then
      table.remove(rockets, i); 
      player:death();
    end

    
    for i = #enemies, 1, -1 do
    enemies[i]:update(dt);
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