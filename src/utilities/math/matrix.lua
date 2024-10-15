Matrix = {}

function Matrix.createEmptyMatrix(rows, cols)
  local M = cols
  local N = rows
  local matrix = {}
  for i = 1, N do
    matrix[i] = {}
    for j = 1, M do
      matrix[i][j] = 0
    end
  end
  return matrix
end

function Matrix.listToMatrix(l, cols)
  local res = {}
  local rowlist = {}
  for i = 1, #l do
    table.insert(rowlist, l[i])
    if i % cols == 0 then
      table.insert(res, rowlist)
      rowlist = {}
    end
  end
  return res
end

function Matrix.calcDeterminant(matrix)
  local N = #matrix
  local M = #matrix[1]
  local res = 0
  --Check matrix is square
  if M ~= N then
    print("Error: Matrix is not a square.")
    return nil
  end

  if M == 2 then
    local negative = false
    for i = 1, M do
      for j = 1, M do
        if j ~= i then
          local subres = (matrix[1][i] * matrix[2][j])
          if negative then
            subres = subres * -1
          end
          res = res + subres
          negative = not negative
        end
      end
    end
  end

  if M > 2 then
    local negative = false
    for coeff_index = 1, M do
      local subMatrixList = {}
      for j = 2, N do
        for k = 1, M do
          if k ~= coeff_index then
            table.insert(subMatrixList, matrix[j][k])
          end
        end
      end
      local subMatrix = Matrix.listToMatrix(subMatrixList, M - 1)
      local det = Matrix.calcDeterminant(subMatrix)
      local subres = matrix[1][coeff_index] * det
      if negative then
        subres = subres * -1
      end
      res = res + subres
      negative = not negative
    end
  end

  return res
end

function Matrix.print(matrix)
  local N = #matrix
  local M = #matrix[1]
  for i = 1, N do
    io.write("|")
    for j = 1, M do
      io.write(matrix[i][j])
      io.write(" ")
    end
    io.write("|\n")
  end
end

return Matrix
