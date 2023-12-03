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
        {colTargetClass})
    local closestIndex = 1
    local closestDistance = math.sqrt(queryWidth ^ 2 + queryHeight ^ 2)
    for i, c in ipairs(nearbyCols) do
        local cx, cy = c:getPosition()
        local dist = util.distanceBetween(cx, cy, sx, sy)
        if dist < closestDistance then
            local platformCol = world:queryLine(sx, sy, cx, cy, {'Platform'})
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

return util
