fruitThrows = {}
function spawnFruitThrow(actor)
    if GameState.state ~= GameState.GAMEPLAY then
        return
    end
    local ax, ay = actor:getPosition()
    local shurikenThrow = {}
    shurikenThrow.x = ax
    shurikenThrow.y = ay
    shurikenThrow.direction = actor.direction
    shurikenThrow.spriteGrid = nil
    shurikenThrow.animation = nil
    shurikenThrow.duration = 0.2
    shurikenThrow.castingDelayDuration = 0
    shurikenThrow.timeElapsed = 0
    shurikenThrow.numberOfStarsThrown = 3
    shurikenThrow.frequency = (shurikenThrow.duration - shurikenThrow.castingDelayDuration) /
        shurikenThrow.numberOfStarsThrown
    shurikenThrow.timeSinceLastThrow = 0
    shurikenThrow.shurikens = {}
    shurikenThrow.actor = actor
    shurikenThrow.attackMultiplier = 1.25

    table.insert(fruitThrows, shurikenThrow)

    spawnFruit(ax, ay, actor.direction, actor.heldFruit)
end

function fruitThrows:update(dt)
    for i = #fruitThrows, 1, -1 do
        local s = fruitThrows[i]

        if s.animation then
            s.animation:update(dt)
        end

        s.timeElapsed = dt + s.timeElapsed
        if s.timeElapsed > s.castingDelayDuration then
            s.timeSinceLastThrow = dt + s.timeSinceLastThrow
        end
        if s.timeElapsed >= s.duration then
            s.actor.isCastingSkill = false
            table.remove(fruitThrows, i)
        end
    end
end

function fruitThrows.draw()

end
