local progressBar, leftPanel, scoreLabel
local progressBarSpeed = 2

local function destroyGameInterface()
    if ui and leftPanel then
        ui:remove(leftPanel)
    end
end
local function initLeftPanel()
    progressBar = ui.progressBar({
        speed = 0,
        value = 1,
        direction = -1
    }):action(function(evt)
        if evt.type == 'full' then
            if limiter.warningActive then
                evt.target.speed = progressBarSpeed
            end
        elseif evt.type == 'empty' then
            destroyGameInterface()
            GameState.state = GameState.GAME_OVER
            initGameOverMenu()
        end
    end)

    scoreLabel = ui.label({
        text = "Score: " .. player.score
    })
    -- Init left panel
    local width = 400
    return ui.panel({
        x = 0,
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
    }):rowspanAt(1, 1):rowspanAt(2, 1):rowspanAt(3, 1) -- Warning time limit indicator.
    :addAt(1, 1, progressBar) -- Show score
    :addAt(2, 1, scoreLabel)

end

function initGameInterface()

    ui.setDefaultFont(Fonts.proggySquare)
    leftPanel = initLeftPanel()
    ui:add(leftPanel)
end

function cancelWarningBar()
    if progressBar then
        progressBar.visible = false
        progressBar.value = 1
        progressBar.speed = 0
    end
end

function showWarningBar()
    if progressBar and progressBar.value < limiter.visibleWarningThreshold then
        progressBar.visible = true
    end
end

function setScoreLabel(score)
    scoreLabel.text = "Score: " .. score
end
