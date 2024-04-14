local modules = (...):gsub('%.[^%.]+$', '') .. '.'
local baseNode = require(modules .. 'baseNode')
local utils = require(modules .. 'utils')

local button = baseNode:extend('button')

local base_drawText = button.super.drawText
local base_drawBaseRectangle = button.super.drawBaseRectangle

function button:constructor()
  button.super.constructor(self)
  local layers = self.style.customLayers or {}
end

function button:draw()
  local layers = self.customLayers or self.style.customLayers or {}
  if layers.bgButton then
    local scaleY = self.h / layers.bgButton:getHeight()
    local scaleX = self.w / layers.bgButton:getWidth()
    utils.drawWithShader(self, layers.bgButton, self.x, self.y, { scaleX = scaleX, scaleY = scaleY })
  end
end

return button
