local love = require("love")

local Typography = {}
Typography.__index = Typography

function Typography:new(text, font, x, y)
  local typography = setmetatable({}, Typography)
  typography.text = text or ""
  typography.font = font -- уже готовый Font-объект
  typography.x = x or 0
  typography.y = y or 0
  return typography
end

function Typography:setText(text)
  self.text = text
end

function Typography:setFont(font)
  self.font = font -- просто установить, без newFont
end

function Typography:setPosition(x, y)
  self.x = x
  self.y = y
end

function Typography:draw()
  love.graphics.setFont(self.font)
  love.graphics.print(self.text, self.x, self.y)
end

return Typography
