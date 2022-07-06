local Entity = require 'src.entity'
local Enemy = Entity:extend()

function Enemy:new(x, y, image)
  Enemy.super.new(self, x, y, image, 32, 65, 30, 29)
  self.type = 'enemy'
end

function Enemy:update(dt)
  Enemy.super.update(self, dt)
  local _, _, cols = world:check(self)
  for i = 1, #cols do
    local item = cols[i].other
    if item.type == 'explosion' then
      world:remove(self)
      return
    end
  end
end

return Enemy
