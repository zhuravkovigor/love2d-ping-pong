local love = require("love")

--- @param t table
function love.conf(t)
  t.title = "Pong game"
  t.version = "11.5"
  t.console = true
end
