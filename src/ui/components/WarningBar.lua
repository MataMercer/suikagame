_G.WarningBar = {}
WarningBar.x = love.graphics.getWidth() / 2 + love.graphics.getWidth() / 2
WarningBar.y = 500
WarningBar.value = 1
WarningBar.speed = 0.001
WarningBar.active = false
WarningBar.width = 200
WarningBar.height = 20

function WarningBar:update(dt)
  if WarningBar.active then
    WarningBar.value = WarningBar.value - WarningBar.speed
  end
end

function WarningBar:draw()
  love.graphics.rectangle('fill', WarningBar.x, WarningBar.y, WarningBar.width, WarningBar.height)
end
