local draw = {}
function draw.drawBeforeCamera()
end

function draw.drawCamera()
    -- love.graphics.setColor(love.math.colorFromBytes(139, 172, 15))
    if GameState.state == GameState.GAMEPLAY or GameState.state == GameState.CUTSCENE then
        FruitEvoWheel:draw()
        gameMap:drawLayer(gameMap.layers["Tile Layer 1"])
        love.graphics.setColor(1, 1, 1)

        playerDraw()
        drawFruit()
        DrawMergeEffects()

        comboManager:draw()

        -- world:draw()
        -- particleWorld:draw()
    end

    Cutscene:draw()
end

function draw.drawAfterCamera()

end

return draw
