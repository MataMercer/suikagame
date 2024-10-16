function InitGameOverCutscene()
    gameOverCutsceneSeq = {}
    table.insert(gameOverCutsceneSeq, function()
        love.graphics.setShader(GrayScaleShader)
        comboManager:destroy()
        Cutscene:wait(0.5, true)
        return true
    end)

    table.sort(Fruits, function(a, b)
        local ax, ay = a:getPosition()
        local bx, by = b:getPosition()
        return by > ay
    end)
    for index, fruit in ipairs(Fruits) do
        if fruit.dead == false then
            local x, y = fruit:getPosition()
            table.insert(gameOverCutsceneSeq, function()
                SpawnMergeEffect(x, y, 5, fruit.fruitType.color)
                fruit.dead = true
                if index == #Fruits then
                    print("fruits dead")
                end
            end)
            table.insert(gameOverCutsceneSeq, function()
                Cutscene:wait(0.1, true)
                return true
            end)
        end
    end
    table.insert(gameOverCutsceneSeq, function()
        love.graphics.setShader(nil)
    end)
    return gameOverCutsceneSeq
end
