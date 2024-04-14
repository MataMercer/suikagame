-- package.path = '?.lua;' .. package.path
-- local util = require("src/utilities/util")
function checkLineSegmentIntersection(line1Point1, line1Point2, line2Point1, line2Point2)
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

function testCheckLineSegmentIntersection()
    local p1 = {
        x = 0,
        y = 0
    }
    local p2 = {
        x = 5,
        y = 5
    }
    local p3 = {
        x = 0,
        y = 5
    }
    local p4 = {
        x = 5,
        y = 0
    }
    local check = checkLineSegmentIntersection(p1, p2, p3, p4)
    print(check)
end

testCheckLineSegmentIntersection()

-- local testpt = {{
--     x = 2,
--     y = 1
-- }, {
--     x = 1,
--     y = 3
-- }, {
--     x = 3,
--     y = 6
-- }, {
--     x = 6,
--     y = 3
-- }, {
--     x = 5,
--     y = 1
-- }}

-- local testanswer = scalePolygon(testpt, findCentroidPoint(testpt), 5)
-- local cent = findCentroidPoint(testpt)
-- print(string.format("centroid x: %f , y: %f", cent.x, cent.y))
-- for i, v in ipairs(testanswer) do
--     print(string.format("x: %f , y: %f", v.x, v.y))
-- end

-- local cent = findCentroidPoint(testanswer)
-- print(string.format("centroid x: %f , y: %f", cent.x, cent.y))
