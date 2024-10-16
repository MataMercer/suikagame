local update = {}

local function updateGame(dt)
    if GameState.state == GameState.GAMEPLAY then
        world:update(dt)
    end
    particleWorld:update(dt)
    gameMap:update(dt)
    playerUpdate(dt)
    actors:update(dt)
    fruitThrows:update(dt)
    updateFruit(dt)
    updateLimiter(dt)
    UpdateMergeEffects(dt)
    comboManager:update(dt)


    --Custom Ui Components
    FruitEvoWheel:update(dt)

    flux.update(dt)
    cam:update(dt)
end

function update.updateAll(dt)
    if GameState.state == GameState.GAMEPLAY or GameState.state == GameState.CUTSCENE then
        updateGame(dt)
    end
    GameStart:checkWindowSize()
    Cutscene:update(dt)
    TEsound.cleanup()
end

return update
