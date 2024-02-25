Actor = {
    name = nil,
    spawnX = 0,
    spawnY = 0,
    animations = {},
    curAnim = nil,
    physics = nil,
    direction = 1,
    rotation = nil,
    tags = {},
    state = "idle",

    hp = 1,
    maxHp = 1,
    mp = 1,
    maxMp = 1,
    attackSpeed = 1,

    ui = {}
}

function Actor:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Actor:is(tag)
    return self.tags[tag] == true
end

function Actor:kill()
    self.hp = 0
end

function Actor:isDead()
    if self.hp == nil then
        return false
    end
    return self.hp <= 0
end

function Actor:update()
end

function Actor:draw()

end

_G.actors = {}
function actors:update(dt)
    for i = #self, 1, -1 do
        local a = self[i]
        a:update(dt)
        if a:isDead() then
            a.physics:destroy()
            util.del(actors, i)
        end
    end
end

function actors:draw()
    for i, a in ipairs(self) do
        a:draw()
    end
end
