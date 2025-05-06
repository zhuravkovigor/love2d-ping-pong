local love = require("love")

local Player = {}
Player.__index = Player

function Player:new(side)
  local height = 100

  local player = setmetatable({}, Player)
  player.side = side -- Store the side so that it can be used later.
  player.y = love.graphics.getHeight() / 2 - height / 2
  player.speed = 200
  player.height = height
  player.width = 10

  if player.side == "left" then
    player.x = 0
  elseif player.side == "right" then
    player.x = love.graphics.getWidth() - player.width
  end

  return player
end

function Player:move(dt, keyDown, keyUp)
  if love.keyboard.isDown(keyDown) and self.y > 0 then
    self.y = self.y - self.speed * dt
  elseif love.keyboard.isDown(keyUp) and self.y + self.height < love.graphics.getHeight() then
    self.y = self.y + self.speed * dt
  end
end

function Player:reset()
  self.y = love.graphics.getHeight() / 2 - self.height / 2
end

--- param dt number: time elapsed since last update
function Player:update(dt, keyDown, keyUp)
  self:move(dt, keyDown, keyUp)
end

function Player:draw()
  if self.side == "left" then
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
  elseif self.side == "right" then
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
  end
end

return Player
