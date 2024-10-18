function loadMap(mapName, destX, destY)
    destroyAll()

    if destX and destY then
        player:setPosition(destX, destY)
    end

    loadedMap = mapName
    gameMap = sti("maps/" .. mapName .. ".lua")

    if gameMap.layers["Start"] then
        for i, obj in pairs(gameMap.layers["Start"].objects) do
            playerStartX = obj.x
            playerStartY = obj.y
        end
        player:setPosition(playerStartX, playerStartY)
    end
    if gameMap.layers["Platforms"] then
        for i, obj in pairs(gameMap.layers["Platforms"].objects) do
            spawnPlatform(obj.x, obj.y, obj.width, obj.height)
        end

        local mapPlats = gameMap.layers["Platforms"].objects
        local leftBoundingPlatform = mapPlats[1]
        local bottomBoundingPlatform = mapPlats[2]
        local rightBoundingPlatform = mapPlats[3]

        Bounds.height = leftBoundingPlatform.height - bottomBoundingPlatform.height * 2
        Bounds.width = bottomBoundingPlatform.width
        Bounds.x = Platforms[1]:getX() + leftBoundingPlatform.width / 2
        Bounds.y = Platforms[1]:getY() - leftBoundingPlatform.height / 2 + bottomBoundingPlatform.height
    end
    if gameMap.layers["Limit"] then
        for i, obj in pairs(gameMap.layers["Limit"].objects) do
            spawnLimiter(obj.x, obj.y, obj.width, obj.height)
        end
    end
    print('map loaded')
end
