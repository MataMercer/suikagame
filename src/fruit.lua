local Combo = require("src.mechanics.ComboManager")
_G.enableFruitMerging = true
_G.FruitCounter = 0
_G.FruitSpawnPoints = {}

local function preprocessFruitPolygonVertices()
    local polygonLimit = 8
    for _, f in ipairs(FruitTypes) do
        local spriteImageData = love.image.newImageData(f.spritePath)
        if f.shape == "polygon" then
            local absolutePoints = findPolygonMaskFromImage(spriteImageData, polygonLimit)
            f.scaleTarget = findScaleTargetFromRadius(f.radius, absolutePoints)
            f.polygonVertices = getSpriteVerts(absolutePoints, f.scaleTarget)
            f.absoluteCentroid = findCentroidPoint(absolutePoints)
        end

        f.color = findMostOccurringColor(spriteImageData)
    end
end
preprocessFruitPolygonVertices()



function spawnFruit(x, y, direction, fruitIndex)
    local throwPosX = x
    local throwPosY = y

    local fruitType = FruitTypes[fruitIndex]

    if throwPosX > Bounds.x + Bounds.width then
        throwPosX = Bounds.x + Bounds.width
    end
    if throwPosX < Bounds.x then
        throwPosX = Bounds.x
    end
    if throwPosY > Bounds.y + Bounds.height then
        throwPosY = Bounds.y + Bounds.height
    end

    local fruit
    if fruitType.shape == "circle" then
        fruit = world:newCircleCollider(throwPosX, throwPosY, fruitType.radius, {
            collision_class = "Projectile"
        })
    elseif fruitType.shape == "polygon" then
        local verts = fruitType.polygonVertices
        local coords = flattenCoordList(verts)
        fruit = world:newPolygonCollider(coords, {
            collision_class = "Projectile"
        })
        local centroid = findCentroidPoint(unflattenCoordList({ fruit:getPoints() }))
        local cx, cy = centroid.x, centroid.y
        fruit:setPosition(throwPosX - cx, throwPosY - cy)
    end

    fruit.fruitType = fruitType
    fruit.fruitIndex = fruitIndex --for fruit type

    fruit:setFriction(0)
    fruit:setRestitution(0)
    fruit:setFixedRotation(false)
    fruit:setBullet(false) -- DONT SET TO TRUE. bullet will shoot fruit out of bounds.

    fruit.speed = 400
    fruit.dead = false
    fruit.direction = player.direction

    fruit.spriteGrid = anim8.newGrid(64, 64, sprites.cherrySheet:getWidth(), sprites.cherrySheet:getHeight())
    fruit.animations = {}
    fruit.animations.idle = anim8.newAnimation(fruit.spriteGrid('1-1', 1), 0.1)
    fruit.anim = fruit.animations.idle
    FruitCounter = FruitCounter + 1
    fruit.id = FruitCounter
    fruit.rotation = nil

    fruit:setPreSolve(function(collider1, collider2, contact)
        local f1 = collider1.fruitType
        local f2 = collider2.fruitType

        if not (f1 and f2 and f1.radius == f2.radius and collider1.dead == false and collider2.dead == false) then
            return
        end

        local c2x, c2y = collider2:getPosition()
        local c1x, c1y = collider1:getPosition()

        local spawnX, spawnY = c2x, c2y
        if f1.shape == "polygon" then
            local centroid = findCentroidPoint(unflattenCoordList({ collider1:getPoints() }))
            local centroidx, centroidy = centroid.x, centroid.y

            local angle = collider2:getAngle()
            local rotatedx = centroidx * math.cos(angle) - centroidy * math.sin(angle)
            local rotatedy = centroidy * math.cos(angle) + centroidx * math.sin(angle)
            spawnX, spawnY = spawnX + rotatedx, spawnY + rotatedy
        end


        if collider2.fruitIndex + 1 < #FruitTypes then
            table.insert(FruitSpawnPoints,
                { x = spawnX, y = spawnY, direction = collider2.direction, fruitIndex = collider2.fruitIndex + 1 })
        end
        setScore(player.score + collider2.fruitType.radius)
        collider2.dead = true
        collider1.dead = true
        SpawnMergeEffect(c1x, c1y, 5, collider1.fruitType.color)
        comboManager:check(spawnX, spawnY)

        -- print(string.format("%d merged with %d ", collider2.id, collider1.id))
    end)

    table.insert(Fruits, fruit)
