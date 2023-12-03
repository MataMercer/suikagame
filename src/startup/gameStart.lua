local GameStart = {}

local function initGlobals()
    GameStart.data = {} -- save data, will be loaded after game begins

    GameStart.MAIN_MENU = 0
    GameStart.GAMEPLAY = 1
    GameStart.PAUSE_MENU = 2
    GameStart.GAME_OVER = 3

    GameStart.gamestate = 0
    GameStart.globalStun = 0
end

local function setScale(input)
    local GAME_SCALE = 1.6
    local rez = 1080
    GameStart.scale = (GAME_SCALE / rez) * GameStart.windowHeight

    if GameStart.vertical then
        GameStart.scale = (GAME_SCALE / rez) * GameStart.windowHeight
    end

    if _G.cam then
        cam:zoomTo(GameStart.scale)
    end
end

local function setWindowSize(full, width, height)
    if full then
        GameStart.fullscreen = true
        love.window.setFullscreen(true)
        GameStart.windowWidth = love.graphics.getWidth()
        GameStart.windowHeight = love.graphics.getHeight()
    else
        GameStart.fullscreen = false
        if width == nil or height == nil then
            GameStart.windowWidth = 1920
            GameStart.windowHeight = 1080
        else
            GameStart.windowWidth = width
            GameStart.windowHeight = height
        end
        love.window.setMode(GameStart.windowWidth, GameStart.windowHeight, {
            resizable = not testWindow
        })
    end
end

function GameStart:gameStart()
    math.randomseed(os.time())
    -- love.graphics.setBackgroundColor(26 / 255, 26 / 255, 26 / 255)

    -- Initialize all global variables for the game
    initGlobals()

    -- Make pixels scale!
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- 3 parameters: fullscreen, width, height
    -- width and height are ignored if fullscreen is true
    self.fullscreen = false
    self.testWindow = false
    self.vertical = false
    setWindowSize(self.fullscreen, 1920, 1080)

    if self.vertical then
        self.fullscreen = false
        testWindow = true
        setWindowSize(self.fullscreen, 1360, 1920)
    end

    -- The game's graphics scale up, this method finds the right ratio
    setScale()

    _G.vector = require "lib/hump/vector"
    _G.flux = require "lib/flux"
    require "lib/tesound"
    require("lib/show")
    _G.anim8 = require("lib/anim8/anim8")
    _G.sti = require("lib/Simple-Tiled-Implementation/sti")

    local windfield = require("lib/windfield/windfield")
    _G.world = windfield.newWorld(0, 2000, false)
    world:setQueryDebugDrawing(true)

    -- This second world is for particles, and has downward gravity
    _G.particleWorld = windfield.newWorld(0, 250, false)
    particleWorld:setQueryDebugDrawing(true)

    require("src/startup/require")
    requireAll()

end

local function reinitSize()
    -- Reinitialize everything
    GameStart.windowWidth = love.graphics.getWidth()
    GameStart.windowHeight = love.graphics.getHeight()
    setScale()
    -- pause:init()
    initFonts()
end

function GameStart:checkWindowSize()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    if width ~= self.windowWidth or self.height ~= self.windowHeight then
        reinitSize()
    end
end

return GameStart
