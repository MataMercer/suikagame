local GameStart = {}

local function initGlobals()
    GameStart.data = {} -- save data, will be loaded after game begins
    _G.Entities = {}
    _G.Platforms = {}
    _G.Limiter = nil
    _G.Fruits = {}
    _G.Bounds = {
        x = 0,
        y = 0,
        width = 0,
        height = 0
    }
    _G.background = nil
end

local function setScale(input)
    local GAME_SCALE = 1
    local rez = 720
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
            GameStart.windowWidth = 1280
            GameStart.windowHeight = 720
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
    setWindowSize(self.fullscreen, 1600, 1080)

    if self.vertical then
        self.fullscreen = false
        testWindow = true
        setWindowSize(self.fullscreen, 800, 600)
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
    world:setQueryDebugDrawing(false)

    -- This second world is for particles, and has downward gravity
    _G.particleWorld = windfield.newWorld(0, 250, false)
    particleWorld:setQueryDebugDrawing(true)

    _G.comboManager = ComboManager:new()

    createCollisionClasses()
    initPlayer()
    createNewSave()
    saveData = {}
    saveData.currentLevel = "basemap"
    if love.filesystem.getInfo("data.lua") then
        local data = love.filesystem.load("data.lua")
        data()
    end

    loadMap(saveData.currentLevel)
end

function GameStart:restart()
    resetPlayer()
    for i, p in ipairs(Fruits) do
        p:destroy()
    end
    for i, p in ipairs(Platforms) do
        p:destroy()
    end

    GameStart.data = {} -- save data, will be loaded after game begins
    _G.Entities = {}
    _G.Platforms = {}
    _G.Limiter = nil
    _G.Fruits = {}

    loadMap(saveData.currentLevel)
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
