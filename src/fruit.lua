local scale = 5
local polygonLimit = 8

_G.FruitTypes = {{
    name = "cherry",
    shape = "circle",
    radius = 2 * scale,
    spriteSheet = sprites.cherrySheet,
    color = {199, 21, 133}
}, {
    name = "strawberry",
    -- radius = 4 * scale,
    shape = "polygon",
    polygonVertices = findPolygonMaskFromImage("sprites/strawberry-Sheet.png", polygonLimit),
    spriteSheet = sprites.strawberrySheet,
    color = {245, 66, 90}
}, {
    name = "grape",
    shape = "circle",
    radius = 6 * scale,
    spriteSheet = sprites.cherrySheet,
    color = {128, 0, 128}
}, {
    name = "Dekopon",
    shape = "circle",
    radius = 8 * scale,
    spriteSheet = sprites.cherrySheet,
    color = {235, 122, 52}
}, {
    name = "Orange",
    shape = "circle",
    radius = 10 * scale,
    spriteSheet = sprites.cherrySheet,
    color = {255, 94, 0}
}, {
    name = "Apple",
    shape = "circle",
    radius = 12 * scale,
    spriteSheet = sprites.cherrySheet,
    color = {255, 0, 0}
}, {
    name = "Pear",
    shape = "circle",
    radius = 14 * scale,
    spriteSheet = sprites.cherrySheet,
    color = {252, 248, 3}
}, {
    name = "Peach",
    shape = "circle",
    radius = 16 * scale,
    spriteSheet = sprites.cherrySheet,
    color = {255, 110, 219}
}, {
    name = "Pineapple",
    shape = "circle",
    radius = 18 * scale,
    spriteSheet = sprites.cherrySheet,
    color = {235, 255, 51}
}, {
    name = "Melon",
    shape = "circle",
    radius = 20 * scale,
    spriteSheet = sprites.cherrySheet,
    color = {153, 255, 51}
}, {
    name = "Watermelon",
    shape = "circle",
    radius = 22 * scale,
    spriteSheet = sprites.cherrySheet,
    color = {4, 184, 37}
}}
function spawnFruit(x, y, direction, fruitIndex)

    local throwPosX = x + 10 * direction
    local throwPosY = y + 5

    local fruitType = FruitTypes[fruitIndex]

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
        fruit:setPosition(x, y)
    end

    fruit.fruitType = fruitType
    fruit.fruitIndex = fruitIndex

    fruit:setFriction(0.1002)
    fruit:setRestitution(0)
    fruit:setFixedRotation(false)
    fruit.speed = 400
    fruit.dead = false
    fruit.direction = player.direction

    fruit.spriteGrid = anim8.newGrid(64, 64, sprites.cherrySheet:getWidth(), sprites.cherrySheet:getHeight())
    fruit.animations = {}
    fruit.animations.idle = anim8.newAnimation(fruit.spriteGrid('1-1', 1), 0.1)
    fruit.anim = fruit.animations.idle

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
        if fruitTopEdge < limiterBottomEdge then
            Limiter.warningActive = true
            resetLimit = false
        end

        p.anim:update(dt)
        preciseCheckCollision(p)

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

-- We use this to check collisions because Windfield's collider :enter or :stay function isn't precise enough.
function preciseCheckCollision(fruit)
    for i, p in ipairs(Fruits) do

        local p1x, p1y = fruit:getPosition()
        local p2x, p2y = p:getPosition()
        if p.fruitType.shape == "circle" then
            local minDistance = fruit:getRadius() + p:getRadius()
            local distance = math.sqrt(math.pow(p1x - p2x, 2) + math.pow(p1y - p2y, 2))
            if distance <= minDistance and distance > 0 then
                local collider = p
                local cx, cy = collider:getPosition()
                if collider:getRadius() == fruit:getRadius() and fruit.dead == false and p1y > p2y and
                    collider.fruitIndex < #FruitTypes then
                    print(string.format("fruit merged %d into %d", fruit.fruitIndex, collider.fruitIndex))
                    setScore(player.score + fruit:getRadius())
                    spawnFruit(cx, cy, fruit.direction, collider.fruitIndex + 1)
                    collider.dead = true
                    fruit.dead = true
                    break
                end
            end
        end

    end
end

function drawFruit()
    for i, p in ipairs(Fruits) do
        local ax, ay = p:getPosition()
        local radius = p:getRadius()
        love.graphics.setColor(love.math.colorFromBytes(0, 0, 0))
        love.graphics.circle("line", ax, ay, radius, 30)

        love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
        -- love.graphics.setColor(love.math
        --    .colorFromBytes(p.fruitType.color[1], p.fruitType.color[2], p.fruitType.color[3]))

        local spriteWidth = 64
        local scale = (radius * 2) / spriteWidth
        if p.fruitType.name == "strawberry" then
            p.anim:draw(p.fruitType.spriteSheet, ax, ay, p:getAngle(), p.direction * 1, 1, 0, 0)
        else

            p.anim:draw(p.fruitType.spriteSheet, ax, ay, p:getAngle(), p.direction * scale, scale, 32, 32)
        end
        -- love.graphics.circle("fill", ax, ay, 5, 5) -- show center
        -- love.graphics.circle("fill", ax, ay, p:getRadius(), 30)
        love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
    end
end
