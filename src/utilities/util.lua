local util = {}

function util.findNearestCollider(subjectCol, colTargetClass)
    local sx, sy = subjectCol:getPosition()

    local queryWidth = 800
    local queryHeight = 800
    local queryXPos = sx

    if subjectCol.direction < 0 then
        queryXPos = sx + (-1 * queryWidth)
    end

    local nearbyCols = world:queryRectangleArea(queryXPos, sy - queryHeight / 2, queryWidth, queryHeight,
        { colTargetClass })
    local closestIndex = 1
    local closestDistance = math.sqrt(queryWidth ^ 2 + queryHeight ^ 2)
    for i, c in ipairs(nearbyCols) do
        local cx, cy = c:getPosition()
        local dist = util.distanceBetween(cx, cy, sx, sy)
        if dist < closestDistance then
            local platformCol = world:queryLine(sx, sy, cx, cy, { 'Platform' })
            if #platformCol == 0 then
                closestIndex = i
                closestDistance = dist
            end
        end
    end
    return nearbyCols[closestIndex]
end

function util.rotationBetween(subjectX, subjectY, targetX, targetY)
    return math.atan2(subjectY - targetY, subjectX - targetX)
end

function util.distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function util:distToPlayer(x, y)
    local px, py = player:getPosition()
    return util.distanceBetween(x, y, px, py)
end

function util.add(tab, element)
    if tab == nil then
        return
    end

    table.insert(tab, element)
end

function util.del(tab, element)
    if tab == nil then
        return
    end
    table.remove(tab, element)
end

function util.set(list)
    local set = {}
    for _, l in ipairs(list) do
        set[l] = true
    end
    return set
end

function printPoint(p)
    if p ~= nil then
        print(string.format("x: %d , y: %d", p.x, p.y))
    else
        print("nil")
    end
end

function util.perpendicularDistance(point, lineStartPoint, lineEndPoint)
    local numerator = math.abs((lineEndPoint.x - lineStartPoint.x) * (lineStartPoint.y - point.y) -
        (lineStartPoint.x - point.x) * (lineEndPoint.y - lineStartPoint.y))
    local denominator = math.sqrt(math.pow(lineEndPoint.x - lineStartPoint.x, 2) +
        math.pow(lineEndPoint.y - lineStartPoint.y, 2))
    return numerator / denominator
end

-- source: https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection#Given_two_points_on_each_line
function util.checkLineSegmentIntersection(line1Point1, line1Point2, line2Point1, line2Point2)
    local x1 = line1Point1.x
    local y1 = line1Point1.y
    local x2 = line1Point2.x
    local y2 = line1Point2.y

    local x3 = line2Point1.x
    local y3 = line2Point1.y
    local x4 = line2Point2.x
    local y4 = line2Point2.y

    local t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / ((x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4))
    local u = -1 * (((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / ((x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)))

    return 0 <= t and t <= 1 and 0 <= u and u <= 1
end

function util.findIntersection(line1Point1, line1Point2, line2Point1, line2Point2)
    local x1 = line1Point1.x
    local y1 = line1Point1.y
    local x2 = line1Point2.x
    local y2 = line1Point2.y

    local x3 = line2Point1.x
    local y3 = line2Point1.y
    local x4 = line2Point2.x
    local y4 = line2Point2.y

    local px = ((x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4)) /
        ((x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4))
    local py = ((x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4)) /
        ((x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4))
    return {
        x = px,
        y = py
    }
end

function util.findIntersectingEdgePoints(polygon1Vertices, polygon2Vertices)
    local centroid1 = findCentroidPoint(polygon1Vertices)
    local centroid2 = findCentroidPoint(polygon2Vertices)

    local intersectingEdgePoint1
    local intersectingEdgePoint2
    local res = {}
    for i = 1, #polygon1Vertices, 1 do
        intersectingEdgePoint1 = polygon1Vertices[i]

        -- make sure it wraps
        if i == #polygon1Vertices then
            intersectingEdgePoint2 = polygon1Vertices[1]
        else
            intersectingEdgePoint2 = polygon1Vertices[i + 1]
        end

        local intersectCheck = util.checkLineSegmentIntersection(intersectingEdgePoint1, intersectingEdgePoint2,
            centroid1, centroid2)
        if intersectCheck then
            return intersectingEdgePoint1, intersectingEdgePoint2
        end
    end
end

-- poly vertices given in the colliders aren't relative to position.
function util.getRelativePolygonVertices(polygonCollider)
    local polygonVertices = polygonCollider.fruitType.polygonVertices
    local px, py = polygonCollider:getPosition()
    local angle = polygonCollider:getAngle()

    local res = {}
    for i, v in ipairs(polygonVertices) do
        local rotatedx = v.x * math.cos(angle) - v.y * math.sin(angle)
        local rotatedy = v.y * math.cos(angle) + v.x * math.sin(angle)
        res[i] = {
            x = rotatedx + px,
            y = rotatedy + py
        }
    end
    return res
end

function util.findClosestPoint(point, points)
    local index
    local distMin
    for i, p in ipairs(points) do
        local dist = util.distanceBetween(point.x, point.y, p.x, p.y)
        if condition then

        end
    end
end

return util
