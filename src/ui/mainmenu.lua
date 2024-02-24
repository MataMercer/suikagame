local mainMenuPanel
local function initPanel()
    -- iNIT MAIN MENU PANEL
    local width = 600
    return ui.panel({
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
    :addAt(1, 1, ui.label({
        text = "SUIKA GAME: LUA EDITION"
    })):addAt(2, 1, ui.button({
        text = 'Start Game'
    }):action(function(e)

        GameState.state = GameState.GAMEPLAY
        destroyMainMenu()
        initGameInterface()
    end)) -- QUIT BUTTON
    :addAt(3, 1, ui.button({
        text = 'Quit'
    }):action(function(e)
        love.event.quit()
    end))

end

function initMainMenu()
    ui.setDefaultFont(Fonts.proggySquare)
    mainMenuPanel = initPanel()
    ui:add(mainMenuPanel)
end

function destroyMainMenu()
    if ui and mainMenuPanel then

        ui:remove(mainMenuPanel)
    end
end

