local Explosion = require 'src.explosion'
local Entity = require 'src.entity'
local Bomb = Entity:extend()

function Bomb:new(x, y, image, pid, strength, explodeThroughBoxes)
  Bomb.super.new(self, x, y, image, 0, 32, 28, 28)
  self.pid = pid
  self.newBomb = true
  self.type = 'bomb'
  self.timer = 2
  self.exploded = false
  self.strength = strength
  self.explodeThroughBoxes = explodeThroughBoxes
end

local function filterItems(x, y, type)
  local _, len = world:queryPoint(x, y, function(item)
    return item.type == type
  end)
  return len
end

local function placeExplosion(self, xTile, yTile)
  local x, y = (xTile * 32) + 1, (yTile * 32) + 1
  local wallLen, boxLen = filterItems(x, y, 'wall'), filterItems(x, y, 'box')
  if wallLen == 0 then
    Explosion(x, y, self.image)
  end
  return wallLen == 0 and (boxLen == 0 or self.explodeThroughBoxes)
end

local function explodeInLine(self, xTile, yTile, direction)
  for i = 1, self.strength do
    if not placeExplosion(self, xTile + direction.x * i, yTile + direction.y * i) then
      break
    end
  end
end

local DIRECTION = {
  left = { x = -1, y = 0 },
  right = { x = 1, y = 0 },
  up = { x = 0, y = -1 },
  down = { x = 0, y = 1 },
}

local function explode(self)
  self.exploded = true
  local xTile, yTile = self:getTile()
  world:remove(self)
  placeExplosion(self, xTile, yTile)
  for _, v in pairs(DIRECTION) do
    explodeInLine(self, xTile, yTile, v)
  end
end

function Bomb:update(dt)
  Bomb.super.update(self, dt)
  local _, _, cols, len = world:check(self)
  local onPlayer = false
  for i = 1, len do
    local other = cols[i].other
    if other.type == 'player' and other.pid == other.pid then
      onPlayer = true
    end
  end
  if self.newBomb and not onPlayer then
    self.newBomb = false
  end
  if not self.exploded then
    self.timer = self.timer - dt
    if self.timer <= 0 then
      explode(self)
    end
  end
end

return Bomb
