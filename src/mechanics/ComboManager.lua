_G.ComboManager = {
  methods = {}
}

function ComboManager:new()
  local o = {
    combos = {},
    comboTimeElapsed = 0,
    comboTimeLimit = 2,
    spriteGrid = anim8.newGrid(64, 64, sprites.comboEffect:getWidth(), sprites.comboEffect:getHeight()),

  }
  SetMethods(self, o)
  return o
end

function ComboManager.methods:check(x, y)
  if self.comboTimeElapsed <= self.comboTimeLimit then
    local c = {
      x = x,
      y = y,
      alpha = 255,
      animation = anim8.newAnimation(self.spriteGrid('1-3', 1), 0.1, 'pauseAtEnd')
    }

    flux.to(c, 1, { alpha = 1 }):delay(0.4)
    table.insert(self.combos, c)
    return true
  else
    self.combos = {}
    self.comboTimeElapsed = 0
    return false
  end
end

function ComboManager.methods:update(dt)
  self.comboTimeElapsed = self.comboTimeElapsed + dt
  for index, c in ipairs(self.combos) do
    c.animation:update(dt)
  end
end

function ComboManager.methods:draw()
  for index, c in ipairs(self.combos) do
    LgUtil.resetColor()
    LgUtil.setColor(255, 255, 255, c.alpha)
    love.graphics.setFont(Fonts.proggySquare, 0.1)
    local scale = math.pow(index / 2, 1 / 3)
    c.animation:draw(sprites.comboEffect, c.x - 40, c.y - 40, nil, scale * 1.5)
    love.graphics.print(string.format("%d COMBO", index), c.x, c.y, 0, scale, scale)
  end
end

function ComboManager.methods:destroy()
  combos = {}
  comboTimeElapsed = 0
end
