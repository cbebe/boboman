local Entity = require 'src.entity'
local Box = Entity:extend()

function Box:new(x, y, image)
  Box.super.new(self, x, y, image, 0, 0, 32, 32)
  self.type = 'box'
end

function Box:update(dt)
  Box.super.update(self, dt)
  local _, _, cols = world:check(self)
  for i = 1, #cols do
    local item = cols[i].other
    if item.type == 'explosion' then
      world:remove(self)
      return
    end
  end
end

return Box
