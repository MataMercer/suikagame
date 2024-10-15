local Vector = require("./vector")

local initialVectorAxis = Vector.new(1, 0)

function support(polygon, vec)
  local curMaxDot = 0
  local curIndex = 1
  for index, vertex in ipairs(polygon) do
    if Vector.dot(vertex, vec) > curMaxDot then
      curMaxDot = Vector.dot(vertex, vec)
      curIndex = index
    end
  end
  return polygon[curIndex]
end

function checkPointInsideSimplex()

end

function nearestSimplex(simplex)

end

--Gilbert–Johnson–Keerthi distance algorithm
function collideCheck(polygonA, polygonB, initialVectorAxis)
  local vecA = support(polygonA, initialVectorAxis) - support(polygonB, Vector.neg(initialVectorAxis))
  local simplex = {}
  table.insert(simplex, vecA)
  local vecD = Vector.neg(vecA)

  while true do
    vecA = support(polygonA, vecD) - support(polygonB, Vector.neg(vecD))
    if Vector.dot(vecA, vecD) < 0 then
      return false
    end
    table.insert(simplex, vecA)
  end
end
