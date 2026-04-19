local bounds = {};

function bounds.bounds(player, boundsX, boundsY, spacing)
  local endOffset = 26;

  local startX = math.floor((player.x - boundsX) / spacing) * spacing
  local startY = math.floor((player.y - boundsY) / spacing) * spacing

  local endX  = (math.floor((player.x + boundsX) / spacing) * spacing)  + endOffset
  local endY  = (math.floor((player.y + boundsY) / spacing) * spacing)  + endOffset

  return startX, endX, startY, endY;
end

return bounds;