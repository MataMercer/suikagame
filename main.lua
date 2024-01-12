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
    _G.ui = urutora:new()
    print("Game Loaded.")

    local clickMe = ui.button({
        text = 'Start Game',
        x = love.graphics.getWidth() / 2,
        y = 10,
        w = 200,
        h = 100
    })

    local num = 0
    clickMe:action(function(e)
        GameStart.gamestate = GameStart.GAMEPLAY
        ui:remove(clickMe)
    end)

    ui:add(clickMe)
end

function love.update(dt)

    ui:update(dt)
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
    cam:attach()
    draw.drawCamera()

    cam:detach()
    ui:draw()
end

function love.mousepressed(x, y, button)
    ui:pressed(x, y, button)
end
function love.mousemoved(x, y, dx, dy)
    ui:moved(x, y, dx, dy)
end
function love.mousereleased(x, y, button)
    ui:released(x, y)
end
function love.textinput(text)
    ui:textinput(text)
end
function love.keypressed(k, scancode, isrepeat)
    ui:keypressed(k, scancode, isrepeat)
end
function love.wheelmoved(x, y)
    ui:wheelmoved(x, y)
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
