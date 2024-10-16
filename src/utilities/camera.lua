Camera = require "lib/hump/camera"
cam = Camera(0, 0, scale)
cam.smoother = Camera.smooth.damped(4)

function cam:update(dt)
    local camX, camY = player:getPosition()
    -- This section prevents the camera from viewing outside the background
    -- First, get width/height of the game window, divided by the game scale
    local w = love.graphics.getWidth() / GameStart.scale
    local h = love.graphics.getHeight() / GameStart.scale

    -- Get width/height of background
    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    cam:lockPosition(w / 2, mapH / 2)

    -- cam.x and cam.y keep track of where the camera is located
    -- the lookAt value may be moved if a screenshake is happening, so these
    -- values know where the camera should be, regardless of lookAt
    cam.x, cam.y = cam:position()
end
