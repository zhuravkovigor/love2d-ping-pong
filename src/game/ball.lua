local love = require("love")

local Ball = {}
Ball.__index = Ball

local function resolveCollision(ball, player)
  local ballNextX = ball.x + ball.speedX * love.timer.getDelta()
  local ballNextY = ball.y + ball.speedY * love.timer.getDelta()

  local closestX = math.max(player.x, math.min(ballNextX, player.x + player.width))
  local closestY = math.max(player.y, math.min(ballNextY, player.y + player.height))

  local dx = ballNextX - closestX
  local dy = ballNextY - closestY

  -- Если dx > dy, это боковое столкновение
  if math.abs(dx) > math.abs(dy) then
    ball.speedX = -ball.speedX
    -- отталкиваем в зависимости от стороны
    if ball.x < player.x then
      ball.x = player.x - ball.size
    else
      ball.x = player.x + player.width + ball.size
    end
  else
    ball.speedY = -ball.speedY
    if ball.y < player.y then
      ball.y = player.y - ball.size
    else
      ball.y = player.y + player.height + ball.size
    end
  end
end

function Ball:new(speed)
  local ball = setmetatable({}, Ball)

  local size = 15

  ball.x = love.graphics.getWidth() / 2
  ball.y = love.graphics.getHeight() / 2
  ball.size = size
  ball.speedX = speed or 200
  ball.speedY = speed or 200

  return ball
end

local function circleRectCollision(cx, cy, radius, rx, ry, rw, rh)
  local closestX = math.max(rx, math.min(cx, rx + rw))
  local closestY = math.max(ry, math.min(cy, ry + rh))

  local dx = cx - closestX
  local dy = cy - closestY

  return (dx * dx + dy * dy) < (radius * radius)
end

function Ball:collide(player)
  local safeSpace = player.width - self.size / 2

  local radius = self.size / 2

  return circleRectCollision(
    self.x, self.y, radius,
    player.x - safeSpace, player.y, player.width + safeSpace, player.height
  )
end

function Ball:reset()
  self.scored = false

  local directionX = love.math.random(0, 1) == 0 and -1 or 1
  local directionY = love.math.random(0, 1) == 0 and -1 or 1

  self.x = love.graphics.getWidth() / 2 - self.size / 2
  self.y = love.graphics.getHeight() / 2 - self.size / 2
  self.speedX = directionX * math.abs(self.speedX)
  self.speedY = directionY * math.abs(self.speedY)
end

function Ball:setSpeed(speed)
  local dirX = self.speedX >= 0 and 1 or -1
  local dirY = self.speedY >= 0 and 1 or -1
  self.speedX = dirX * speed
  self.speedY = dirY * speed
end

function Ball:update(dt, leftPlayer, rightPlayer, onLeave, onPlayerHit, onWallHit)
  self.x = self.x + self.speedX * dt
  self.y = self.y + self.speedY * dt

  if not self.scored and (self.x < 0 or self.x > love.graphics.getWidth() - self.size) then
    self.scored = true
    if self.x < 0 then
      onLeave("right")
    else
      onLeave("left")
    end
  end

  if self:collide(leftPlayer) or self:collide(rightPlayer) then
    if self:collide(leftPlayer) then
      onPlayerHit()
      resolveCollision(self, leftPlayer)
    elseif self:collide(rightPlayer) then
      onPlayerHit()
      resolveCollision(self, rightPlayer)
    end
  end

  if self.y - (self.size) < 0 or self.y > love.graphics.getHeight() - self.size then
    onWallHit()
    self.speedY = -self.speedY
  end
end

function Ball:draw()
  love.graphics.circle("fill", self.x, self.y, self.size) -- Draw as a circle
end

return Ball
