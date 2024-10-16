local mainMenuPanel
local function initPanel()
    -- iNIT MAIN MENU PANEL
    local scoreLabel = Ui.label({
        text = "Final Score: " .. player.score
    })


    local highScoreLabelText = ""
    if player.score > player.highScore then
        highScoreLabelText = "Congrats! You beat your high score! "
    elseif player.score == player.highScore then
        highScoreLabelText = "You tried"
    else
        highScoreLabelText = "You did not beat your high score."
    end
    local highScoreLabel = Ui.label({
        text = highScoreLabelText
    })
    local width = 600
    return Ui.panel({
            x = love.graphics.getWidth() / 2 - width / 2,
            y = love.graphics.getHeight() / 2 - 100,
            w = width,
            h = 1000,
            -- debug = true,
            rows = 8,
            cols = 1,
            verticalScale = 1,
            tag = 'panelc',
            -- bgColor = {0.2, 0.2, 0.7, 1},
            font = Fonts.robotoBold
        })
        :rowspanAt(1, 1)
        :rowspanAt(2, 1)
        :rowspanAt(3, 1)
        :rowspanAt(4, 1)
        :addAt(1, 1, scoreLabel)
        :addAt(2, 1, highScoreLabel)
        :addAt(3, 1, Ui.button({
            text = 'Restart'
        }):action(function(e)
            TEsound.play(sounds.click, "static")
            GameStart:restart()
            GameState.state = GameState.GAMEPLAY
            destroyGameOverMenu()
            initGameInterface()
        end))
        :addAt(4, 1, Ui.button({
            text = 'Title Screen'
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
