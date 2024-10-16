local progressBar, rightPanel, scoreLabel, nextFruitImage
local progressBarSpeed = 0.5

local function destroyGameInterface()
    if Ui and rightPanel then
        Ui:remove(rightPanel)
    end
end
function initRightPanel()
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
            elseif progressBar.value == 0 and GameState.state == GameState.GAMEPLAY then
                print(progressBar.value)
                print("Initiating Gameover Sequence")
                local gameOverCutsceneSeq = InitGameOverCutscene()
                GameState.state = GameState.CUTSCENE
                Cutscene:startCutscene(gameOverCutsceneSeq, function()
                    GameState.state = GameState.GAME_OVER
                    initGameOverMenu()
                    destroyGameInterface()
                end)
            end
        end)

    scoreLabel = Ui.label({
        text = "Score: " .. player.score,
    })

    local width = love.graphics.getWidth() / 3
    return Ui.panel({
            x = (love.graphics.getWidth() / 1) - love.graphics.getWidth() / 3,
            y = love.graphics.getHeight() / 4 - 100,
            w = width,
            h = 800,
            -- debug = true,
            rows = 5,
            cols = 1,
            verticalScale = 1,
            tag = 'paneld',
            -- bgColor = {0.2, 0.2, 0.7, 1},
            font = Fonts.robotoBold
        })
        :rowspanAt(1, 1)
        :rowspanAt(2, 1, 2)
        :rowspanAt(4, 1)
        :rowspanAt(5, 1)
        :addAt(1, 1, progressBar)
        :addAt(2, 1, scoreLabel:center())
end

function initGameInterface()
    Ui.setDefaultFont(Fonts.proggySquare)
    rightPanel = initRightPanel()
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
