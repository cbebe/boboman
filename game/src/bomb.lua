local Explosion = require 'src.explosion'
local Entity = require 'src.entity'
local Bomb = Entity:extend()

function Bomb:new(x, y, image, pid, strength)
  Bomb.super.new(self, x, y, image, 0, 32, 28, 28)
  self.pid = pid
  self.newBomb = true
  self.isBomb = true
  self.timer = 2
  self.exploded = false
  self.strength = strength
end

local function wallFilter(item)
  return item.isWall
end

local function placeExplosion(xTile, yTile, image)
  local x, y = (xTile * 32) + 1, (yTile * 32) + 1
  local _, len = world:queryPoint(x, y, wallFilter)
  if len == 0 then
    Explosion(x, y, image)
  end
  return len == 0
end

local function explodeInLine(xTile, yTile, strength, direction, image)
  for i = 1, strength do
    if not placeExplosion(xTile + direction.x * i, yTile + direction.y * i, image) then
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
  placeExplosion(xTile, yTile, self.image)
  for i = 1, #DIRECTION do
    explodeInLine(xTile, yTile, self.strength, DIRECTION[i], self.image)
  end
  world:remove(self)
end

function Bomb:update(dt)
  Bomb.super.update(self, dt)
  local _, _, cols, len = world:check(self)
  local onPlayer = false
  for i = 1, len do
    local other = cols[i].other
    if other.isPlayer and other.pid == other.pid then
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
