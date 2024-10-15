Vector = {}

function Vector.new(x, y)
  return { x, y }
end

function Vector.dot(vecA, vecB)
  return vecA.x * vecB.x + vecA.y * vecB.y
end

function Vector.neg(vec)
  return {
    x = vec.x * -1,
    y = vec.y * -1
  }
end

return Vector
