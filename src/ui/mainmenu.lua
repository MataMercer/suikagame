local mainMenuPanel
local function initPanel()
    -- iNIT MAIN MENU PANEL
    local width = 600
    return Ui.panel({
        x = love.graphics.getWidth() / 2 - width / 2,
        y = love.graphics.getHeight() / 2 - 100,
        w = width,
        h = 1000,
        -- debug = true,
        rows = 8,
        cols = 1,
        verticalScale = 2,
        tag = 'panelc',
        -- bgColor = {0.2, 0.2, 0.7, 1},
        font = Fonts.robotoBold
    }):rowspanAt(1, 1):rowspanAt(2, 1):rowspanAt(3, 1) -- START BUTTON
    :addAt(1, 1, Ui.label({
        text = "SUIKA GAME: LUA EDITION"
    })):addAt(2, 1, Ui.button({
        text = 'Start Game'
    }):action(function(e)

        GameState.state = GameState.GAMEPLAY
        destroyMainMenu()
        initGameInterface()
    end)) -- QUIT BUTTON
    :addAt(3, 1, Ui.button({
        text = 'Quit'
    }):action(function(e)
        love.event.quit()
    end))

end

function initMainMenu()
    Ui.setDefaultFont(Fonts.proggySquare)
    mainMenuPanel = initPanel()
    Ui:add(mainMenuPanel)
end

function destroyMainMenu()
    if Ui and mainMenuPanel then

        Ui:remove(mainMenuPanel)
    end
end

