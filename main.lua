local love = require("love")
local Player = require("src.game.player")
local Ball = require("src.game.ball")
local Typography = require("src.ui.typography")
local Timer = require("src.utils.timer")
local Border = require("src.ui.border")
local Constants = require("src.lib.constant")

local leftPlayer
local rightPlayer
local ball
local scoreLeftText
local scoreRightText
local timerText

local font
local timerFont
local ballSpeed = 200
local totalCollide = 0


local hitSoundEffect
local timeBeforeStart
local timerBeforeReset

local score = { left = 0, right = 0 }

local function onLeaveBall(side)
  timeBeforeStart:reset()
  timeBeforeStart:start()

  score[side] = score[side] + 1

  scoreLeftText:setText(score.left)
  scoreRightText:setText(score.right)

  totalCollide = 0

  ball:reset()
  leftPlayer:reset()
  rightPlayer:reset()
  ball:setSpeed(ballSpeed)
end

local function onPlayerBallHit()
  local clone = hitSoundEffect:clone()
  clone:stop()
  clone:play()

  totalCollide = totalCollide + 1
end

local function onWallHit()
  local clone = hitSoundEffect:clone()
  clone:stop()
  clone:play()
end


function love.load()
  font = love.graphics.newFont("assets/fonts/pixel.ttf", 44)
  timerFont = love.graphics.newFont("assets/fonts/pixel.ttf", 112)
  hitSoundEffect = love.audio.newSource("assets/sounds/hit.wav", "static")

  timeBeforeStart = Timer.createTimer(Constants.TIMER_GAME_START)

  leftPlayer = Player:new("left")
  rightPlayer = Player:new("right")
  ball = Ball:new(ballSpeed)
  scoreLeftText = Typography:new(score.left, font)
  scoreRightText = Typography:new(score.right, font)

  timerText = Typography:new(timeBeforeStart:getTime(), timerFont)

  timerText:setPosition(
    (love.graphics.getWidth() - timerFont:getWidth(timeBeforeStart:getTime())) / 2,
    (love.graphics.getHeight() - timerFont:getHeight()) / 2
  )
  scoreLeftText:setPosition(
    (love.graphics.getWidth() - font:getWidth(score.left)) / 2 - Constants.TEXT_SCORE_OFFSET, 50
  )
  scoreRightText:setPosition(
    (love.graphics.getWidth() - font:getWidth(score.right)) / 2 + Constants.TEXT_SCORE_OFFSET, 50
  )

  timeBeforeStart:start()
end

function love.update(dt)
  if timeBeforeStart:isFinished() then
    leftPlayer:update(dt, "w", "s")
    rightPlayer:update(dt, "up", "down")
    ball:update(dt, leftPlayer, rightPlayer, onLeaveBall, onPlayerBallHit, onWallHit)
  end

  if timeBeforeStart:isRunning() then
    timerText:setText(timeBeforeStart:getTime())
  end

  if totalCollide > 0 then
    local speedIncreaseFactor = 0.05 -- Adjust this value to control the speed increase rate
    ball:setSpeed(ballSpeed + (totalCollide * speedIncreaseFactor * ballSpeed))
  end

  timeBeforeStart:update(dt)
end

function love.draw()
  love.graphics.setFont(font)


  love.graphics.setColor(0.4, 0.4, 0.4)
  leftPlayer:draw()
  rightPlayer:draw()

  if timeBeforeStart:isFinished() then
    Border.drawVerticalDashedLine(love.graphics.getWidth() / 2, 0, love.graphics.getHeight(), 10, 5)
  end

  love.graphics.setColor(1, 1, 1)


  if timeBeforeStart:isFinished() then
    ball:draw()
  end

  if timeBeforeStart:isRunning() then
    timerText:draw()
  end

  scoreLeftText:draw()
  scoreRightText:draw()
end
