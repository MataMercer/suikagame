Npc = {}
function Npc:new(params)
    self.__index = self
    setmetatable(self, {
        __index = Actor
    })
    local newObj = Actor:new(params)
    setmetatable(newObj, self)
    return newObj
end

function _G.spawnNpc(x, y, type)
    x = x
    y = y - 256
    local npc = nil
    if type == "Luna" then
        -- init the npc for luna
    elseif type == "Mikhail" then
        -- init the npc for mikhail
    end
    npc.physics = world:newRectangleCollider(x, y, 128, 128, {
        collision_class = "Npc"
    })
    npc.physics:setFixedRotation(true)
    npc.physics.parent = npc

    util.add(actors, npc)
end

