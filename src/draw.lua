local draw = {}
function draw.drawBeforeCamera()
    if GameState.state == GameState.MAIN_MENU then
        -- mainmenu:draw()
    end

end

function draw.drawCamera()
    -- love.graphics.setColor(love.math.colorFromBytes(139, 172, 15))
    if GameState.state == GameState.GAMEPLAY then
        gameMap:drawLayer(gameMap.layers["Tile Layer 1"])
        love.graphics.setColor(1, 1, 1)

        playerDraw()
        actors:draw()
        drawFruit()
        -- world:draw()

    end

end

function draw.drawAfterCamera()

end

return draw
