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
      love.graphics.circle("fill", p.x, p.y, 30, #FruitTypes)
      love.graphics.draw(FruitTypes[index].spriteSheet, p.x, p.y, 0, self.scale, self.scale, 32, 32)
    end
  end
end
