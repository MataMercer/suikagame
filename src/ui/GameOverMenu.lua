local mainMenuPanel
local function initPanel()
    -- iNIT MAIN MENU PANEL
    local scoreLabel = Ui.label({
        text = "Final Score: " .. player.score
    })
    local highScoreLabel = Ui.label({
        text = "High Score: " .. player.highScore
    })



    local resultText = ""
    if player.score > player.highScore then
        resultText = "Congrats! You beat your high score! "
    elseif player.score == player.highScore then
        resultText = "You tried"
    else
        resultText = "You did not beat your high score."
    end
    local resultText = Ui.label({
        text = resultText
    })
    local width = love.graphics.getWidth() * 0.8
    return Ui.panel({
            x = love.graphics.getWidth() / 2 - width / 2,
            y = love.graphics.getHeight() / 4 - 100,
            w = width,
            h = 1000,
            -- debug = true,
            rows = 8,
            cols = 3,
            verticalScale = 1,
            tag = 'panelc',
            -- bgColor = {0.2, 0.2, 0.7, 1},
            font = Fonts.robotoBold
        })
        :rowspanAt(1, 1)
        :rowspanAt(2, 1)
        :rowspanAt(3, 1)
        :rowspanAt(4, 1)
        :addAt(1, 2, scoreLabel)
        :addAt(2, 2, highScoreLabel)
        :addAt(3, 2, resultText)
        :addAt(4, 2, Ui.button({
            text = 'Restart'
        }):action(function(e)
            TEsound.play(sounds.click, "static")
            GameStart:restart()
            GameState.state = GameState.GAMEPLAY
            destroyGameOverMenu()
            initGameInterface()
        end))
        :addAt(5, 2, Ui.button({
            text = 'Title'
        }):action(function(e)
            TEsound.play(sounds.click, "static")
            GameStart:restart()
            GameState.state = GameState.MAIN_MENU
            destroyGameOverMenu()
            initMainMenu()
        end))
end

function initGameOverMenu()
    Ui.setDefaultFont(Fonts.proggySquare)
    mainMenuPanel = initPanel()
    Ui:add(mainMenuPanel)
    Ui:setStyle(UiCustomStyle)
end

function destroyGameOverMenu()
    if Ui and mainMenuPanel then
        Ui:remove(mainMenuPanel)
    end
end
