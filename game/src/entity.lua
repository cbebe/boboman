local Object = require 'libs.classic'
local Entity = Object:extend()

local floor = math.floor

function Entity:new(x, y, image, qx, qy, qw, qh)
  self.x = x
  self.y = y
  self.image = image
  self.quad = love.graphics.newQuad(qx, qy, qw, qh, image:getWidth(), image:getHeight())
  self.width = qw
  self.height = qh
  world:add(self, self.x, self.y, self.width, self.height)
end

function Entity:getTile()
  local xTile = floor((self.x + self.width / 2) / 32)
  local yTile = floor((self.y + self.height / 2) / 32)
  return xTile, yTile
end

function Entity:draw()
  love.graphics.draw(self.image, self.quad, self.x, self.y)
end

function Entity:update(_) end

return Entity
