function love.load()
    math.randomseed(os.time())

    colliderToggle = false
    _G.GameStart = require("src/startup/gameStart")
    GameStart:gameStart()
    createNewSave()

    -- store all entities in this object.
    entities = {}

    platforms = {}
    flagX = 0
    flagY = 0

    saveData = {}
    saveData.currentLevel = "basemap"

    if love.filesystem.getInfo("data.lua") then
        local data = love.filesystem.load("data.lua")
        data()
    end

    loadMap(saveData.currentLevel)
    print("Game Loaded.")
end

function love.update(dt)
    update.updateAll(dt)
    -- local colliders = world:queryCircleArea(flagX, flagY, 10, { 'Player' })
    -- if #colliders > 0 then
    --     if saveData.currentLevel == "level1" then
    --         loadMap("green-shade-level-1")
    --     elseif saveData.currentLevel == "level2" then
    --         loadMap("level1")
    --     end
    -- end
end

function love.draw()
    love.graphics.draw(sprites.background, 0, 0, nil, 3, 3)
    love.graphics.setColor(1, 1, 1)
    -- love.graphics.draw(sprites.background, 0, 0, nil, scale, scale)

    local hpBarWidth = 300
    local currentHpBarWidth = (player.health / player.maxHealth) * hpBarWidth
    local hpBarHeight = hpBarWidth * 0.1
    local hpBarX = 5
    local hpBarY = 5
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", hpBarX, hpBarY, hpBarWidth, hpBarHeight)
    love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
    love.graphics.rectangle("fill", hpBarX, hpBarY, currentHpBarWidth, hpBarHeight)
    love.graphics.setColor(1, 1, 1)

    cam:attach()
    draw.drawCamera()

    cam:detach()
end

function love.mousepressed(x, y, button)
    if button == 1 then
        local colliders = world:queryCircleArea(x, y, 200, {'Platform'})
    end
end

function spawnPlatform(x, y, width, height)
    if width > 0 and height > 0 then
        local platform = world:newRectangleCollider(x, y, width, height, {
            collision_class = "Platform"
        })
        platform:setType("static")
        platform:setFriction(0.1)
        table.insert(platforms, platform)
    end
end

function destroyAll()

end
