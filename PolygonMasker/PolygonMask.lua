local rdp = require('lib/LuaAlgorithms/RamerDouglasPeucker')

local function transparentCheck(pixel)
    return pixel[1] == 0 and pixel[2] == 0 and pixel[3] == 0
end

local function borderCheck(imageData, x, y)
    local spriteW = imageData:getWidth() - 1
    local spriteH = imageData:getHeight() - 1


    -- checkself
    if transparentCheck({ imageData:getPixel(x, y) }) then
        return false
    end

    --ensure that a border pixel must be surrounded by at least 2 transparent points.
    local checkCtr = 0
    -- check top
    if y + 1 > spriteH then
        checkCtr = checkCtr + 1
    end

    if y + 1 <= spriteH and
        transparentCheck({ imageData:getPixel(x, y + 1) }) then
        checkCtr = checkCtr + 1
    end

    -- check left
    if x - 1 < 1 then
        checkCtr = checkCtr + 1
    end
    if x - 1 >= 1 and transparentCheck({ imageData:getPixel(x - 1, y) }) then
        checkCtr = checkCtr + 1
    end

    -- check right
    if x + 1 > spriteW then
        checkCtr = checkCtr + 1
    end
    if x + 1 <= spriteW and transparentCheck({ imageData:getPixel(x + 1, y) }) then
        checkCtr = checkCtr + 1
    end

    -- check down
    if y - 1 < 1 then
        checkCtr = checkCtr + 1
    end
    if y - 1 >= 1 and transparentCheck({ imageData:getPixel(x, y - 1) }) then
        checkCtr = checkCtr + 1
    end

    return checkCtr > 1
end

local function getBorderPoints(imageData)
    local borderPoints = {}
    for x = 0, imageData:getWidth() - 1, 1 do
        for y = 0, imageData:getHeight() - 1, 1 do
            if borderCheck(imageData, x, y) then
                table.insert(borderPoints, {
                    x = x,
                    y = y
                })
            end
        end
    end
    return borderPoints
end

local function orderPointsByAdjacency(points)
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

function findPolygonMaskFromImage(imageData, polygonLimit)
    local borderPoints = getBorderPoints(imageData)
    borderPoints = orderPointsByAdjacency(borderPoints)

    local filtered = {}
    local i = 100
    local polygonLimit = 8
    while i > 0 do
        filtered = rdp(borderPoints, i, true)
        if #filtered == 8 then
            break
        elseif #filtered > 8 then
            filtered = rdp(borderPoints, i + 1, true)
            break
        end
        i = i - 1
    end
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

function unflattenCoordList(flattenedPoints)
    local res = {}
    cur = {}
    for i, p in ipairs(flattenedPoints) do
        if i % 2 == 1 then
            cur.x = p
        else
            cur.y = p
            table.insert(res, cur)
            cur = {}
        end
    end
    return res
end

function findCentroidPoint(points)
    local x = 0
    local y = 0
    for i = 1, #points, 1 do
        x = x + points[i].x
        y = y + points[i].y
    end
    return {
        x = x / #points,
        y = y / #points
    }
end

function findCircumscribedCircleRadius(points)
    local centroidPoint = findCentroidPoint(points)
    local maxDist = 0
    for i, p in ipairs(points) do
        local dist = util.distanceBetween(centroidPoint.x, centroidPoint.y, p.x, p.y)
        if dist > maxDist then
            maxDist = dist
        end
    end
    return maxDist
end

function findMostOccurringColor(imageData)
    local colorToOccurrence = {}
    local mostOccurring
    local max = 0
    for x = 0, imageData:getWidth() - 1, 1 do
        for y = 0, imageData:getHeight() - 1, 1 do
            local r, g, b = imageData:getPixel(x, y)
            if r > 0 or g > 0 or b > 0 then
                local serializedColor = string.format("%d,%d,%d", r * 255, g * 255, b * 255)
                if colorToOccurrence[serializedColor] then
                    colorToOccurrence[serializedColor] = colorToOccurrence[serializedColor] + 1
                else
                    colorToOccurrence[serializedColor] = 1
                end

                if colorToOccurrence[serializedColor] > max then
                    mostOccurring = serializedColor
                    max = colorToOccurrence[serializedColor]
                end
            end
        end
    end
    local colors = {}
    for word in string.gmatch(mostOccurring, '([^,]+)') do
        table.insert(colors, word)
    end
    return {
        tonumber(colors[1]),
        tonumber(colors[2]),
        tonumber(colors[3]),
    }
end

-- function scalePolygon(points, centroidPoint, desiredRadius)
--     local scaledVerticles = {}

--     for i, p in ipairs(points) do
--         local dist = util.distanceBetween(centroidPoint.x, centroidPoint.y, p.x, p.y)
--         local scaleFactor = desiredRadius / dist
--         local scaledX = centroidPoint.x + (p.x - centroidPoint.x) * scaleFactor
--         local scaledY = centroidPoint.y + (p.y - centroidPoint.y) * scaleFactor
--         table.insert(scaledVerticles, {
--             x = scaledX,
--             y = scaledY
--         })
--     end
--     return scaledVerticles
-- end
function scalePolygon(vertices, centroidPoint, scaleFactor)
    local centroidX = centroidPoint.x
    local centroidY = centroidPoint.y

    -- normalize
    for i = 1, #vertices do
        vertices[i].x = vertices[i].x - centroidX
        vertices[i].y = vertices[i].y - centroidY
    end

    -- Scale the coordinates of each vertex relative to the origin
    for i = 1, #vertices do
        vertices[i].x = vertices[i].x * scaleFactor
        vertices[i].y = vertices[i].y * scaleFactor
    end

    -- Translate vertices back to their original position
    for i = 1, #vertices do
        vertices[i].x = vertices[i].x + centroidX
        vertices[i].y = vertices[i].y + centroidY
    end
    return vertices
end

function getSpriteVerts(absolutePoints, scaleTarget)
    local centroidPoint = findCentroidPoint(absolutePoints)
    local scaledPoints = scalePolygon(absolutePoints, centroidPoint, scaleTarget)
    return scaledPoints
end

function findScaleTargetFromRadius(radius, polygonVertices)
    return radius / findCircumscribedCircleRadius(polygonVertices)
    -- print(calculateCircleArea(radius))
    -- print(calculatePolygonArea(polygonVertices))
    -- local area = calculateCircleArea(radius) / calculatePolygonArea(polygonVertices)
    -- print(area)
    -- return area
end

function calculatePolygonArea(vertices)
    local n = #vertices
    local area = 0

    -- Apply the shoelace formula
    for i = 1, n do
        local j = (i % n) + 1
        area = area + (vertices[i].x * vertices[j].y)
        area = area - (vertices[j].x * vertices[i].y)
    end

    area = 0.5 * math.abs(area)
    return area
end

function calculateCircleArea(radius)
    return math.pi * radius * radius
end
