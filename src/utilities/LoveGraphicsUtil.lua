_G.LgUtil = {}

function LgUtil.resetColor()
    love.graphics.setColor(1, 1, 1)
end

function LgUtil.setColor(r, g, b, a)
    love.graphics.setColor(love.math.colorFromBytes(r, g, b, a))
end
