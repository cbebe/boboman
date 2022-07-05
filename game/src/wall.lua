local Entity = require 'src.entity'
local Wall = Entity:extend()

function Wall:new(x, y, image)
  Wall.super.new(self, x, y, image, 32, 0, 32, 32)
  self.isWall = true
end

return Wall
