local update = {}

local function updateGame(dt)
    world:update(dt)
    gameMap:update(dt)
    playerUpdate(dt)
    actors:update(dt)
    fruitThrows:update(dt)
    updateFruit(dt)
    updateLimiter(dt)
    flux.update(dt)
    cam:update(dt)
end

function update.updateAll(dt)

    if GameState.state == GameState.GAMEPLAY then
        updateGame(dt)
    end
    GameStart:checkWindowSize()
end

return update
