local mainMenuPanel
local function initPanel()
    -- INIT MAIN MENU PANEL
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
            -- bgColor = { 0.2, 0.2, 0.7, 1 },
            font = Fonts.robotoBold
        })
        :rowspanAt(1, 1)
        :rowspanAt(2, 1)
        :rowspanAt(3, 1)

        --Title
        :addAt(1, 1, Ui.image({
            image = sprites.title,
            x = 0,
            y = 0,
            w = 256,
            h = 64,
            keepAspectRatio = true
        }))


        -- Start Button
        :addAt(2, 1, Ui.button({
                text = 'Start Game',
            })
            :action(function(e)
                TEsound.play(sounds.click, "static")
                GameState.state = GameState.GAMEPLAY
                destroyMainMenu()
                initGameInterface()
            end))

        --Settings Button
        :addAt(3, 1, Ui.button({
                text = 'Settings'
            })
            :action(function(e)
                print("open settings")
            end))


        -- Quit Button
        :addAt(4, 1, Ui.button({
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
