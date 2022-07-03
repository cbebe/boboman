local Object = require('libs.classic')
local Entity = Object:extend()

function Entity:new(x, y, image, qx, qy, qw, qh)
  self.x = x
  self.y = y
  self.image = image
  self.quad = love.graphics.newQuad(qx, qy, qw, qh, image:getWidth(), image:getHeight())
  self.width = qw
  self.height = qh
end

function Entity:draw()
  love.graphics.draw(self.image, self.quad, self.x, self.y)
end

function Entity:update(_)
end

return Entity
