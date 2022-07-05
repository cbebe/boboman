local Entity = require 'src.entity'
local Explosion = Entity:extend()

function Explosion:new(x, y, image)
  Explosion.super.new(self, x, y, image, 0, 64, 30, 30)
  self.isExplosion = true
  self.timer = 1
end

function Explosion:update(dt)
  Explosion.super.update(self, dt)
  self.timer = self.timer - dt
  if self.timer <= 0 then
    world:remove(self)
  end
end

return Explosion
