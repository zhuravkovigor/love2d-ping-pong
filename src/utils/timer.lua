local function createTimer(duration)
  local timer = {
    duration = duration,
    elapsed = 0,
    started = false,
    finished = false,
  }

  function timer:start()
    self.started = true
    self.finished = false
    self.elapsed = 0
  end

  function timer:getTime()
    return math.floor(math.max(0, self.duration - self.elapsed))
  end

  function timer:isRunning()
    return self.started and not self.finished
  end

  function timer:update(dt)
    if self.started then
      self.elapsed = self.elapsed + dt
      if self.elapsed >= self.duration then
        self.finished = true
        self.started = false
      end
    end
  end

  function timer:isFinished()
    return self.finished
  end

  function timer:reset()
    self.started = false
    self.finished = false
    self.elapsed = 0
  end

  return timer
end

return {
  createTimer = createTimer,
}
