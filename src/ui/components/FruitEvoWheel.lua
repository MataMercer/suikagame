_G.FruitEvoWheel = {}

FruitEvoWheel.x = love.graphics.getWidth() / 2 + love.graphics.getWidth() / 4
FruitEvoWheel.y = 500
FruitEvoWheel.scale = 0.7
FruitEvoWheel.radius = 100 * FruitEvoWheel.scale
FruitEvoWheel.rotationAngleIncrement = 2 * math.pi / #FruitTypes
FruitEvoWheel.index = 1
FruitEvoWheel.fruitCount = #FruitTypes
FruitEvoWheel.rotationOffset = 8 * FruitEvoWheel.rotationAngleIncrement
FruitEvoWheel.rotation = FruitEvoWheel.rotationOffset

local function getPointsOnCircle(radius, numPoints, centerX, centerY, rotation)
  local points = {}
  local angleIncrement = 2 * math.pi / numPoints

  for i = 1, numPoints do
    local angle = i * angleIncrement + rotation
    local x = radius * math.cos(angle) + centerX
    local y = radius * math.sin(angle) + centerY
    table.insert(points, { x = x, y = y })
  end

  return points
end

local function findRotationToIndex(targetIndex)
  return FruitEvoWheel.rotationAngleIncrement * (FruitEvoWheel.index - targetIndex)
end

function FruitEvoWheel:rotate(index)
  flux.to(FruitEvoWheel, 1, { rotation = findRotationToIndex(index) + self.rotationOffset }):delay(0)
end

function FruitEvoWheel:update(dt)
  FruitEvoWheel.points = getPointsOnCircle(FruitEvoWheel.radius, #FruitTypes, FruitEvoWheel.x, FruitEvoWheel.y,
    self.rotation)
end

function drawEvoWheelLabel(x, y, fruitType)
  local labelText = string.format("Next:" .. firstToUpper(fruitType.name))
  local labelTextScale = 0.5
  local labelPadding = 10
  love.graphics.setFont(Fonts.proggySquare, 0.1)
  local fontWidth = love.graphics.getFont():getWidth(labelText)
  local fontHeight = love.graphics.getFont():getHeight(labelText)
  local labelWidth = fontWidth * labelTextScale + labelPadding
  local labelHeight = fontHeight * labelTextScale + labelPadding
  local labelx, labely = x - (labelWidth / 2), y - 60
  love.graphics.setColor(love.math.colorFromBytes(75, 114, 110, 255))
  love.graphics.rectangle("fill", labelx, labely, labelWidth, labelHeight, 0, 0, 2)
  LgUtil.resetColor()
  love.graphics.print(labelText, labelx + labelPadding / 2, labely + labelPadding / 2, 0, 0.5, labelTextScale)
end

function FruitEvoWheel:draw()
  -- love.graphics.circle("line", self.x, self.y, 100, #FruitTypes)
  for index, p in ipairs(self.points) do
    if index == player.secondHeldFruit and FruitEvoWheel.index then
      love.graphics.circle("fill", p.x, p.y, 30, #FruitTypes)
    end
    love.graphics.draw(FruitTypes[index].spriteSheet, p.x, p.y, 0, self.scale, self.scale, 32, 32)
  end
  for index, p in ipairs(self.points) do
    if index == player.secondHeldFruit and FruitEvoWheel.index then
      local fruitType = FruitTypes[index]
      love.graphics.circle("fill", p.x, p.y, 30, #FruitTypes)
      love.graphics.draw(fruitType.spriteSheet, p.x, p.y, 0, self.scale, self.scale, 32, 32)
      drawEvoWheelLabel(p.x, p.y, fruitType)
    end
  end
end
