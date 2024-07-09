package.path = '../?.lua;' .. package.path
local Matrix = require('../utilities/matrix')

print("Begin tests...")

function testListToMatrix()
  print("Testing list to Matrix")
  local testMatrixList = { 4, 6, 3, 8 }
  local res = Matrix.listToMatrix(testMatrixList, 2)
  Matrix.print(res)
end

function test2x2Matrix()
  print("Testing 2x2 Matrix")
  local testMatrix = {
    { 4, 6 },
    { 3, 8 },
  }
  Matrix.print(testMatrix)

  local det = Matrix.calcDeterminant(testMatrix)
  local answer = 14
  print(det == answer)
end

function test3x3Matrix()
  print("Testing 3x3 Matrix")
  local testMatrix = {
    { 6, 1,  1 },
    { 4, -2, 5 },
    { 2, 8,  7 }
  }
  Matrix.print(testMatrix)

  local det = Matrix.calcDeterminant(testMatrix)
  local answer = -306
  print(det == answer)
end

function test4x4Matrix()
  print("Testing 3x3 Matrix")
  local testMatrix = {
    { 6, 1,  1, 1 },
    { 4, -2, 5, 1 },
    { 2, 8,  7, 1 },
    { 1, 3,  4, 5 }
  }
  Matrix.print(testMatrix)

  local det = Matrix.calcDeterminant(testMatrix)
  local answer = -1368
  print(det == answer)
end

testListToMatrix()
test2x2Matrix()
test3x3Matrix()
test4x4Matrix()
