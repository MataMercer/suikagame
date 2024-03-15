function spawnLimiter(x, y, width, height)
    if width > 0 and height > 0 then
        local l = world:newRectangleCollider(x, y, width, height, {
            collision_class = "Limiter"
        })
        l:setType("static")
        l.height = height
        l.warningActive = false
        l.visibleWarningThreshold = 0.75
        -- l.warningTimeElapsed = 0
        -- l.warningTimeLimit = 1000
        -- l.alertThreshold = 0.2 * l.warningTimeLimit
        Limiter = l
    end
end

function updateLimiter(dt)
    -- if limiter.warningTimeElapsed > 0 then
    --     print(limiter.warningTimeElapsed)
    -- end
    -- if limiter.warningTimeElapsed > limiter.warningTimeLimit then
    --     print("GAME OVER!")
    --     GameStart.gamestate = GameStart.GAME_OVER
    -- end
    if Ui then
        if Limiter.warningActive == false then
            cancelWarningBar()
        else
            showWarningBar()
        end

    end

end
