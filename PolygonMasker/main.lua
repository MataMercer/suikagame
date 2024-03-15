package.path = '../?.lua;' .. package.path
package.path = '../lib/png-lua/?.lua;' .. package.path

util = require('src/utilities/util')
local pngImage = require('lib/png-lua/png')
local rdpAlgo = require("Rdp")
-- local imgPath = '../sprites/strawberry-Sheet.png'
local imgPath = 'strawberry-Sheet.png'
local img = pngImage(imgPath, function()
end, true, false)

-- local foo = require('moduletest')
-- print(foo('foobar').derp)

print(string.format("Original Point Count: %d", #borderPoints))
borderPoints = orderPointsByAdjacency(borderPoints)
print(string.format("Ordered Point Count: %d", #borderPoints))
local rdp = require('../lib/LuaAlgorithms/RamerDouglasPeucker')
-- local filtered = rdpAlgo(borderPoints, 10)
local filtered = {}
local i = 100
local polygonLimit = 8
while i > 0 do
    filtered = rdp(borderPoints, i, true)
    if #filtered >= 8 then
        break
    end
    i = i - 1
end
borderPoints = filtered

print(string.format("Simplified Point Count: %d", #borderPoints))

-- START INIT WINDOW
_G.GameStart = {}
local function setScale(input)
    local GAME_SCALE = 1.6
    local rez = 1080
    GameStart.scale = (GAME_SCALE / rez) * GameStart.windowHeight

    if GameStart.vertical then
        GameStart.scale = (GAME_SCALE / rez) * GameStart.windowHeight
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

local function gameStart()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter("nearest", "nearest")
    GameStart.fullscreen = false
    GameStart.testWindow = false
    GameStart.vertical = false
    setWindowSize(GameStart.fullscreen, 1920, 1080)
    if GameStart.vertical then
        GameStart.fullscreen = false
        testWindow = true
        setWindowSize(GameStart.fullscreen, 1360, 1920)
    end
    setScale()
end

local function reinitSize()
    -- Reinitialize everything
    GameStart.windowWidth = love.graphics.getWidth()
    GameStart.windowHeight = love.graphics.getHeight()
    setScale()
end

function GameStart:checkWindowSize()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    if width ~= GameStart.windowWidth or GameStart.height ~= GameStart.windowHeight then
        reinitSize()
    end
end
-- END INIT WINDOW

function love.load()
    _G.drawableImage = love.graphics.newImage(imgPath)
end

function love.update()

end

function love.draw()
    local scale = 3
    love.graphics.draw(drawableImage, 0, 0, 0, scale, scale)
    if borderPoints then
        for i, p in ipairs(borderPoints) do
            love.graphics.circle("fill", p.x * scale, p.y * scale, 2)
        end
    end

end

