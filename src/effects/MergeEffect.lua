_G.MergeEffects = {}
function SpawnMergeEffect(x, y, scale, color)
    local amountOfParticles = 20
    local spawnRange = 10


    for i = 1, amountOfParticles, 1 do
        local randX = math.random(x - spawnRange, x + spawnRange)
        local randY = math.random(y - spawnRange, y + spawnRange)

        local randScale = math.random(scale, scale * 2)
        -- local randScale = scale + scale / util.distanceBetween(randX, randY, x, y)
        local me = particleWorld:newRectangleCollider(randX, randY, randScale, randScale, {
            collision_class = "Particle"
        })
        me.scale = randScale
        me.timeDuration = 2
        me.timeElapsed = 0
        me.dead = false
        me.color = color
        me.alpha = 255
        me:setFixedRotation(false)

        local explosiveForce = 6
        local randVecX, randVecY = math.random(-1, 1) * explosiveForce, math.random(-1, 1) * explosiveForce
        me:applyLinearImpulse(randVecX, randVecY)
        me:applyAngularImpulse(4)
        table.insert(MergeEffects, me)

        TEsound.play(sounds.merge, "static")
        flux.to(me, 1.5, { alpha = 1 }):delay(1)
    end
end

function UpdateMergeEffects(dt)
    for i, me in ipairs(MergeEffects) do
        if me.dead == false and me.timeElapsed > me.timeDuration then
            me.dead = true
        else
            me.timeElapsed = me.timeElapsed + dt
        end
    end

    local i = #MergeEffects
    while i > 0 do
        if MergeEffects[i].dead then
            MergeEffects[i]:destroy()
            table.remove(MergeEffects, i)
        end
        i = i - 1
    end
end

function DrawMergeEffects()
    for index, me in ipairs(MergeEffects) do
        local x, y = me:getPosition()
        local r, g, b = me.color[1], me.color[2], me.color[3]
        LgUtil.setColor(r, g, b, me.alpha)

        -- love.graphics.rectangle("fill", x, y, me.scale, me.scale)

        sprites.mergeParticle:setFilter("nearest", "nearest")
        love.graphics.draw(sprites.mergeParticle, x, y, 0, me.scale / 6, me.scale / 6)
        LgUtil.resetColor()
    end
end
