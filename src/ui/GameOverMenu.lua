-- local scoreLabel
-- local panel
-- local function initPanel()
--     scoreLabel = ui.label({
--         text = "Your Final Score: " .. player.score
--     })
--     -- Init main panel
--     local width = 600
--     return ui.panel({
--         x = love.graphics.getWidth() / 2 - width / 2,
--         y = love.graphics.getHeight() / 2 - 100,
--         w = width,
--         h = 1000,
--         -- debug = true,
--         rows = 8,
--         cols = 1,
--         verticalScale = 2,
--         tag = 'panelc',
--         -- bgColor = {0.2, 0.2, 0.7, 1},
--         font = Fonts.robotoBold
--     }):rowspanAt(1, 1):rowspanAt(2, 1) -- RESTART BUTTON
--     :rowspanAt(3, 1):addAt(1, 1, scoreLabel):addAt(2, 1, ui.button({
--         text = 'Restart'
--     }):action(function(e)
--         -- resetPlayer()
--         -- GameStart:gameStart()
--         -- GameState.state = GameState.GAMEPLAY
--         destroyGameOverMenu()
--         -- initGameInterface()
--     end)):addAt(3, 1, ui.button({
--         text = 'Title Screen'
--     }):action(function(e)
--         -- resetPlayer()
--         -- GameState.state = GameState.MAIN_MENU
--         destroyGameOverMenu()
--         -- initMainMenu()
--     end))
-- end
-- function initGameOverMenu()
--     ui.setDefaultFont(Fonts.proggySquare)
--     panel = initPanel()
--     ui:add(panel)
-- end
-- function destroyGameOverMenu()
--     if ui and panel then
--         ui.remove(panel)
--     end
-- end
local mainMenuPanel
local function initPanel()
    -- iNIT MAIN MENU PANEL
    local scoreLabel = Ui.label({
        text = "Your Final Score: " .. player.score
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
        }):rowspanAt(1, 1):rowspanAt(2, 1):rowspanAt(3, 1):addAt(1, 1, scoreLabel):addAt(2, 1, Ui.button({
            text = 'Restart'
        }):action(function(e)
            -- GameStart:gameStart()

            TEsound.play(sounds.click, "static")
            GameStart:restart()
            GameState.state = GameState.GAMEPLAY
            destroyGameOverMenu()
            initGameInterface()
        end)) -- QUIT BUTTON
        :addAt(3, 1, Ui.button({
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
