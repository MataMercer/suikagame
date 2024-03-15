function requireAll()

    _G.urutora = require('lib/urutora/urutora')
    require("src/startup/collisionClasses")

    -- Load assets, resources, data
    require("src/startup/resources")
    require("src/startup/GameState")
    require("src/startup/data")
    require("src/utilities/camera")
    require("src/utilities/destroyAll")
    _G.util = require("src/utilities/util")
    require("../PolygonMasker/PolygonMask")
    require("src/actors/Actor")
    require("src/actors/player")
    require("src/skills/FruitThrow")
    require("src/fruit")
    require("src/Limiter")
    require("src/ui/Fonts")
    require("src/ui/GameInterface")
    require("src/ui/GameOverMenu")
    require("src/ui/MainMenu")
    _G.update = require("src/update")
    _G.draw = require("src/draw")
    require("src/levels/loadMap")

end
