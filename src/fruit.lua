projectiles = {}

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

    projectile:setFriction(0.0001)
    projectile:setRestitution(0.1)
    projectile.speed = 400
    projectile.dead = false
    projectile.direction = player.direction
    projectile.animation = animations.projectile
    projectile.rotation = nil

    table.insert(projectiles, projectile)
end

function updateFruit(dt)
    for i = #projectiles, 1, -1 do
        local p = projectiles[i]

        if p:enter("Enemy") then
            local collider = p:getEnterCollisionData("Enemy").collider
            local enemy = collider.parent
            print(collider)
            enemy:hit(player.getAttackDamage(), "hit")
            p.dead = true
        end

        if p:enter("Projectile") then

            local collider = p:getEnterCollisionData("Projectile").collider
            local cx, cy = collider:getPosition()
            local px, py = p:getPosition()
            if collider:getRadius() == p:getRadius() and p.dead == false and py > cy and collider.fruitIndex <
                #fruitTypes then
                print(string.format("fruit merged %d into %d", p.fruitIndex, collider.fruitIndex))
                spawnFruit(cx, cy, p.direction, collider.fruitIndex + 1)
                collider.dead = true
                p.dead = true
            end
        end
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

function drawFruit()
    for i, p in ipairs(projectiles) do
        local ax, ay = p:getPosition()
        -- local sprW = sprites.projectile:getWidth()
        -- local sprH = sprites.projectile:getHeight()

        -- p.animation:draw(sprites.projectile, ax, ay, p.rotation, p.direction, 1, sprW / 2, sprH / 2)

        love.graphics.setColor(love.math.colorFromBytes(0, 0, 0))
        love.graphics.circle("line", ax, ay, p:getRadius(), 17)

        love.graphics.setColor(love.math
                                   .colorFromBytes(p.fruitType.color[1], p.fruitType.color[2], p.fruitType.color[3]))
        love.graphics.circle("fill", ax, ay, p:getRadius(), 17)

        love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
    end
end
