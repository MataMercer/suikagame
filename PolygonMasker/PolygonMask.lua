-- package.path = '?.lua;' .. package.path
package.path = 'lib/png-lua/?.lua;' .. package.path
local rdp = require('lib/LuaAlgorithms/RamerDouglasPeucker')
local pngImage = require('lib/png-lua/png')

function loadPngImg(path)
    return pngImage(path, function()
    end, true, false)
end

function borderCheck(pixel, x, y, img)

    local spriteW = img.width
    local spriteH = img.height

    -- checkself
    if transparentCheck(pixel) then
        return false
    end

    local checkCtr = 0
    -- check top
    if y + 1 > spriteH then
        checkCtr = checkCtr + 1
    end
    if y + 1 <= spriteH and transparentCheck(img.pixels[y + 1][x]) then
        checkCtr = checkCtr + 1
    end

    -- check left
    if x - 1 < 1 then
        checkCtr = checkCtr + 1
    end
    if x - 1 >= 1 and transparentCheck(img.pixels[y][x - 1]) then
        checkCtr = checkCtr + 1
    end

    -- check right
    if x + 1 > spriteW then
        checkCtr = checkCtr + 1
    end
    if x + 1 <= spriteW and transparentCheck(img.pixels[y][x + 1]) then
        checkCtr = checkCtr + 1
    end

    -- check down
    if y - 1 < 1 then
        checkCtr = checkCtr + 1
    end
    if y - 1 >= 1 and transparentCheck(img.pixels[y - 1][x]) then
        checkCtr = checkCtr + 1
    end

    return checkCtr > 1

end

function transparentCheck(pixel)
    return pixel.R == 0 and pixel.G == 0 and pixel.B == 0
end

function getBorderPoints(img)
    local borderPoints = {}
    for y, yP in pairs(img.pixels) do
        for x, xP in pairs(yP) do
            if borderCheck(xP, x, y, img) then
                -- print(string.format("x: %d , y: %d  | Alpha: %d", x, y, xP.A))
                table.insert(borderPoints, {
                    x = x,
                    y = y
                })
            end
        end
    end
    return borderPoints
end

function orderPointsByAdjacency(points)

    local visitedIndices = {}
    local res = {}
    local i = 1
    table.insert(res, points[i])
    visitedIndices[i] = true

    while #visitedIndices <= #points do
        local distMinIndex = nil
        local distMin = 10000
        for j, p2 in ipairs(points) do
            if i ~= j and visitedIndices[j] == nil then

                local dist = util.distanceBetween(points[i].x, points[i].y, p2.x, p2.y)
                if dist < distMin then
                    distMinIndex = j
                    distMin = dist
                end
            end
        end
        if distMinIndex == nil then
            break
        end
        table.insert(res, points[distMinIndex])
        visitedIndices[distMinIndex] = true
        i = distMinIndex
    end
    return res
end

function findPolygonMaskFromImage(imgPath, polygonLimit)
    local img = loadPngImg(imgPath)
    local borderPoints = getBorderPoints(img)
    borderPoints = orderPointsByAdjacency(borderPoints)

    local filtered = {}
    local i = 100
    local polygonLimit = 8
    while i > 0 do
        filtered = rdp(borderPoints, i, true)
        if #filtered >= 8 then
            break
        end
        i = i - 1
    end
    print(#filtered)
    return filtered
end

function flattenCoordList(points)
    local res = {}
    for i, p in ipairs(points) do
        table.insert(res, p.x)
        table.insert(res, p.y)
    end
    return res
end
