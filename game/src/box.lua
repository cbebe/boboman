local Entity = require 'src.entity'
local Box = Entity:extend()

function Box:new(x, y, image)
  Box.super.new(self, x, y, image, 0, 0, 32, 32)
end

return Box
