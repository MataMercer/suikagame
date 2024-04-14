function createCollisionClasses()
    world:addCollisionClass('Ignore', {
        ignores = {'Ignore'}
    })
    world:addCollisionClass('Platform', {
        ignores = {'Ignore'}
    })

    world:addCollisionClass('Player', {
        ignores = {'Ignore'}
    })
    world:addCollisionClass('Limiter', {
        ignores = {'Ignore', 'Player'}
    })
    world:addCollisionClass('Wall', {
        ignores = {'Ignore'}
    })
    world:addCollisionClass('Transition', {
        ignores = {'Ignore'}
    })
    world:addCollisionClass('Enemy', {
        ignores = {'Ignore', 'Player'}
    })
    world:addCollisionClass('Projectile', {
        ignores = {'Ignore', 'Enemy', 'Player', 'Transition', 'Limiter'}
    })
    particleWorld:addCollisionClass('Particle', {
        ignores = {'Particle'}
    })
end
