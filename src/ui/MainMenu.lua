local mainMenuPanel
local function initPanel()
    -- INIT MAIN MENU PANEL
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
            -- bgColor = { 0.2, 0.2, 0.7, 1 },
            font = Fonts.robotoBold
        })
        :rowspanAt(1, 1, 3)
        :colspanAt(1, 1, 3)
        :rowspanAt(4, 1)
        :rowspanAt(5, 1)
        :rowspanAt(6, 1)

        --Title
        :addAt(1, 1, Ui.image({
            image = sprites.title,
            x = 0,
            y = 0,
            w = 256,
            h = 64,
            keepAspectRatio = true
        }))

        :addAt(4, 2, Ui.button({
                text = 'Start Game',
            })
            :action(function(e)
                TEsound.play(sounds.click, "static")
                GameState.state = GameState.GAMEPLAY
                destroyMainMenu()
                initGameInterface()
            end))

        :addAt(5, 2, Ui.button({
                text = 'Settings'
            })
            :action(function(e)
                print("open settings")
            end))


        :addAt(6, 2, Ui.button({
                text = 'Quit'
            })
            :action(function(e)
                TEsound.play(sounds.click, "static")
                love.event.quit()
            end))
end

function initMainMenu()
    Ui.setDefaultFont(Fonts.proggySquare)
    mainMenuPanel = initPanel()
    Ui:add(mainMenuPanel)
    Ui:setStyle(UiCustomStyle)
end

function destroyMainMenu()
    if Ui and mainMenuPanel then
        Ui:remove(mainMenuPanel)
    end
end
