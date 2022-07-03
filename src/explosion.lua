local Entity = require('src.entity')
local Explosion = Entity:extend()

function Explosion:new(x, y, image)
  Explosion.super.new(self, x, y, image, 0, 64, 30, 30)
end

return Explosion
