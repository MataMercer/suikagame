function spawnLimiter(x, y, width, height)
    if width > 0 and height > 0 then
        local l = world:newRectangleCollider(x, y, width, height, {
            collision_class = "Limiter"
        })
        l:setType("static")
        l.height = height
        l.warningActive = false
        l.visibleWarningThreshold = 1
        -- l.warningTimeElapsed = 0
        -- l.warningTimeLimit = 1000
        -- l.alertThreshold = 0.2 * l.warningTimeLimit
        Limiter = l
    end
end

function updateLimiter(dt)
    if Ui then
        if Limiter.warningActive == false then
            cancelWarningBar()
        else
            showWarningBar()
        end
    end
end