end

function updateFruit(dt)
    for index, spawn in ipairs(FruitSpawnPoints) do
        spawnFruit(spawn.x, spawn.y, spawn.direction, spawn.fruitIndex)
    end
    FruitSpawnPoints = {}

    local resetLimit = true
    for i = #Fruits, 1, -1 do
        local p = Fruits[i]
        local px, py = p:getPosition()

        -- Limiter Logic
        local lx, ly = Limiter:getPosition()
        local fruitTopEdge = py - p:getRadius()
        local limiterBottomEdge = ly + Limiter.height / 2

        if p.fruitType.shape == "polygon" then
            local vertices = unflattenCoordList({ p:getPoints() })
            for _, v in ipairs(vertices) do
                if v.y + py < limiterBottomEdge then
                    Limiter.warningActive = true
                    resetLimit = false
                end
            end
        else
            if fruitTopEdge < limiterBottomEdge then
                Limiter.warningActive = true
                resetLimit = false
            end
        end
        p.anim:update(dt)
    end

    -- more limiter Logic
    if resetLimit then
        Limiter.warningActive = false
    end

    local i = #Fruits
    while i > 0 do
        if Fruits[i].dead then
            Fruits[i]:destroy()
            table.remove(Fruits, i)
        end
        i = i - 1
    end
end

function drawFruit()
    for i, p in ipairs(Fruits) do
        local ax, ay = p:getPosition()
        local radius = p.fruitType.radius

        LgUtil.resetColor()
        -- love.graphics.setColor(love.math
        --    .colorFromBytes(p.fruitType.color[1], p.fruitType.color[2], p.fruitType.color[3]))

        local spriteWidth = 64
        local scale = (radius * 2) / spriteWidth
        if p.fruitType.shape == "polygon" then
            -- scale = radius / findCircumscribedCircleRadius(unflattenCoordList({p:getPoints()}))
            -- print(scale)
            scale = p.fruitType.scaleTarget

            -- love.graphics.circle("fill", ax, ay, 5, 5) -- show center
            local centroid = findCentroidPoint(unflattenCoordList({ p:getPoints() }))
            local centroidx, centroidy = centroid.x, centroid.y
            -- local centroidx, centroidy = p:getLocalCenter()

            -- love.graphics.circle("fill", centroidx + ax, centroidy + ay, 3, 10) -- show center

            local angle = p:getAngle()
            local rotatedx = centroidx * math.cos(angle) - centroidy * math.sin(angle)
            local rotatedy = centroidy * math.cos(angle) + centroidx * math.sin(angle)

            love.graphics.circle("fill", rotatedx + ax, rotatedy + ay, 3, 10) -- show center

            p.fruitType.spriteSheet:setFilter("nearest", "nearest")
            p.anim:draw(p.fruitType.spriteSheet, rotatedx + ax, rotatedy + ay, p:getAngle(), scale, scale,
                p.fruitType.absoluteCentroid.x, p.fruitType.absoluteCentroid.y)

            -- love.graphics.setColor(love.math.colorFromBytes(0, 0, 0))
            -- love.graphics.polygon("line", flattenCoordList(util.getRelativePolygonVertices(p)))
            -- love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
        else
            p.fruitType.spriteSheet:setFilter("nearest", "nearest")
            p.anim:draw(p.fruitType.spriteSheet, ax, ay, p:getAngle(), p.direction * scale, scale, 32, 32)

            -- love.graphics.setColor(love.math.colorFromBytes(0, 0, 0))
            -- love.graphics.circle("line", ax, ay, radius, 30)

            -- love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
        end
        -- love.graphics.circle("fill", ax, ay, 2, 6) -- show center
        -- love.graphics.circle("fill", ax, ay, p:getRadius(), 30)
        LgUtil.resetColor()

        -- draw Bounds
        -- love.graphics.circle("fill", Bounds.x, Bounds.y, 3, 10)
        -- love.graphics.circle("fill", Bounds.x + Bounds.width, Bounds.y + Bounds.height, 3, 10)
    end
end
