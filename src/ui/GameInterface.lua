local progressBar, leftPanel, rightPanel, scoreLabel, nextFruitImage
local progressBarSpeed = 0.3

local function destroyGameInterface()
    if Ui and leftPanel and rightPanel then
        Ui:remove(leftPanel)
        Ui:remove(rightPanel)
    end
end
local function initLeftPanel()
    progressBar = Ui.progressBar({
            speed = 0,
            value = 1,
            direction = -1
        })
        :action(function(evt)
            if evt.type == 'full' then
                if Limiter.warningActive then
                    evt.target.speed = progressBarSpeed
                end
            elseif evt.type == 'empty' then
                GameState.state = GameState.GAME_OVER
                initGameOverMenu()
                destroyGameInterface()
            end
        end)

    scoreLabel = Ui.label({
        text = "Score: " .. player.score
    })
    -- Init left panel
    local width = 400
    return Ui.panel({
            x = love.graphics.getWidth() / 4 - width,
            y = love.graphics.getHeight() / 4 - 100,
            w = width,
            h = 1000,
            -- debug = true,
            rows = 8,
            cols = 1,
            verticalScale = 2,
            tag = 'panelc',
            -- bgColor = {0.2, 0.2, 0.7, 1},
            font = Fonts.robotoBold
        })
        :rowspanAt(1, 1)
        :rowspanAt(2, 1)
        :rowspanAt(3, 1)          -- Warning time limit indicator.
        :addAt(1, 1, progressBar) -- Show score
        :addAt(2, 1, scoreLabel)
        :addAt(3, 1, Ui.label({
            text = "[Z] to drop fruit"
        }))
end

function initRightPanel()
    nextFruitImage = Ui.image({
        image = FruitTypes[player.secondHeldFruit].spriteSheet,
        x = 0,
        y = 0,
        w = 64,
        h = 64,
        keepAspectRatio = true
    })

    local width = 500
    return Ui.panel({
            x = love.graphics.getWidth() / 2 + love.graphics.getWidth() / 4,
            y = love.graphics.getHeight() / 4 - 100,
            w = width,
            h = 1000,
            -- debug = true,
            rows = 8,
            cols = 1,
            verticalScale = 2,
            tag = 'paneld',
            -- bgColor = {0.2, 0.2, 0.7, 1},
            font = Fonts.robotoBold
        })
        :rowspanAt(1, 1)
        :rowspanAt(2, 1)
        :rowspanAt(3, 1)
        :addAt(2, 1, Ui.label({
            text = "Next Fruit:"
        }))
        :addAt(3, 1, nextFruitImage)
end

function initGameInterface()
    Ui.setDefaultFont(Fonts.proggySquare)
    leftPanel = initLeftPanel()
    Ui:add(leftPanel)

    rightPanel = initRightPanel()
    -- print(rightPanel)
    Ui:add(rightPanel)
    Ui:setStyle(UiCustomStyle)
end

function cancelWarningBar()
    if progressBar then
        progressBar.visible = false
        progressBar.value = 1
        progressBar.speed = 0
    end
end

function showWarningBar()
    if progressBar and progressBar.value < Limiter.visibleWarningThreshold then
        progressBar.visible = true
    end
end

function setScoreLabel(score)
    scoreLabel.text = "Score: " .. score
end

function RefreshNextFruitImage()
    nextFruitImage.image = FruitTypes[player.secondHeldFruit].spriteSheet
end
