_G.enableFruitMerging = true
_G.FruitCounter = 0

_G.ComboTimeLimit = 2
_G.ComboTimeElapsed = 0
_G.Combos = {}

local function preprocessFruitPolygonVertices()
    local polygonLimit = 8
    for i, f in ipairs(FruitTypes) do
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

local function ComboCheck(x, y)
    if ComboTimeElapsed <= ComboTimeLimit then
        local c = {
            x = x,
            y = y,
            alpha = 255
        }

        flux.to(c, 1, { alpha = 1 }):delay(0.2)
        table.insert(Combos, c)
    else
        Combos = {}
        ComboTimeElapsed = 0
    end
end

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
        -- for i, v in ipairs(verts) do
        --     verts[i] = {
        --         x = v.x - x,
        --         y = v.y - y
        --     }
        -- end
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

    table.insert(Fruits, fruit)
end

function updateFruit(dt)
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
        if enableFruitMerging then
            preciseCheckCollision(p)

            if p.fruitType.shape == "polygon" and (p:enter("Projectile") or p:stay("Projectile")) then
                local collider = p:getEnterCollisionData("Projectile").collider
                if collider and collider.dead == false then
                    local cx, cy = collider:getPosition()
                    local px, py = p:getPosition()
                    if collider.fruitType.name == p.fruitType.name and p.dead == false and py > cy then
                        local centroid = findCentroidPoint(unflattenCoordList({ collider:getPoints() }))
                        local centroidx, centroidy = centroid.x, centroid.y

                        local angle = p:getAngle()
                        local rotatedx = centroidx * math.cos(angle) - centroidy * math.sin(angle)
                        local rotatedy = centroidy * math.cos(angle) + centroidx * math.sin(angle)

                        --Watermelons disappear when merged.
                        if collider.fruitIndex + 1 < #FruitTypes then
                            spawnFruit(cx + rotatedx, cy + rotatedy, p.direction, collider.fruitIndex + 1)
                        end
                        setScore(player.score + p.fruitType.radius)
                        collider.dead = true
                        p.dead = true
                        print(string.format("%d merged with %d ", collider.id, p.id))
                        SpawnMergeEffect(px, py, 5, p.fruitType.color)
                        ComboCheck(cx + rotatedx, cy + rotatedy)
                    end
                end
            end
        end
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

    --combo logic
    ComboTimeElapsed = ComboTimeElapsed + dt
end

-- We use this to check collisions because Windfield's collider :enter or :stay function isn't precise enough.
function preciseCheckCollision(fruit)
    for i, p in ipairs(Fruits) do
        local p1x, p1y = fruit:getPosition()
        local p2x, p2y = p:getPosition()
        if p.fruitType.shape == "circle" then
            local minDistance = fruit:getRadius() + p:getRadius()
            local distance = math.sqrt(math.pow(p1x - p2x, 2) + math.pow(p1y - p2y, 2)) - 5
            if distance <= minDistance and distance > 0 then
                local collider = p
                local cx, cy = collider:getPosition()
                if collider:getRadius() == fruit:getRadius() and fruit.dead == false and p1y > p2y and
                    collider.fruitIndex < #FruitTypes then
                    setScore(player.score + fruit:getRadius())
                    spawnFruit(cx, cy, fruit.direction, collider.fruitIndex + 1)
                    collider.dead = true
                    fruit.dead = true
                    local pitch = .5 + math.random() * .5

                    SpawnMergeEffect(cx, cy, 5, collider.fruitType.color)
                    ComboCheck(cx, cy)
                    break
                end
            end
        elseif p.fruitType.shape == "polygon" and fruit.fruitType.polygonVertices then
            -- local fruitRelativePoints = util.getRelativePolygonVertices(fruit)
            -- local pRelativePoints = util.getRelativePolygonVertices(p)

            -- if p1x ~= p2x and p1y ~= p2y and util.preciseCheckPolygonCollision(fruitRelativePoints, pRelativePoints) then
            --     if p.fruitType.radius == fruit.fruitType.radius and fruit.dead == false and p1y > p2y and p.fruitIndex <
            --         #FruitTypes then
            --         setScore(player.score + fruit.fruitType.radius)

            --         local centroid = findCentroidPoint(unflattenCoordList({p:getPoints()}))
            --         spawnFruit(p1x, p1y, p.direction, p.fruitIndex + 1)
            --         p.dead = true
            --         fruit.dead = true
            --         break
            --     end

            -- end
        end
    end
end

function drawFruit()
    for i, p in ipairs(Fruits) do
        local ax, ay = p:getPosition()
        local radius = p.fruitType.radius
        -- love.graphics.setColor(love.math.colorFromBytes(0, 0, 0))

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



    for index, c in ipairs(Combos) do
        LgUtil.setColor(255, 255, 255, c.alpha)
        love.graphics.setFont(Fonts.proggySquare, 0.1)
        local scale = math.pow(index / 2, 1 / 3)
        love.graphics.print(string.format("%d COMBO", index), c.x, c.y, 0, scale, scale)
    end
end
