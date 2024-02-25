_G.player = {}
function initPlayer()
    playerStartX = 100
    playerStartY = 0
    -- octagon shape

    player = world:newBSGRectangleCollider(playerStartX, playerStartY, 20, 50, 3, {
        collision_class = "Player"
    })
    player.spriteGrid = anim8.newGrid(64, 64, sprites.playerSheet:getWidth(), sprites.playerSheet:getHeight())
    player.animations = {}
    player.animations.idle = anim8.newAnimation(player.spriteGrid('1-1', 1), 0.1)
    -- player.animations.run = anim8.newAnimation(player.spriteGrid('1-6', 1), 0.1)
    -- player.animations.drop = anim8.newAnimation(player.spriteGrid('1-2', 3), 0.1)

    player:setFixedRotation(true)
    player.height = 100
    player.speed = 540
    player.anim = player.animations.idle
    player.isMoving = false
    player.isAttacking = false
    player.direction = 1
    player.grounded = true
    player.projectileCooldownMax = 0.35
    player.projectileCooldown = player.projectileCooldownMax
    player.maxHealth = 100
    player.health = player.maxHealth
    player.attackMin = 4
    player.attackMax = 8
    player.isCastingSkill = false
    player.isColliding = true
    player.heldFruit = love.math.random(1, 5)
    player.score = 0

    player.tweenX = 0
    player.tweenY = 0

end

-- player:setPreSolve(function(collider_1, collider_2, contact)
--     if collider_1.collision_class == 'Player' and collider_2.collision_class == 'Platform' then
--         local px, py = collider_1:getPosition()
--         local pw, ph = 20, 40
--         local tx, ty = collider_2:getPosition()
--         local tw, th = 100, 20
--         if py + ph / 2 > ty - th / 2 then
--             contact:setEnabled(false)
--         end
--     end
--     if player.isColliding == false then

--         contact:setEnabled(player.isColliding)
--     end
-- end)

function love.keypressed(key)
    love.keyboard.setKeyRepeat(false)
    if key == 'z' then
        if player.isCastingSkill == false and player.isMoving == false then
            -- player.isMoving = false
            spawnFruitThrow(player)
            player.anim = player.animations.idle
            player.isCastingSkill = true
            player.heldFruit = love.math.random(1, 5)
        end
    end

end
function playerUpdate(dt)
    if player.body then

        player:setY(20)

        player.isMoving = false
        local walkForce = 300
        if player.grounded then
            if love.keyboard.isDown('right') and player.isCastingSkill == false then
                -- player:setX(px + player.speed * dt)
                player.isMoving = true
                player.direction = 1
                -- player:applyLinearImpulse(walkForce * player.direction, 0)
                player:setX(player:getX() + player.speed * dt)
                player.anim = player.animations.run
            end
            if love.keyboard.isDown('left') and player.isCastingSkill == false then
                player:setX(player:getX() - player.speed * dt)
                player.isMoving = true
                player.direction = -1
                -- player:applyLinearImpulse(walkForce * player.direction, 0)
                player.anim = player.animations.run
            end
        end
        if player.grounded == false then
            if love.keyboard.isDown('right') and player.isCastingSkill == false then
                -- player:setX(px + player.speed * dt)
                player.direction = 1
                player.isMoving = false
                player:applyLinearImpulse(walkForce * player.direction * 0.025, 0)
            end
            if love.keyboard.isDown('left') and player.isCastingSkill == false then
                -- player:setX(px - player.speed * dt)
                player.direction = -1
                player.isMoving = false
                player:applyLinearImpulse(walkForce * player.direction * 0.025, 0)
            end
        end
        if love.keyboard.isDown('right') then
            player.direction = 1
            player.isAttacking = false
        end
        if love.keyboard.isDown('left') then
            player.direction = -1
            player.isAttacking = false
        end
        if love.keyboard.isDown('z') then

        end

        if player:enter('Danger') then
            killPlayer()
        end
        if player:enter('Enemy') then
            player:takeDamage()
        end
    end

    player.anim = player.animations.idle
    player.anim:update(dt)
end

function playerDraw()
    local px, py = player:getPosition()
    love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
    player.anim:draw(sprites.playerSheet, px, py, nil, player.direction, 1, 25, 35)

    local p = _G.fruitTypes[player.heldFruit]
    px = px + (player.direction * 20)
    py = py + 30
    love.graphics.setColor(love.math.colorFromBytes(0, 0, 0))
    love.graphics.circle("line", px, py, p.radius, 17)

    love.graphics.setColor(love.math.colorFromBytes(p.color[1], p.color[2], p.color[3]))
    love.graphics.circle("fill", px, py, p.radius, 17)

    love.graphics.setColor(love.math.colorFromBytes(255, 255, 255))
end

function player:takeDamage()
    local damage = math.random(3, 5)
    player.health = player.health - damage
    if player.health <= 0 then
        killPlayer()
    end
end

function player.getAttackDamage()
    return math.random(player.attackMin, player.attackMax)
end

function resetPlayer()
    player.health = player.maxHealth
    player.score = 0
end

function killPlayer()
    resetPlayer()
    player:setPosition(playerStartX, playerStartY)
end

function setScore(score)
    player.score = score
    setScoreLabel(player.score)
end

