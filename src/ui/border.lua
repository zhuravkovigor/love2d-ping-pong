local love = require("love")

local function drawVerticalDashedLine(x, y1, y2, dashLength, gapLength)
  dashLength = dashLength or 5
  gapLength = gapLength or 5

  local y = y1
  while y < y2 do
    local yEnd = math.min(y + dashLength, y2)
    love.graphics.line(x, y, x, yEnd)
    y = yEnd + gapLength
  end
end

return {
  drawVerticalDashedLine = drawVerticalDashedLine
}
