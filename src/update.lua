local update = {}

local function updateGame(dt)
    world:update(dt)
    particleWorld:update(dt)
    gameMap:update(dt)
    playerUpdate(dt)
    actors:update(dt)
    fruitThrows:update(dt)
    updateFruit(dt)
    updateLimiter(dt)
    UpdateMergeEffects(dt)
    flux.update(dt)
    cam:update(dt)
end

function update.updateAll(dt)
    if GameState.state == GameState.GAMEPLAY then
        updateGame(dt)
    end
    GameStart:checkWindowSize()
    Cutscene:update(dt)
    TEsound.cleanup()
end

return update
