local scale = 5
_G.fruitTypes = {{
    name = "cherry",
    radius = 2 * scale,
    color = {199, 21, 133}
}, {
    name = "strawberry",
    radius = 4 * scale,
    color = {245, 66, 90}
}, {
    name = "grape",
    radius = 6 * scale,
    color = {128, 0, 128}
}, {
    name = "Dekopon",
    radius = 8 * scale,
    color = {235, 122, 52}
}, {
    name = "Orange",
    radius = 10 * scale,
    color = {255, 94, 0}
}, {
    name = "Apple",
    radius = 12 * scale,
    color = {255, 0, 0}
}, {
    name = "Pear",
    radius = 14 * scale,
    color = {252, 248, 3}
}, {
    name = "Peach",
    radius = 16 * scale,
    color = {255, 110, 219}
}, {
    name = "Pineapple",
    radius = 18 * scale,
    color = {235, 255, 51}
}, {
    name = "Melon",
    radius = 20 * scale,
    color = {153, 255, 51}
}, {
    name = "Watermelon",
    radius = 22 * scale,
    color = {4, 184, 37}
}}
function spawnFruit(x, y, direction, fruitIndex)

    local throwPosX = x + 10 * direction
    local throwPosY = y + 5

    local fruitType = fruitTypes[fruitIndex]
    local projectile = world:newCircleCollider(throwPosX, throwPosY, fruitType.radius, {
        collision_class = "Projectile"
    })
    projectile.fruitType = fruitType
    projectile.fruitIndex = fruitIndex

    projectile:setFriction(0.1002)
    projectile:setRestitution(0)
    projectile.speed = 400
    projectile.dead = false
    projectile.direction = player.direction
    projectile.animation = animations.projectile
    projectile.rotation = nil

    table.insert(projectiles, projectile)
end

function updateFruit(dt)
    local resetLimit = true
    for i = #projectiles, 1, -1 do
        local p = projectiles[i]
        local px, py = p:getPosition()

        -- Limiter Logic
        local lx, ly = limiter:getPosition()
        local fruitTopEdge = py - p:getRadius()
        local limiterBottomEdge = ly + limiter.height / 2
        if fruitTopEdge < limiterBottomEdge then
            limiter.warningActive = true
            resetLimit = false
        end

        preciseCheckCollision(p)
    end

    -- more limiter Logic
    if resetLimit then
        limiter.warningActive = false
    end

    local i = #projectiles
    while i > 0 do
        if projectiles[i].dead then
            projectiles[i]:destroy()
            table.remove(projectiles, i)
        end
        i = i - 1
    end
end

-- We use this to check collisions because Windfield's collider :enter or :stay function isn't precise enough.
function preciseCheckCollision(projectile)
    for i, p in ipairs(projectiles) do
        local minDistance = projectile:getRadius() + p:getRadius()
        local p1x, p1y = projectile:getPosition()
        local p2x, p2y = p:getPosition()
        local distance = math.sqrt(math.pow(p1x - p2x, 2) + math.pow(p1y - p2y, 2))
        if distance <= minDistance and distance > 0 then
            local collider = p
            local cx, cy = collider:getPosition()
            if collider:getRadius() == projectile:getRadius() and projectile.dead == false and p1y > p2y and
                collider.fruitIndex < #fruitTypes then
                print(string.format("fruit merged %d into %d", projectile.fruitIndex, collider.fruitIndex))
                setScore(player.score + projectile:getRadius())
                spawnFruit(cx, cy, projectile.direction, collider.fruitIndex + 1)
                collider.dead = true
                projectile.dead = true
                break
            end
        end
    end
end

function drawFruit()
    for i, p in ipairs(projectiles) do
        local ax, ay = p:getPosition()
        love.graphics.setColor(love.math.colorFromBytes(0, 0, 0))
        love.graphics.circle("line", ax, ay, p:getRadius(), 30)
        love.graphics.setColor(love.math
                                   .colorFromBytes(p.fruitType.color[1], p.fruitType.color[2], p.fruitType.color[3]))
        love.graphics.circle("fill", ax, ay, p:getRadius(), 30)
        love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
    end
end
