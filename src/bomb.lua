local Entity = require('src.entity')
local Bomb = Entity:extend()

function Bomb:new(x, y, image, pid)
  Bomb.super.new(self, x, y, image, 0, 32, 28, 28)
  self.pid = pid
  self.newBomb = true
  self.isBomb = true
end

function Bomb:update(dt)
  Bomb.super.update(dt)
  local _, _, cols, len = world:check(self)
  local onPlayer = false
  for i=1,len do
    local other = cols[i].other
    if other.isPlayer and other.pid == other.pid then
      onPlayer = true
    end
  end
  if self.newBomb and not onPlayer then
    self.newBomb = false
  end
end

return Bomb
