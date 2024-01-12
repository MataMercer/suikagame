local update = {}

local function updateGame(dt)

    world:update(dt)
    gameMap:update(dt)
    player:update(dt)
    actors:update(dt)
    fruitThrows:update(dt)
    updateFruit(dt)
    flux.update(dt)
    cam:update(dt)
end

function update.updateAll(dt)

    if GameStart.gamestate == GameStart.GAMEPLAY then
        updateGame(dt)
    end
    GameStart:checkWindowSize()
end

return update
