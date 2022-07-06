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

local function wallFilter(item)
  return item.type == 'wall'
end

local function boxFilter(item)
  return item.type == 'box'
end

function Bomb:placeExplosion(xTile, yTile)
  local x, y = (xTile * 32) + 1, (yTile * 32) + 1
  local _, wallLen = world:queryPoint(x, y, wallFilter)
  if wallLen == 0 then
    Explosion(x, y, self.image)
  end
  local _, boxLen = world:queryPoint(x, y, boxFilter)
  return wallLen == 0 and (boxLen == 0 or self.explodeThroughBoxes)
end

function Bomb:explodeInLine(xTile, yTile, direction)
  for i = 1, self.strength do
    if not self:placeExplosion(xTile + direction.x * i, yTile + direction.y * i) then
      break
    end
  end
end

local DIRECTION = {
  { x = -1, y = 0 }, -- left
  { x = 1, y = 0 }, -- right
  { x = 0, y = -1 }, -- up
  { x = 0, y = 1 }, -- down
}

function Bomb:explode(_)
  self.exploded = true
  local xTile, yTile = self:getTile()
  self:placeExplosion(xTile, yTile)
  for i = 1, #DIRECTION do
    self:explodeInLine(xTile, yTile, DIRECTION[i])
  end
  world:remove(self)
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
      self:explode(dt)
    end
  end
end

return Bomb
