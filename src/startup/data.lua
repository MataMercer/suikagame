function createNewSave(fileNumber)
    data = {}
    data.saveCount = 0
    data.playerX = 0
    data.playerY = 0
    data.maxHealth = 100
    data.currentHealth = 100

    if fileNumber == nil then
        fileNumber = 1
    end
    data.fileNumber = fileNumber

    data.item = {}
    data.item.left = nil
    data.item.right = nil

    data.shurikenCount = 0
end

function saveGame()
    data.saveCount = data.saveCount + 1
    data.playerX = player:getX()
    data.playerY = player:getY()
    data.map = loadedMap
end

function startNewGame(fileNumber)
    createNewSave(fileNumber)
    data.map = "test"
    data.playerX = 100
    data.playerY = 100
    player.state = 0
end
