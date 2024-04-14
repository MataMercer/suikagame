local draw = {}
function draw.drawBeforeCamera()
end

function draw.drawCamera()
    -- love.graphics.setColor(love.math.colorFromBytes(139, 172, 15))
    if GameState.state == GameState.GAMEPLAY then
        gameMap:drawLayer(gameMap.layers["Tile Layer 1"])
        love.graphics.setColor(1, 1, 1)

        playerDraw()
        actors:draw()
        drawFruit()
        DrawMergeEffects()

        -- world:draw()
        -- particleWorld:draw()
    end

    Cutscene:draw()
end

function draw.drawAfterCamera()

end

return draw
