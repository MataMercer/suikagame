function love.load()
    math.randomseed(os.time())

    colliderToggle = false
    _G.GameStart = require("src/startup/gameStart")

    require("src/startup/require")
    requireAll()

    _G.Ui = urutora:new()

    GameState.state = GameState.MAIN_MENU
    GameStart:gameStart()
    -- initMainMenu()
    Cutscene:startCutscene(LogoCutsceneSeq)
    GrayScaleShader = love.graphics.newShader('src/shaders/grayscale.glsl')
end

function love.update(dt)
    Ui:update(dt)
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
    if background then
        love.graphics.setColor(love.math.colorFromBytes(75, 114, 110, 255))
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(love.math.colorFromBytes(255, 255, 255, 255))
        local x, y = 0, 0

        local scale = love.graphics.getHeight() / background:getHeight()
        if backgroundScale then
            scale = backgroundScale
        end
        if backgroundCentered then
            local bgH = background:getHeight() * scale
            local bgW = background:getWidth() * scale
            x = love.graphics.getWidth() / 2 - bgW / 2
            y = love.graphics.getHeight() / 2 - bgH / 2
        end
        -- scale = 1


        love.graphics.draw(background, x, y, nil, scale, scale)
        if sprites.foreground and GameState.state == GameState.GAMEPLAY then
            love.graphics.draw(
                sprites.foreground,
                0,
                500,
                nil,
                scale,
                scale)
        end
    end
    LgUtil.resetColor()

    cam:attach()
    draw.drawCamera()

    cam:detach()
    Ui:draw()
end

function love.mousepressed(x, y, button)
    Ui:pressed(x, y, button)
    if GameState.state == GameState.GAMEPLAY then
        playerDropFruit()
        -- spawnFruit(x, y, 1, 2)
    end
end

function love.mousemoved(x, y, dx, dy)
    Ui:moved(x - 500, y, dx, dy)
end

function love.mousereleased(x, y, button)
    Ui:released(x, y)
end

function love.textinput(text)
    Ui:textinput(text)
end

function love.keypressed(k, scancode, isrepeat)
    Ui:keypressed(k, scancode, isrepeat)
end

function love.wheelmoved(x, y)
    Ui:wheelmoved(x, y)
end

function spawnPlatform(x, y, width, height)
    if width > 0 and height > 0 then
        local platform = world:newRectangleCollider(x, y, width, height, {
            collision_class = "Platform"
        })
        platform:setType("static")
        platform:setFriction(0.5)
        table.insert(Platforms, platform)
    end
end

function love.focus(f)
    if f then
        print("Window is focused.")
        text = "FOCUSED"
    else
        print("Window is not focused.")
        text = "UNFOCUSED"
    end
end

function destroyAll()

end
