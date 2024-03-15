-- Ramer–Douglas–Peucker algorithm
-- Source: https://en.wikipedia.org/wiki/Ramer%E2%80%93Douglas%E2%80%93Peucker_algorithm
package.path = '../?.lua;' .. package.path
util = require('../src/utilities/util')

function printPoint(p)
    if p ~= nil then

        print(string.format("x: %d , y: %d", p.x, p.y))
    else
        print("nil")
    end
end

function printPointList(ps)
    if #ps == 0 then
        print("Empty List")
        return
    end
    for i, v in ipairs(ps) do
        printPoint(v)
    end
end

function rdpAlgo(points, epsilon)
    local distanceMax = 0
    local index = 0
    local ending = #points
    for i = 2, ending - 1, 1 do
        distance = perpendicularDistance(points[i], points[1], points[ending])
        if distance > distanceMax then
            index = i
            distanceMax = distance
        end
    end

    -- print("\n")
    -- print("pointMax")
    -- printPoint(points[index])
    -- print("pointList")
    -- printPointList(points)

    res = {}
    if distanceMax > epsilon then
        recResults1 = rdpAlgo(slice(points, 1, index), epsilon)
        recResults2 = rdpAlgo(slice(points, index, ending), epsilon)
        res = combine(slice(points, 1, #recResults1 - 1), slice(recResults2, 1, #recResults2))
    else
        res = combine({points[1]}, {points[ending]})
    end
    return res
end

function perpendicularDistance(point, lineStartPoint, lineEndPoint)
    local numerator = math.abs((lineEndPoint.x - lineStartPoint.x) * (lineStartPoint.y - point.y) -
                                   (lineStartPoint.x - point.x) * (lineEndPoint.y - lineStartPoint.y))
    local denominator = math.sqrt(math.pow(lineEndPoint.x - lineStartPoint.x, 2) +
                                      math.pow(lineEndPoint.y - lineStartPoint.y, 2))
    return numerator / denominator
end

function slice(arr, start, stop)
    local sliced = {}
    for i = start, stop, 1 do
        table.insert(sliced, arr[i])
    end
    return sliced
end

function combine(arr1, arr2)
    res = {}
    for i = 1, #arr1, 1 do
        table.insert(res, arr1[i])
    end

    for i = 1, #arr2, 1 do
        table.insert(res, arr2[i])
    end
    return res
end

package.path = '../?.lua;' .. package.path
-- local rdpLib = require("../lib/LuaAlgorithms/RamerDouglasPeucker")
local function testRdp()
    local points = {{
        x = 1,
        y = 2
    }, {
        x = 2,
        y = 1
    }, {
        x = 4,
        y = 0
    }, {
        x = 5,
        y = 1
    }}

    rdpPoints = rdpAlgo(points, 2)
    print("\n\nFinal Results:")
    printPointList(rdpPoints)

end
-- testRdp()
local function testPerp()
    local dist = perpendicularDistance({{
        x = 1,
        y = 0
    }, {
        x = 0,
        y = 1
    }, {
        x = 2,
        y = 1
    }})
    print(dist)

end
-- testPerp()

local function testOrder()
    local points = {{
        x = 1,
        y = 2
    }, {
        x = 2,
        y = 1
    }, {
        x = 5,
        y = 1
    }, {
        x = 4,
        y = 0
    }}
    local ordered = orderPointsByAdjacency(points)

    print("ordered List:")
    printPointList(ordered)
end
-- testOrder()
return rdpAlgo
